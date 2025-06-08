#include "map_drawer.h"

using namespace nlohmann;

// This magical constant is used to scale the columnScaling and
// lineScaling values from the LRIT image navigation header to the
// range where they are usable with the proj projections. It is
// only used when more accurate image navigation data is not
// available in the Ancillary Text Record.
//
// It is derived as follows: first, we must calculate the exact
// meters per pixel at nadir for a GOES-R full disk image, as a
// reference scale. The full-disk images are usually described as
// 2km per pixel, but if we look at the Ancillary Text Header, we
// find the following values:
//
//   perspective_point_height = 35786023 meters
//   x_scale_factor = 0.000056000 radians
//
// By multiplying perspective_point_height with x_scale_factor, we
// get an actual value of 2004.017288 meters per pixel. The proj
// projections return 1m per pixel resolution. To map one into the
// other, we can simply divide the proj projection by 2004.017288.
//
// Next, the LRIT spec at
// https://www.cgms-info.org/documents/pdf_cgms_03.pdf defines the
// column and line coordinates as follows:
//
//   c = COFF + nint(x * 2^-16 * CFAC);
//   l = LOFF + nint(y * 2^-16 * LFAC);
//
// With both CFAC and LFAC equal to 20425338 for the ABI full disk
// images, we can derive our magical constant as follows:
//
//   GEOS_CONST = (20425338.0 * 2004.017288) / 0x10000
//   GEOS_CONST = 624583.8999213157
//
// The 0x10000 divisor is removed from the computations below (and
// multiplication added to the offsets), such that there at 16
// fractional bits in the resulting coordinates that OpenCV can
// use for better anti-aliasing of the lines it draws.
//
// It should be noted that while 624583.8999213157 is the best
// value to use here, it is not completely accurate. This
// calculation is using CFAC/LFAC as they are transmitted in the
// image navigation header. Since GEOS_CONST is only used when
// only the ancillary text header is not available, it's the best
// reference point we can use since it is consistent with the
// data we will be processing.
//
// However, if we wanted to use a similar constant for use with
// data derived from the more accurate ancillary text header, we
// should re-calculate CFAC/LFAC to get a more accurate constant.
// CFAC/LFAC can be accurately computed as such:
//
//   CFAC = 0x10000 / (0.000056 * (180 / pi))
//   CFAC = 20425338.9
//
// Now, we can re-compute GEOS_CONST:
//
//   GEOS_CONST = (20425338.9 * 2004.017288) / 0x10000
//   GEOS_CONST = 624583.9274423050
//
// This other GEOS_CONST is only documented here for completeness,
// and is not currently used. If the const is used with otherwise
// accurate image navigation data, it should be switched to
// 624583.9274423050. The difference between the two is small, but
// it does adjust the correct placement of a few pixels.
#define GEOS_CONST 624583.8999213157

namespace {

Proj longitudeToProj(float longitude) {
  std::map<std::string, std::string> args;
  args["proj"] = "geos";
  args["h"] = "35786023.0";
  args["lon_0"] = std::to_string(longitude);
  args["sweep"] = "x";
  return Proj(args);
}

} // namespace

MapDrawer::MapDrawer(
  const Config::Handler* config,
  float longitude,
  lrit::ImageNavigationHeader inh)
  : config_(config),
    proj_(longitudeToProj(longitude)),
    columnOffset_(0x10000 * inh.columnOffset),
    lineOffset_(0x10000 * inh.lineOffset),
    columnMultiplier_(inh.columnScaling / GEOS_CONST),
    lineMultiplier_(inh.lineScaling / GEOS_CONST) {
  setup();
}

MapDrawer::MapDrawer(
  const Config::Handler* config,
  float longitude,
  double columnOffset,
  double lineOffset,
  double columnScaling,
  double lineScaling)
  : config_(config),
    proj_(longitudeToProj(longitude)),
    columnOffset_(0x10000 * columnOffset),
    lineOffset_(0x10000 * lineOffset),
    columnMultiplier_(0x10000 / columnScaling),
    lineMultiplier_(0x10000 / lineScaling){
  setup();
}

void MapDrawer::setup() {
  const auto& maps = config_->maps;
  points_.resize(maps.size());
  for (size_t i = 0; i < maps.size(); i++) {
    generatePoints(maps[i], points_[i]);
  }
}

void MapDrawer::generatePoints(
    std::vector<std::vector<cv::Point>>& out,
    const json& coords) {
  std::vector<cv::Point> points;
  double lat, lon;
  double x, y;
  for (const auto& coord : coords) {
    lon = proj_torad(coord.at(0).get<double>());
    lat = proj_torad(coord.at(1).get<double>());
    std::tie(x, y) = proj_.fwd(lon, lat);

    // If out of range, ignore
    if (fabs(x) > 1e10f || fabs(y) > 1e10f) {
      if (points.size() >= 2) {
        out.push_back(std::move(points));
      }
      points.clear();
      continue;
    }

    auto c = columnOffset_ + x * columnMultiplier_;
    auto l = lineOffset_ - y * lineMultiplier_;
    points.emplace_back(c, l);
  }

  if (points.size() >= 2) {
    out.push_back(std::move(points));
  }
}

void MapDrawer::generatePoints(const Config::Map& map, std::vector<std::vector<cv::Point>>& out) {
  // Iterate over features to aggregate line segments to draw
  for (const auto& feature : map.geo->at("features")) {
    // Expect every element to be of type "Feature"
    if (feature["type"] != "Feature") {
      continue;
    }

    const auto& geometry = feature["geometry"];
    if (geometry["type"] == "Polygon") {
      for (const auto& poly0 : geometry["coordinates"]) {
        generatePoints(out, poly0);
      }
    } else if (geometry["type"] == "MultiPolygon") {
      for (const auto& poly0 : geometry["coordinates"]) {
        for (const auto& poly1 : poly0) {
          generatePoints(out, poly1);
        }
      }
    } else if (geometry["type"] == "LineString") {
      generatePoints(out, geometry["coordinates"]);
    }
  }
}

cv::Mat MapDrawer::draw(cv::Mat& in) {
  // Convert grayscale image to color image to
  // accommodate colored map overlays.
  cv::Mat out;
  if (in.channels() == 1) {
    cv::cvtColor(in, out, cv::COLOR_GRAY2RGB);
  } else {
    out = in;
  }

  const auto& maps = config_->maps;
  for (size_t i = 0; i < maps.size(); i++) {
    cv::polylines(
      out,
      points_[i],
      false,
      maps[i].color,
      1,
      8,
      16);
  }

  return out;
}

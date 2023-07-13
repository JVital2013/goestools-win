#include "source.h"

#include <algorithm>

#include "airspy_source.h"
#include "rtlsdr_source.h"
#include "nanomsg_source.h"

std::unique_ptr<Source> Source::build(
    const std::string& type,
    Config& config) {
  if (type == "airspy") {
    auto airspy = Airspy::open();

    // Use sample rate if set, otherwise default to lowest possible rate.
    // This is 2.5MSPS for the R2 and 3M for the Mini.
    auto rates = airspy->getSampleRates();
    if (config.airspy.sampleRate != 0) {
      auto rate = config.airspy.sampleRate;
      auto pos = std::find(rates.begin(), rates.end(), rate);
      if (pos == rates.end()) {
        std::stringstream ss;
        ss <<
          "You configured the Airspy source to use an unsupported " <<
          "sample rate equal to " << rate << ". " <<
          "Supported sample rates are: " << std::endl;
        for (size_t i = 0; i < rates.size(); i++) {
          ss << " - " << rates[i] << std::endl;
        }
        throw std::runtime_error(ss.str());
      }
      airspy->setSampleRate(rate);
    } else {
      std::sort(rates.begin(), rates.end());
      airspy->setSampleRate(rates[0]);
    }
    airspy->setFrequency(config.airspy.frequency);
    airspy->setGain(config.airspy.gain);
    airspy->setBiasTee(config.airspy.bias_tee);
    airspy->setSamplePublisher(std::move(config.airspy.samplePublisher));
    return std::unique_ptr<Source>(airspy.release());
  }
  if (type == "rtlsdr") {
    auto rtlsdr = RTLSDR::open(config.rtlsdr.deviceIndex);

    // Use sample rate if set, otherwise default to 2.4MSPS.
    if (config.rtlsdr.sampleRate != 0) {
      rtlsdr->setSampleRate(config.rtlsdr.sampleRate);
    } else {
      rtlsdr->setSampleRate(2400000);
    }
    rtlsdr->setFrequency(config.rtlsdr.frequency);
    rtlsdr->setTunerGain(config.rtlsdr.gain);
    rtlsdr->setBiasTee(config.rtlsdr.bias_tee);
    rtlsdr->setSamplePublisher(std::move(config.rtlsdr.samplePublisher));
    return std::unique_ptr<Source>(rtlsdr.release());
  }
  if (type == "nanomsg") {
    auto nanomsg = Nanomsg::open(config);
    nanomsg->setSampleRate(config.nanomsg.sampleRate);
    nanomsg->setSamplePublisher(std::move(config.nanomsg.samplePublisher));
    return std::unique_ptr<Source>(nanomsg.release());
  }

  throw std::runtime_error("Invalid source: " + type);
}

Source::~Source() {
}

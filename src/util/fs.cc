#include "fs.h"

#include <direct.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <util/error.h>

namespace util {

void mkdirp(const std::string& path) {
  size_t pos = 0;
  for (;; pos++) {
    pos = path.find('/', pos);
    if (pos == 0) {
      continue;
    }
    auto sub = path.substr(0, pos);
    auto rv = _mkdir(sub.c_str());
    if (rv == -1 && errno != EEXIST) {
      perror("mkdir");
      ASSERT(rv == 0);
    }
    if (pos == std::string::npos) {
      break;
    }
  }
}

} // namespace util

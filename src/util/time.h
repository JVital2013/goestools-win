#pragma once

#include <ctime>
#include <string>
#include "strptime.h"

namespace util {

std::string stringTime();

bool parseTime(const std::string& in, struct timespec* ts);

} // namespace util

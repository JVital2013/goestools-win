#include <signal.h>
#include <iostream>

#include "config.h"
#include "decoder.h"
#include "demodulator.h"
#include "monitor.h"
#include "options.h"
#include "publisher.h"

#include <windows.h>

static bool sigint = false;

static void signalHandler(int signum) {
  fprintf(stderr, "Signal caught, exiting!\n");
  sigint = true;
}

int main(int argc, char** argv) {
  auto opts = parseOptions(argc, argv);
  auto config = Config::load(opts.config);

  // Convert string option to enum
  Demodulator::Type downlinkType;
  if (config.demodulator.downlinkType == "lrit") {
    downlinkType = Demodulator::LRIT;
  } else if (config.demodulator.downlinkType == "hrit") {
    downlinkType = Demodulator::HRIT;
  } else {
    std::cerr
      << "Invalid downlink type: "
      << config.demodulator.downlinkType
      << std::endl;
    exit(1);
  }

  Demodulator demod(downlinkType);
  demod.initialize(config);

  Decoder decode(demod.getSoftBitsQueue());
  decode.initialize(config);

  Monitor monitor(opts.verbose, opts.interval);
  monitor.initialize(config);

  // Install signal handler
  signal(SIGINT, signalHandler);
  signal(SIGTERM, signalHandler);
  signal(SIGBREAK, signalHandler);

  demod.start();
  decode.start();
  monitor.start();

  while (!sigint) {
    Sleep(1000);
  }

  demod.stop();
  decode.stop();
  monitor.stop();

  return 0;
}

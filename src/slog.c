#include <pthread.h>
#include <stdlib.h>

#include "slog/slog.h"
#include "shared/funcs.h"

#define MAX_SLOG_LEVEL 7

//==============================================================================
// Prototypes
//==============================================================================

void* _slog_setup(uint8_t);

void _slog_logging(uint32_t m, uint32_t n);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 0 : (uint8_t)atoi(argv[1]);

  env->setup_func = _slog_setup;
  env->logging_func = _slog_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = logLevel;

  run_test(env, "slog");
}

void*
_slog_setup(uint8_t logLevel) {
  slog_config_t slogCfg;
  int           enabledLogLevels = 0;
  int           threading = 0;

  // Enable every log level at or above the given log level
  for (uint8_t i = MAX_SLOG_LEVEL; i > 0; --i) {
    if (logLevel <= i) {
      enabledLogLevels ^= 1;
    }

    enabledLogLevels <<= 1;
  }

  slog_init("logs/slog.txt", enabledLogLevels, threading);

  slog_config_get(&slogCfg);
  slogCfg.nToScreen = 0;
  slogCfg.nToFile = 1;
  slog_config_set(&slogCfg);

  return NULL;
}

void
_slog_logging(uint32_t m, uint32_t n) {
  slog_info("A(%u, %u)", m, n);
  slog_debug("A(%u, %u)", m, n);
}

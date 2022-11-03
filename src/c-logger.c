#include <pthread.h>
#include <stdlib.h>

#include "c-logger/logger.h"
#include "shared/funcs.h"

#define MAX_FILE_SIZE 26214400  // 25 MiB
#define MAX_NUM_FILES 255

//==============================================================================
// Prototypes
//==============================================================================

void* _c_logger_setup(uint8_t);

void _c_logger_logging(uint32_t m, uint32_t n);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 0 : (uint8_t)atoi(argv[1]);

  env->setup_func = _c_logger_setup;
  env->logging_func = _c_logger_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = logLevel;

  run_test(env, "c-logger");
}

void*
_c_logger_setup(uint8_t logLevel) {
  if (!logger_initFileLogger("logs/c-logger.txt", MAX_FILE_SIZE, MAX_NUM_FILES)) {
    pthread_exit(NULL);
  }
  logger_setLevel((LogLevel)logLevel);

  return NULL;
}

void
_c_logger_logging(uint32_t m, uint32_t n) {
  LOG_DEBUG("A(%u, %u)", m, n);
  LOG_WARN("A(%u, %u)", m, n);
}

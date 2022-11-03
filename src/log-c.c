#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "log-c/log.h"
#include "shared/funcs.h"

//==============================================================================
// Prototypes
//==============================================================================

void* _log_c_setup(uint8_t);

void _log_c_logging(uint32_t m, uint32_t n);

void _log_c_tear_down(void* stream);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 0 : (uint8_t)atoi(argv[1]);

  env->setup_func = _log_c_setup;
  env->logging_func = _log_c_logging;
  env->tear_down_func = _log_c_tear_down;
  env->logLevel = logLevel;

  run_test(env, "log.c");
}

void*
_log_c_setup(uint8_t logLevel) {
  FILE* fileHandle = fopen("logs/log-c.txt", "w");

  if (errno) {
    pthread_exit(NULL);
  }

  log_set_quiet(1);
  log_add_fp(fileHandle, (int)logLevel);

  return (void*)fileHandle;
}

void
_log_c_logging(uint32_t m, uint32_t n) {
  log_debug("A(%u, %u)", m, n);
  log_warn("A(%u, %u)", m, n);
}

void
_log_c_tear_down(void* stream) {
  fclose((FILE*)stream);
}

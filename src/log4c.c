#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "log4c/log4c.h"
#include "shared/funcs.h"

//==============================================================================
// Global Variables (Forgive Me)
//==============================================================================

thread_local log4c_category_t* c = NULL;

//==============================================================================
// Prototypes
//==============================================================================

void* _log4c_setup(uint8_t);

void _log4c_logging(uint32_t m, uint32_t n);

void _log4c_tear_down(void* arg);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 1 : ((uint8_t)atoi(argv[1]) + 1);

  env->setup_func = _zf_log_setup;
  env->logging_func = _zf_log_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = logLevel;

  run_test(env, "zf_log");
}

void*
_log4c_setup(uint8_t logLevel) {
  char levelName[3];

  if (log4c_init()) {
    pthread_exit(NULL);
  }

  sprintf(levelName, "%u", logLevel);
  c = log4c_category_get(levelName);
  if (!c) {
    pthread_exit(NULL);
  }
}

void
_log4c_logging(uint32_t m, uint32_t n) {
  log4c_category_log(c, LOG4C_PRIORITY_DEBUG, "A(%u, %u)", m, n);
  log4c_category_log(c, LOG4C_PRIORITY_NOTICE, "A(%u, %u)", m, n);
}

void
_log4c_tear_down(void* arg) {
  log4c_fini();
}

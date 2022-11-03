#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <threads.h>

#include "zlog/zlog.h"
#include "shared/funcs.h"

//==============================================================================
// Global Variables (Forgive Me)
//==============================================================================

thread_local zlog_category_t* c = NULL;

//==============================================================================
// Prototypes
//==============================================================================

void* _zlog_setup(uint8_t);

void _zlog_logging(uint32_t m, uint32_t n);

void _zlog_tear_down(void* stream);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 0 : (uint8_t)atoi(argv[1]);

  env->setup_func = _zlog_setup;
  env->logging_func = _zlog_logging;
  env->tear_down_func = _zlog_tear_down;
  env->logLevel = logLevel;

  run_test(env, "zlog");
}

void*
_zlog_setup(uint8_t logLevel) {
  char levelName[2];

  if (zlog_init("resources/zlog.conf")) {
    printf("1\n");
    pthread_exit(NULL);
  }

  sprintf(levelName, "%u", logLevel);
  c = zlog_get_category(levelName);
  if (!c) {
    printf("2\n");
    pthread_exit(NULL);
  }

  return NULL;
}

void
_zlog_logging(uint32_t m, uint32_t n) {
  zlog_info(c, "A(%u, %u)", m, n);
  zlog_warn(c, "A(%u, %u)", m, n);
}

void
_zlog_tear_down(void* stream) {
  zlog_fini();
}

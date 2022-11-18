#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "shared/funcs.h"

#define LOG_LEVEL_NAME "TRACE"

//==============================================================================
// Prototypes
//==============================================================================

void _full_format_logging(uint32_t m, uint32_t n);

void _some_format_logging(uint32_t m, uint32_t n);

void _no_format_logging(uint32_t m, uint32_t n);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));

  env->setup_func = no_setup;
  env->logging_func = _full_format_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = 0;

  run_test(env, "control");
}

void _full_format_logging(uint32_t m, uint32_t n) {
  time_t  timestamp = time(NULL);

  printf("%s %s:%d - A(%u, %u) %s", LOG_LEVEL_NAME, __FILE__, __LINE__, m, n, asctime(gmtime(&timestamp)));
}

void _some_format_logging(uint32_t m, uint32_t n) {
  printf("TRACE 22-11-18 16:42:23.835906 src/control.c:42 - A(%u, %u)\n", m, n);
}

void _no_format_logging(uint32_t m, uint32_t n) {
  printf("TRACE 22-11-18 16:42:23.835906 src/control.c:46 - A(XX, YY)\n");
}

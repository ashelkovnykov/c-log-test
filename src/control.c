#include <stdlib.h>

#include "shared/funcs.h"

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));

  env->setup_func = no_setup;
  env->logging_func = no_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = 0;

  run_test(env, "control");
}

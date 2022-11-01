#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "control/test.h"
#include "shared/shared.h"

//==============================================================================
// Prototypes
//==============================================================================

/// Helper function to log errors to stderr and cease execution.
///
/// @param[in]  msg   Error message
///
/// @return   Non-zero exit code
int
report_failure(const char* msg);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TimingResult* result;
  pthread_t     controlThread;

  //
  // Launch test threads
  //

  printf("Starting threads...\n");
  if (pthread_create(&controlThread, NULL, control_func, NULL)) {
    return report_failure("Cannot create control thread");
  }

  //
  // Collect finished threads
  //

  if (pthread_join(controlThread, (void**)&result)) {
    return report_failure("Execution failure in control thread");
  }
  printf("Control thread: runtime = %.3f s, result = %u\n", result->time, result->a);

  //
  // Clean up
  //

  printf("Complete\n");

  free((void *)result);

  return 0;
}

int
report_failure(const char* msg) {
  fprintf(stderr, "ERROR: %s\n", msg);
  return -1;
}

#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "funcs.h"
#include "types.h"

//==============================================================================
// Prototypes
//==============================================================================

/// Helper function to log errors to stderr and cease execution.
///
/// @param[in]  msg   Error message
void
_report_failure(const char* msg);

//==============================================================================
// Functions
//==============================================================================

uint32_t
ackermann(uint32_t m, uint32_t n, void (*logging_func)(uint32_t, uint32_t)) {
  logging_func(m, n);

  if (!m) {
    return (n + 1);
  } else if (!n) {
    return ackermann(m - 1, 1, logging_func);
  } // else
  return ackermann(m - 1, ackermann(m, n - 1, logging_func), logging_func);
}

void*
timed_ackermann(void* arg) {
  TestSetup*    testSetup = (TestSetup*)arg;
  TimingResult* result = malloc(sizeof(TimingResult));
  void*         testState;
  clock_t       tStart;
  clock_t       tEnd;

  testState = testSetup->setup_func(testSetup->logLevel);

  tStart = clock();
  result->a = ackermann(ACKERMANN_M, ACKERMANN_N, testSetup->logging_func);
  tEnd = clock();

  testSetup->tear_down_func(testState);

  result->time = (1.0 * (tEnd - tStart) / CLOCKS_PER_SEC);

  return (void *)result;
}

void
run_test(TestSetup* testSetup, const char* description) {
  TimingResult* result;
  pthread_t     thread;

  //
  // Launch test thread
  //

  printf("Starting %s test...\n", description);

  if (pthread_create(&thread, NULL, timed_ackermann, (void*)testSetup)) {
    _report_failure("Cannot create thread");
  }

  //
  // Collect test thread
  //

  if (pthread_join(thread, (void**)&result)) {
    _report_failure("Thread failure");
  }
  if (result == NULL) {
    _report_failure("Execution failure");
  }
  printf("%s: runtime = %.3f s, result = %u\n", description, result->time, result->a);

  //
  // Clean up
  //

  printf("Complete\n");

  free((void *)result);
  free((void *)testSetup);

  exit(0);
}

void* no_setup(uint8_t l) {
  return NULL;
}

void no_logging(uint32_t m, uint32_t n) {}

void no_tear_down(void* arg) {}

//==============================================================================
// Private Functions
//==============================================================================

void
_report_failure(const char* msg) {
  fprintf(stderr, "ERROR: %s\n", msg);
  exit(-1);
}

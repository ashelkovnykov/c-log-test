#pragma once

#include <stdint.h>

//==============================================================================
// Types
//==============================================================================

typedef struct test_setup_t {
  void*   (*setup_func)(uint8_t);               // Setup logger
  void    (*logging_func)(uint32_t, uint32_t);  // Logging logic
  void    (*tear_down_func)(void*);             // Tear down logger
  uint8_t logLevel;                             // Logging level, to pass to setup function
} TestSetup;

typedef struct timing_result_t {
  double    time; // Time to complete test
  uint32_t  a;    // Ackermann function result
} TimingResult;

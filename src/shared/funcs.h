#pragma once

#include <stdint.h>

#include "types.h"

#define ACKERMANN_M 3
#define ACKERMANN_N 6

//==============================================================================
// Prototypes
//==============================================================================

/// Compute the result of the Ackermann function:
/// https://en.wikipedia.org/wiki/Ackermann_function
///
/// @param[in]  m   First argument to Ackermann function
/// @param[in]  n   Second argument to Ackermann function
///
/// @return   Result of A(m, n)
uint32_t
ackermann(uint32_t m, uint32_t n, void (*logging_func)(uint32_t, uint32_t));

/// Wrapper to setup logging and time the computation of the Ackermann function
///
/// @param[in]  arg   TestSetup handle
///
/// @return   TimingResult handle
void*
timed_ackermann(void* arg);

/// Run a timed Ackermann function computation test in a new thread
///
/// @param[in]  testSetup     Logging environment
/// @param[in]  description   Description or name of test to use when logging
///                           errors/results
void
run_test(TestSetup* testSetup, const char* description);

/// Dummy logging setup function which does nothing
void* no_setup(uint8_t);

/// Dummy logging function which does nothing
void no_logging(uint32_t, uint32_t);

/// Dummy logging tear-down function which does nothing
void no_tear_down(void*);

#pragma once

#include <stdint.h>

//==============================================================================
// Types
//==============================================================================

typedef struct timing_result_t {
  double    time; // Time to complete test
  uint32_t  a;    // Ackermann function result
} TimingResult;

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
ackermann(uint32_t m, uint32_t n);

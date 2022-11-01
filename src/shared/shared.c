#include <stdint.h>

#include "shared.h"

//==============================================================================
// Functions
//==============================================================================

uint32_t
ackermann(uint32_t m, uint32_t n) {
  if (!m) {
    return (n + 1);
  } else if (!n) {
    return ackermann(m - 1, 1);
  } // else
  return ackermann(m - 1, ackermann(m, n - 1));
}

#include <stdlib.h>
#include <time.h>

#include "../shared/shared.h"
#include "test.h"

//==============================================================================
// Functions
//==============================================================================

void *
control_func(void* arg) {
  TimingResult* result = malloc(sizeof(TimingResult));
  clock_t       t_start = clock();
  clock_t       t_end;

  result->a = ackermann(4, 1);

  t_end = clock();
  result->time = (1.0 * (t_end - t_start) / CLOCKS_PER_SEC);

  return (void *)result;
}

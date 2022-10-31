#include <pthread.h>
#include <stdint.h>
#include <stdio.h>

#define NUM_THREADS 5
#define LOOPS       10

//==============================================================================
// Prototypes
//==============================================================================

void *thread_func(void *arg) {
  pthread_t threadId = pthread_self();
  uint8_t   n = *((uint8_t *)arg);

  for (uint8_t i = 0; i < n; ++i) {
    printf("%lu: %u\n", threadId, i);
  }

  return NULL;
}

//==============================================================================
// Functions
//==============================================================================

int main(int argc, char **argv) {
  pthread_t threads[NUM_THREADS];
  uint8_t   arg = LOOPS;

  printf("Starting threads...\n");

  for (uint8_t i = 0; i < NUM_THREADS; ++i) {
    if (pthread_create(&threads[i], NULL, thread_func, (void *)&arg)) {
      return -1;
    }
  }

  for (uint8_t i = 0; i < NUM_THREADS; ++i) {
    if (pthread_join(threads[i], NULL)) {
      printf("ERROR in thread %u", i);
    }
  }

  printf("Complete\n");

  return 0;
}

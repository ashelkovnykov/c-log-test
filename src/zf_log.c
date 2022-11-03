#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "zf_log/zf_log.h"
#include "shared/funcs.h"

//==============================================================================
// Prototypes
//==============================================================================

void* _zf_log_setup(uint8_t);

void _zf_log_logging(uint32_t m, uint32_t n);

void _zf_log_tear_down(void* arg);

void _zf_file_output_callback(const zf_log_message *msg, void *arg);

//==============================================================================
// Functions
//==============================================================================

int
main(int argc, char** argv) {
  TestSetup* env = malloc(sizeof(TestSetup));
  uint8_t    logLevel;

  logLevel = (argc == 1) ? 1 : ((uint8_t)atoi(argv[1]) + 1);

  env->setup_func = _zf_log_setup;
  env->logging_func = _zf_log_logging;
  env->tear_down_func = no_tear_down;
  env->logLevel = logLevel;

  run_test(env, "zf_log");
}

void*
_zf_log_setup(uint8_t logLevel) {
  FILE* fileHandle = fopen("logs/zf_log.txt", "a");

  if (fileHandle == NULL) {
    pthread_exit(NULL);
  }

  zf_log_set_output_v(ZF_LOG_PUT_STD, fileHandle, _zf_file_output_callback);
  zf_log_set_output_level((int)logLevel);

  return fileHandle;
}

void
_zf_log_logging(uint32_t m, uint32_t n) {
  ZF_LOGD("A(%u, %u)", m, n);
  ZF_LOGW("A(%u, %u)", m, n);
}

void
_zf_log_tear_down(void* arg) {
  fclose((FILE*)arg);
}

void
_zf_file_output_callback(const zf_log_message *msg, void *arg)
{
  FILE* fileHandle = (FILE*)arg;

  *msg->p = '\n';

  fwrite(msg->buf, msg->p - msg->buf + 1, 1, fileHandle);
  fflush(fileHandle);
}

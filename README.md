# c-log-test

This is a test repository for comparing the performance costs of logging using various C logging libraries.

## Libraries

This repo compares the following libraries:
- [c-logger](https://github.com/yksz/c-logger)
- [log.c](https://github.com/rxi/log.c)
- [slog](https://github.com/kala13x/slog)
- [zf-log](https://github.com/wonder-mice/zf_log)
- [zlog](https://github.com/HardySimpson/zlog)

There's some half-finished work to test [log4c](https://log4c.sourceforge.net/index.html), but it's a real pain to
compile and unlikely to be a useful lib, so for now that work is abandoned.

Each test is setup to log at levels 1 and 3 (the names of these levels are not consistent between logging libs).

## Usage

Simply clone the repo and run make with one of the following targets:
```text
all
c-logger
log-c
slog
zf-log
zlog
```
You can control the logging level for a test by setting the `LOG_LEVEL` environment variable to an integer between 0 and
5 (inclusive). The default is 0.

Ex.
```shell
make c-logger LOG_LEVEL=2
```

## Results

### Single Thread Tests

Notes:
- All numbers below are the average over 10 test runs
- All tests produced the correct output
- All tests output the same number of log messages
  - 44698325 for the less verbose tests
  - 89396650 for the more verbose tests
- The `zf_log` tests marked by an asterisk set the log level as a compile-time constant

| Test         | Time (s) | Messages/ms | Bytes/msg | Bytes/ms |
|--------------|----------|-------------|-----------|----------|
| Control      | 0.263    | n/a         | n/a       | n/a      |
| c-logger (4) | 0.620    | n/a         | n/a       | n/a      |
| c-logger (2) | 32.196   | 1416        | 59        | 81911    |
| c-logger (0) | 65.330   | 1381        | 59        | 80735    |
| log.c (4)    | 0.892    | n/a         | n/a       | n/a      |
| log.c (2)    | 137.518  | 327         | 52        | 16902    |
| log.c (0)    | 251.108  | 357         | 52        | 18512    |
| slog (4)     | 0.604    | n/a         | n/a       | n/a      |
| slog (2)     | 211.264  | 212         | 40        | 8463     |
| slog (0)     | 421.717  | 212         | 39        | 8267     |
| zf_log (4)   | 0.278    | n/a         | n/a       | n/a      |
| zf_log (2)   | 25.011   | 1787        | 73        | 130461   |
| zf_log (0)   | 45.469   | 1966        | 73        | 143525   |
| zf_log (4)*  | 0.260    | n/a         | n/a       | n/a      |
| zf_log (2)*  | 19.677   | 2272        | 73        | 165827   |
| zf_log (0)*  | 51.143   | 1748        | 73        | 127602   |
| zlog (4)     | 0.632    | n/a         | n/a       | n/a      |
| zlog (2)     | 104.067  | 432         | 58        | 24912    |
| zlog (0)     | 212.814  | 421         | 58        | 24364    |

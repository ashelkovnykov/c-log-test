#==============================================================================
# MACROS
#==============================================================================

CC := gcc
CSTD := -std=c11
DEV_CFLAGS := -Wall -Wextra -Wpedantic -Wformat=2 -Wno-unused-parameter \
             -Wshadow -Wwrite-strings -Wstrict-prototypes \
             -Wold-style-definition -Wredundant-decls -Wnested-externs \
             -Wmissing-include-dirs -Og
LINK_FLAGS := -lpthread

BIN_DIR := bin/
DEP_DIR := dep/
OBJ_DIR := obj/
SRC_DIR := src/
LOG_DIR := logs/

SHARED_DEP_DIR := dep/shared/
SHARED_OBJ_DIR := obj/shared/
SHARED_SRC_DIR := src/shared/

CLOGGER_DEP_DIR := dep/c-logger/
CLOGGER_OBJ_DIR := obj/c-logger/
CLOGGER_SRC_DIR := src/c-logger/

LOGC_DEP_DIR := dep/log-c/
LOGC_OBJ_DIR := obj/log-c/
LOGC_SRC_DIR := src/log-c/

SLOG_DEP_DIR := dep/slog/
SLOG_OBJ_DIR := obj/slog/
SLOG_SRC_DIR := src/slog/

ZLOG_DEP_DIR := dep/zlog/
ZLOG_OBJ_DIR := obj/zlog/
ZLOG_SRC_DIR := src/zlog/

SOURCES := $(shell ls $(SRC_DIR)*.c)
OBJECTS := $(subst $(SRC_DIR),$(OBJ_DIR),$(subst .c,.o,$(SOURCES)))
DEPFILES := $(subst $(SRC_DIR),$(DEP_DIR),$(subst .c,.d,$(SOURCES)))

SHARED_SOURCES := $(shell ls $(SHARED_SRC_DIR)*.c)
SHARED_OBJECTS := $(subst $(SHARED_SRC_DIR),$(SHARED_OBJ_DIR),$(subst .c,.o,$(SHARED_SOURCES)))
SHARED_DEPFILES := $(subst $(SHARED_SRC_DIR),$(SHARED_DEP_DIR),$(subst .c,.d,$(SHARED_SOURCES)))

CLOGGER_SOURCES := $(shell ls $(CLOGGER_SRC_DIR)*.c)
CLOGGER_OBJECTS := $(subst $(CLOGGER_SRC_DIR),$(CLOGGER_OBJ_DIR),$(subst .c,.o,$(CLOGGER_SOURCES)))
CLOGGER_DEPFILES := $(subst $(CLOGGER_SRC_DIR),$(CLOGGER_DEP_DIR),$(subst .c,.d,$(CLOGGER_SOURCES)))

LOGC_SOURCES := $(shell ls $(LOGC_SRC_DIR)*.c)
LOGC_OBJECTS := $(subst $(LOGC_SRC_DIR),$(LOGC_OBJ_DIR),$(subst .c,.o,$(LOGC_SOURCES)))
LOGC_DEPFILES := $(subst $(LOGC_SRC_DIR),$(LOGC_DEP_DIR),$(subst .c,.d,$(LOGC_SOURCES)))

SLOG_SOURCES := $(shell ls $(SLOG_SRC_DIR)*.c)
SLOG_OBJECTS := $(subst $(SLOG_SRC_DIR),$(SLOG_OBJ_DIR),$(subst .c,.o,$(SLOG_SOURCES)))
SLOG_DEPFILES := $(subst $(SLOG_SRC_DIR),$(SLOG_DEP_DIR),$(subst .c,.d,$(SLOG_SOURCES)))

ZLOG_SOURCES := $(shell ls $(ZLOG_SRC_DIR)*.c)
ZLOG_OBJECTS := $(subst $(ZLOG_SRC_DIR),$(ZLOG_OBJ_DIR),$(subst .c,.o,$(ZLOG_SOURCES)))
ZLOG_DEPFILES := $(subst $(ZLOG_SRC_DIR),$(ZLOG_DEP_DIR),$(subst .c,.d,$(ZLOG_SOURCES)))

CONTROL_CMD := control
CLOGGER_CMD := c-logger
LOGC_CMD := log-c
SLOG_CMD := slog
ZLOG_CMD := zlog

CONTROL_OBJ := $(addsuffix .o,$(addprefix $(OBJ_DIR),$(CONTROL_CMD)))
CLOGGER_OBJ := $(addsuffix .o,$(addprefix $(OBJ_DIR),$(CLOGGER_CMD)))
LOGC_OBJ := $(addsuffix .o,$(addprefix $(OBJ_DIR),$(LOGC_CMD)))
SLOG_OBJ := $(addsuffix .o,$(addprefix $(OBJ_DIR),$(SLOG_CMD)))
ZLOG_OBJ := $(addsuffix .o,$(addprefix $(OBJ_DIR),$(ZLOG_CMD)))

CONTROL_BIN := $(addprefix $(BIN_DIR),$(CONTROL_CMD))
CLOGGER_BIN := $(addprefix $(BIN_DIR),$(CLOGGER_CMD))
LOGC_BIN := $(addprefix $(BIN_DIR),$(LOGC_CMD))
SLOG_BIN := $(addprefix $(BIN_DIR),$(SLOG_CMD))
ZLOG_BIN := $(addprefix $(BIN_DIR),$(ZLOG_CMD))

#==============================================================================
# ARGUMENTS
#==============================================================================

LOG_LEVEL :=

#==============================================================================
# RULES
#==============================================================================

# Default target. Compile & link all source files, then print usage instructions.
#
default : $(PERFORMANCE_BIN) help

# Helpful rule which lists all other rules and encourages documentation
#
# target: help - Display all targets in makefile
#
help :
	@egrep "^# target:" makefile

# Run all performance tests
#
# target: run - Run all performance tests
#
all : control c-logger log-c slog zlog

# Run control performance test
#
# target: control - Run control performance test
#
control : bin $(CONTROL_BIN)
	@$(CONTROL_BIN)

# Run c-logger performance test
#
# target: c-logger - Run c-logger performance test
#
c-logger : bin logs $(CLOGGER_BIN)
	@$(CLOGGER_BIN) $(LOG_LEVEL)

# Run log.c performance test
#
# target: log-c - Run log.c performance test
#
log-c : bin logs $(LOGC_BIN)
	@$(LOGC_BIN) $(LOG_LEVEL)

# Run slog performance test
#
# target: slog - Run slog performance test
#
slog : bin logs $(SLOG_BIN)
	@$(SLOG_BIN) $(LOG_LEVEL)

# Run zlog performance test
#
# target: zlog - Run zlog performance test
#
zlog : bin logs $(ZLOG_BIN)
	@$(ZLOG_BIN) $(LOG_LEVEL)

# Link executable binary for control test
#
$(CONTROL_BIN) : $(CONTROL_OBJ) $(SHARED_OBJECTS)
	$(CC) $^ $(LINK_FLAGS) -o $@

# Link executable binary for c-logger test
#
$(CLOGGER_BIN) : $(CLOGGER_OBJ) $(SHARED_OBJECTS) $(CLOGGER_OBJECTS)
	$(CC) $^ $(LINK_FLAGS) -o $@

# Link executable binary for log.c test
#
$(LOGC_BIN) : $(LOGC_OBJ) $(SHARED_OBJECTS) $(LOGC_OBJECTS)
	$(CC) $^ $(LINK_FLAGS) -o $@

# Link executable binary for slog test
#
$(SLOG_BIN) : $(SLOG_OBJ) $(SHARED_OBJECTS) $(SLOG_OBJECTS)
	$(CC) $^ $(LINK_FLAGS) -o $@

# Link executable binary for zlog test
#
$(ZLOG_BIN) : $(ZLOG_OBJ) $(SHARED_OBJECTS) $(ZLOG_OBJECTS)
	$(CC) $^ $(LINK_FLAGS) -o $@

# Compile all source files, but do not link. As a side effect, compile a dependency file for each source file.
#
# Dependency files are a common makefile feature used to speed up builds by auto-generating granular makefile targets.
# These files minimize the number of targets that need to be recomputed when source files are modified and can lead to
# massive build-time improvements.

# For more information, see the "-M" option documentation in the GCC man page, as well as this paper:
# https://web.archive.org/web/20150319074420/http://aegis.sourceforge.net/auug97.pdf
#
$(addprefix $(DEP_DIR),%.d) : $(addprefix $(SRC_DIR),%.c)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(DEV_CFLAGS)

# Same as above, but specifically for control files
#
$(addprefix $(SHARED_DEP_DIR),%.d): $(addprefix $(SHARED_SRC_DIR),%.c)
	@mkdir -p $(SHARED_OBJ_DIR)
	@mkdir -p $(SHARED_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Same as above, but specifically for c-logger files
#
$(addprefix $(CLOGGER_DEP_DIR),%.d): $(addprefix $(CLOGGER_SRC_DIR),%.c)
	@mkdir -p $(CLOGGER_OBJ_DIR)
	@mkdir -p $(CLOGGER_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Same as above, but specifically for log.c files
#
$(addprefix $(LOGC_DEP_DIR),%.d): $(addprefix $(LOGC_SRC_DIR),%.c)
	@mkdir -p $(LOGC_OBJ_DIR)
	@mkdir -p $(LOGC_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Same as above, but specifically for slog files
#
$(addprefix $(SLOG_DEP_DIR),%.d): $(addprefix $(SLOG_SRC_DIR),%.c)
	@mkdir -p $(SLOG_OBJ_DIR)
	@mkdir -p $(SLOG_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Same as above, but specifically for zlog files
#
$(addprefix $(ZLOG_DEP_DIR),%.d): $(addprefix $(ZLOG_SRC_DIR),%.c)
	@mkdir -p $(ZLOG_OBJ_DIR)
	@mkdir -p $(ZLOG_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Force build of dependency and object files to import additional makefile targets
#
-include $(DEPFILES) $(SHARED_DEPFILES) $(CLOGGER_DEPFILES) $(LOGC_DEPFILES) $(SLOG_DEPFILES) $(ZLOG_DEPFILES)

# Make directory for binaries
#
bin :
	@mkdir -p $(BIN_DIR)

# Make directory for logs
#
logs :
	@mkdir -p $(LOG_DIR)

# Clean up files produced by the makefile. Any invocation should execute, regardless of file modification date, hence
# dependency on FRC.
#
# target: clean - Remove all files produced by this makefile
clean : FRC
	@rm -rf $(BIN_DIR) $(DEP_DIR) $(OBJ_DIR) $(LOG_DIR)

# Special pseudo target which always needs to be recomputed. Forces full rebuild of target every time when used as a
# component.
FRC :

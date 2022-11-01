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

SHARED_DEP_DIR := dep/shared/
SHARED_OBJ_DIR := obj/shared/
SHARED_SRC_DIR := src/shared/

CONTROL_DEP_DIR := dep/control/
CONTROL_OBJ_DIR := obj/control/
CONTROL_SRC_DIR := src/control/

SOURCES := $(shell ls $(SRC_DIR)*.c)
OBJECTS := $(subst $(SRC_DIR),$(OBJ_DIR),$(subst .c,.o,$(SOURCES)))
DEPFILES := $(subst $(SRC_DIR),$(DEP_DIR),$(subst .c,.d,$(SOURCES)))

SHARED_SOURCES := $(shell ls $(SHARED_SRC_DIR)*.c)
SHARED_OBJECTS := $(subst $(SHARED_SRC_DIR),$(SHARED_OBJ_DIR),$(subst .c,.o,$(SHARED_SOURCES)))
SHARED_DEPFILES := $(subst $(SHARED_SRC_DIR),$(SHARED_DEP_DIR),$(subst .c,.d,$(SHARED_SOURCES)))

CONTROL_SOURCES := $(shell ls $(CONTROL_SRC_DIR)*.c)
CONTROL_OBJECTS := $(subst $(CONTROL_SRC_DIR),$(CONTROL_OBJ_DIR),$(subst .c,.o,$(CONTROL_SOURCES)))
CONTROL_DEPFILES := $(subst $(CONTROL_SRC_DIR),$(CONTROL_DEP_DIR),$(subst .c,.d,$(CONTROL_SOURCES)))

PERFORMANCE_CMD := $(addprefix $(BIN_DIR),main)

#==============================================================================
# RULES
#==============================================================================

# Default target. Compile & link all source files, then print usage instructions.
#
default : $(PERFORMANCE_CMD) help

# Helpful rule which lists all other rules and encourages documentation
#
# target: help - Display all targets in makefile
#
help :
	@egrep "^# target:" makefile

# Run performance tests
#
# target: run - Run performance tests
#
run : $(PERFORMANCE_CMD)
	@$(PERFORMANCE_CMD)

# Link benchmark suite into an executable binary
#
$(PERFORMANCE_CMD) : $(OBJECTS) $(SHARED_OBJECTS) $(CONTROL_OBJECTS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJECTS) $(SHARED_OBJECTS) $(CONTROL_OBJECTS) $(LINK_FLAGS) -o $@

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

# Same as above, but specifically for shared files
#
$(addprefix $(SHARED_DEP_DIR),%.d): $(addprefix $(SHARED_SRC_DIR),%.c)
	@mkdir -p $(SHARED_OBJ_DIR)
	@mkdir -p $(SHARED_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Same as above, but specifically for control files
#
$(addprefix $(CONTROL_DEP_DIR),%.d): $(addprefix $(CONTROL_SRC_DIR),%.c)
	@mkdir -p $(CONTROL_OBJ_DIR)
	@mkdir -p $(CONTROL_DEP_DIR)
	$(CC) -MD -MP -MF $@ -MT '$@ $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o))' \
		$< -c -o $(subst $(DEP_DIR),$(OBJ_DIR),$(@:.d=.o)) $(CSTD) $(PARAMS) $(DEV_CFLAGS)

# Force build of dependency and object files to import additional makefile targets
#
-include $(DEPFILES) $(SHARED_DEPFILES) $(CONTROL_DEPFILES)

# Clean up files produced by the makefile. Any invocation should execute, regardless of file modification date, hence
# dependency on FRC.
#
# target: clean - Remove all files produced by this makefile
clean : FRC
	@rm -rf $(BIN_DIR) $(DEP_DIR) $(OBJ_DIR)

# Special pseudo target which always needs to be recomputed. Forces full rebuild of target every time when used as a
# component.
FRC :

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

SOURCES := $(shell ls $(SRC_DIR)*.c)
OBJECTS := $(subst $(SRC_DIR),$(OBJ_DIR),$(subst .c,.o,$(SOURCES)))
DEPFILES := $(subst $(SRC_DIR),$(DEP_DIR),$(subst .c,.d,$(SOURCES)))

PERFORMANCE_CMD := $(addprefix $(BIN_DIR),performance)

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
$(PERFORMANCE_CMD) : $(OBJECTS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJECTS) $(LINK_FLAGS) -o $@

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

# Force build of dependency and object files to import additional makefile targets
#
-include $(DEPFILES)

# Clean up files produced by the makefile. Any invocation should execute, regardless of file modification date, hence
# dependency on FRC.
#
# target: clean - Remove all files produced by this makefile
clean : FRC
	@rm -rf $(BIN_DIR) $(DEP_DIR) $(OBJ_DIR)

# Special pseudo target which always needs to be recomputed. Forces full rebuild of target every time when used as a
# component.
FRC :

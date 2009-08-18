#
# $Id$
#

# GNU MAKE file for Borland/CodeGear C/C++ 32-bit (4.x-)

OBJ_EXT := .obj
LIB_PREF :=
LIB_EXT := .lib

HB_DYN_COPT := -DHB_DYNLIB

CC := bcc32.exe
CC_IN := -c
CC_OUT := -o

CPPFLAGS := -I. -I$(HB_INC_COMPILE)
CFLAGS := -q -tWM
LDFLAGS :=

ifneq ($(HB_BUILD_WARN),no)
   CFLAGS += -w -w-sig- -Q
endif

ifneq ($(HB_BUILD_OPTIM),no)
   # for some reason -6 generates the exact same code as -4 with both 5.5 and 5.8.
   # -5 seems to be significantly slower than both. [vszakats]
   CFLAGS += -d -6 -O2 -OS -Ov -Oi -Oc
endif

ifeq ($(HB_BUILD_MODE),cpp)
   CFLAGS += -P
endif

ifeq ($(HB_BUILD_DEBUG),yes)
   CFLAGS += -y -v
endif

LD := bcc32.exe
LD_OUT := -e

LIBPATHS := -L$(LIB_DIR)
# It's probably not necessary in native Windows but I need it
# for my Linux box because -L<path> seems to not work with WINE
LDLIBS := $(foreach lib,$(LIBS),$(LIB_DIR)/$(lib)$(LIB_EXT))
LDLIBS += $(foreach lib,$(SYSLIBS),$(lib)$(LIB_EXT))

LDFLAGS += $(LIBPATHS)

AR := tlib.exe
ARFLAGS := /P64

ifneq ($(HB_SHELL),sh)

   # NOTE: Command-line limit length defeating methods found below
   #       are only needed to support pre-Windows XP systems, where
   #       limit is 2047 chars. [vszakats]

   # NOTE: The empty line directly before 'endef' HAVE TO exist!
   define lib_object
      @$(ECHO) -+$(subst /,\,$(file)) ^& >> __lib__.tmp

   endef

   define create_library
      @if exist __lib__.tmp del __lib__.tmp
      $(foreach file,$(^F),$(lib_object))
      @$(ECHO) -+>> __lib__.tmp
      $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) "$(subst /,\,$(LIB_DIR)/$@)" @__lib__.tmp
   endef

   AR_RULE = $(create_library)

else # sh

   AROBJS = $(foreach file,$(^F),-+$(file))
   AR_RULE = $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) "$(subst /,\,$(LIB_DIR)/$@)" $(AROBJS)

endif

include $(TOP)$(ROOT)config/rules.mk

#
# $Id$
#

ifeq ($(HB_BUILD_MODE),cpp)
   HB_CMP := g++
else
   HB_CMP := gcc
endif

OBJ_EXT := .o
LIB_PREF := lib
LIB_EXT := .a

CC := $(HB_CCPATH)$(HB_CCPREFIX)$(HB_CMP)$(HB_CCPOSTFIX)
CC_IN := -c
CC_OUT := -o

CPPFLAGS := -I. -I$(HB_INC_COMPILE)
CFLAGS :=
LDFLAGS :=

ifneq ($(HB_BUILD_WARN),no)
   CFLAGS += -Wall -W
endif

ifneq ($(HB_BUILD_OPTIM),no)
   CFLAGS += -O3
   CFLAGS += -fomit-frame-pointer
   ifeq ($(HB_COMPILER),mingw)
      CFLAGS += -march=i586 -mtune=pentiumpro
   endif
endif

ifeq ($(HB_BUILD_DEBUG),yes)
   CFLAGS += -g
endif

LD := $(HB_CCPATH)$(HB_CCPREFIX)$(HB_CMP)$(HB_CCPOSTFIX)
LD_OUT := -o$(subst x,x, )

LIBPATHS := -L$(LIB_DIR)
LDLIBS := $(foreach lib,$(LIBS) $(SYSLIBS),-l$(lib))

# Add the standard C main() entry
ifeq ($(HB_MAIN),std)
   ifeq ($(filter hbrtl,$(LIBS)),hbrtl)
      LDLIBS += -lhbmainstd
   endif
endif

LDFLAGS += $(LIBPATHS)

AR := $(HB_CCPATH)$(HB_CCPREFIX)ar
ARFLAGS :=
AR_RULE = $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) crs $(LIB_DIR)/$@ $(^F) || $(RM) $(subst /,$(DIRSEP),$(LIB_DIR)/$@)

DY := $(CC)
DFLAGS := -shared
DY_OUT := $(LD_OUT)
DLIBS := $(foreach lib,$(SYSLIBS),-l$(lib))
IMP_DIR :=

# NOTE: The empty line directly before 'endef' HAVE TO exist!
define dyn_object
   @$(ECHO) $(ECHOQUOTE)INPUT($(subst \,/,$(file)))$(ECHOQUOTE) >> __dyn__.tmp

endef
# ,--out-implib,$(IMP_FILE)
define create_dynlib
   $(if $(wildcard __dyn__.tmp),@$(RM) __dyn__.tmp,)
   $(foreach file,$^,$(dyn_object))
   $(DY) $(DFLAGS) $(HB_USER_DFLAGS) $(DY_OUT)$(DYN_DIR)/$@ __dyn__.tmp $(DLIBS) -Wl,--output-def,$(DYN_DIR)/$(basename $@).def
endef

DY_RULE = $(create_dynlib)

include $(TOP)$(ROOT)config/rules.mk

#
# $Id$
#

ifeq ($(HB_CMP),)
   ifeq ($(HB_BUILD_MODE),cpp)
      HB_CMP := g++
   else
      HB_CMP := gcc
   endif
endif

OBJ_EXT := .o
LIB_PREF := lib
LIB_EXT := .a

HB_DYN_COPT := -DHB_DYNLIB -fpic

CC := $(HB_CCACHE) $(HB_CCPREFIX)$(HB_CMP)$(HB_CCPOSTFIX)
CC_IN := -c
CC_OUT := -o

CFLAGS += -I. -I$(HB_INC_COMPILE)

ifneq ($(HB_BUILD_WARN),no)
   CFLAGS += -Wall -W
endif

ifneq ($(HB_BUILD_OPTIM),no)
   CFLAGS += -O3
endif

ifeq ($(HB_BUILD_DEBUG),yes)
   CFLAGS += -g
endif

LD := $(HB_CCACHE) $(HB_CCPREFIX)$(HB_CMP)$(HB_CCPOSTFIX)
LD_OUT := -o

LIBPATHS := $(foreach dir,$(LIB_DIR) $(SYSLIBPATHS),-L$(dir))
LDLIBS := $(foreach lib,$(HB_USER_LIBS) $(LIBS) $(SYSLIBS),-l$(lib))

LDFLAGS += $(LIBPATHS)

AR := $(HB_CCPREFIX)ar
AR_RULE = ( $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) rcs $(LIB_DIR)/$@ $(^F) $(ARSTRIP) ) || ( $(RM) $(LIB_DIR)/$@ && false )

DY := $(CC)
DFLAGS += -shared $(LIBPATHS)
DY_OUT := -o$(subst x,x, )
DLIBS := $(foreach lib,$(HB_USER_LIBS) $(SYSLIBS),-l$(lib))

DY_RULE = $(DY) $(DFLAGS) $(HB_USER_DFLAGS) $(DY_OUT)$(DYN_DIR)/$@ $^ $(DLIBS) $(DYSTRIP) && $(LN) $(@F) $(DYN_FILE2)

include $(TOP)$(ROOT)config/rules.mk

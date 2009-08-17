#
# $Id$
#

# GNU MAKE file for Open Watcom C/C++ compiler

# ---------------------------------------------------------------
# See option docs here:
#    http://www.users.pjwstk.edu.pl/~jms/qnx/help/watcom/compiler-tools/cpopts.html
#    http://www.users.pjwstk.edu.pl/~jms/qnx/help/watcom/compiler-tools/wlink.html
#    http://www.users.pjwstk.edu.pl/~jms/qnx/help/watcom/compiler-tools/wlib.html
# ---------------------------------------------------------------

OBJ_EXT := .obj
LIB_PREF :=
LIB_EXT := .lib

ifeq ($(HB_BUILD_MODE),c)
   CC := wcc386
endif
ifeq ($(HB_BUILD_MODE),cpp)
   CC := wpp386
endif
# Build in C++ mode by default
ifeq ($(HB_BUILD_MODE),)
   CC := wpp386
endif
CC_IN :=
CC_OUT := -fo=

CPPFLAGS := -zq -bt=os2
CFLAGS :=
LDFLAGS :=

ifneq ($(HB_BUILD_WARN),no)
   CPPFLAGS += -w3
endif

ifneq ($(HB_BUILD_OPTIM),no)
   # architecture flags
   CPPFLAGS += -5r -fp5

   # optimization flags
   # don't enable -ol optimization in OpenWatcom 1.1 - gives buggy code
   CPPFLAGS += -onaehtr -s -ei -zp4 -zt0
   #CPPFLAGS += -obl+m
   ifeq ($(CC),wpp386)
      CPPFLAGS += -oi+
   else
      CPPFLAGS += -oi
   endif
else
   CPPFLAGS += -3r
endif

CPPFLAGS += -i. -i$(HB_INC_COMPILE)

ifeq ($(HB_BUILD_DEBUG),yes)
   CPPFLAGS += -d2
endif

ifeq ($(CC),wcc386)
   ifneq ($(HB_HOST_ARCH),linux)
      CPPFLAGS := $(subst /,\,$(CPPFLAGS))
      CC_RULE = $(CC) $(subst /,\,$(HB_INC_DEPEND)) $(CPPFLAGS) $(subst /,\,$(CFLAGS)) $(subst /,\,$(HB_CFLAGS)) $(subst /,\,$(HB_USER_CFLAGS)) $(CC_OUT)$(<F:.c=$(OBJ_EXT)) $(CC_IN)$(subst /,\,$<)
   endif
endif

LD := wlink
ifeq ($(HB_BUILD_DEBUG),yes)
   LDFLAGS += DEBUG ALL
endif
LDFLAGS += SYS os2v2

LDLIBS := $(foreach lib,$(LIBS),$(LIB_DIR)/$(lib))

comma := ,
LDFILES_COMMA = $(subst $(subst x,x, ),$(comma) ,$(^F))
LDLIBS_COMMA := $(subst $(subst x,x, ),$(comma) ,$(strip $(LDLIBS)))
LD_RULE = $(LD) $(LDFLAGS) $(HB_USER_LDFLAGS) NAME $(BIN_DIR)/$@ FILE $(LDFILES_COMMA) $(if $(LDLIBS_COMMA), LIB $(LDLIBS_COMMA),)

ifeq ($(HB_SHELL),sh)
   create_library = $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) $(LIB_DIR)/$@ $(foreach file,$(^F),-+$(file))
else
   # maximum size of command line in OS2 is limited to 1024 characters
   # the trick with divided 'wordlist' is workaround for it:
   #     -$(if $(wordlist   1,100,$(^F)), echo $(wordlist   1,100,$(addprefix -+,$(^F))) >> __lib__.tmp,)
   #     -$(if $(wordlist 101,200,$(^F)), echo $(wordlist 101,200,$(addprefix -+,$(^F))) >> __lib__.tmp,)
   #     -$(if $(wordlist 201,300,$(^F)), echo $(wordlist 301,300,$(addprefix -+,$(^F))) >> __lib__.tmp,)
   # anyhow OS2 port# of GNU make 3.81 seems to have bug and GPFs when total
   # commands length is too big so for %i in ( *$(OBJ_EXT) ) do ... below is
   # ugly workaround for both problems

   ifeq ($(HB_SHELL),nt)
      FILE := %%f
   else
      FILE := %f
   endif

   define create_library
      @echo $(LIB_DIR)/$@ > __lib__.tmp
      for $(FILE) in ( *$(OBJ_EXT) ) do @echo -+$(FILE) >> __lib__.tmp
      $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) @__lib__.tmp
   endef
endif

AR := wlib
ARFLAGS := -q -p=64 -c -n
AR_RULE = $(create_library)

include $(TOP)$(ROOT)config/rules.mk

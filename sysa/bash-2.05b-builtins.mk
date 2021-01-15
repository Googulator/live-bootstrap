.SUFFIXES = .def

include ../common.mk

CFLAGS  = \
	-I. \
	-I.. \
	-I../include \
	-I../lib \
	$(COMMON_CFLAGS)

BUILTINS_DEFS = $(addsuffix .def, $(BUILTINS_DEF_FILES))
BUILTINS_DEF_OBJS = $(addsuffix .o, $(BUILTINS_DEF_FILES))
BUILTINS_STATIC_FILES = common evalstring evalfile getopt bashgetopt
BUILTINS_STATIC_OBJS = $(addsuffix .o, $(BUILTINS_STATIC_FILES))
BUILTINS_OBJS = $(BUILTINS_DEF_OBJS) $(BUILTINS_STATIC_OBJS)

%.o: %.def
	../mkbuiltins $<
	$(CC) -c $(CFLAGS) -o $@ $*.c

libbuiltins.a: $(BUILTINS_OBJS) builtins.o
	$(AR) cr $@ $(BUILTINS_OBJS) builtins.o

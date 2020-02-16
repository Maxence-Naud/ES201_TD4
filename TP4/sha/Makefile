# MODIFIED MAKEFILE !
# 22/12/2016 
# Joël Cathébras [joel.cathebras@gmail.com]
#	CEA LIST


# By default, the code is compiled for a "big endian" machine.
# To compile on a "little endian" machine set the LITTLE_ENDIAN flag.
# To make smaller object code, but run a little slower, don't use UNROLL_LOOPS.
# To use NIST's modified SHA of 7/11/94, define USE_MODIFIED_SHA

CC = gcc
SS_CC=/usr/ensta/pack/simplescalar-3v0d/bin/sslittle-na-sstrix-gcc

CFLAGS = -O3 -Wall -DLITTLE_ENDIAN

all: sha.ss sha

sha.ss:	sha_driver_ss.o sha_ss.o
	$(SS_CC) -o $@ sha_driver_ss.o sha_ss.o

sha:	sha_driver.o sha.o
	$(CC) -o $@ sha_driver.o sha.o

%_ss.o: %.c
	$(SS_CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf *.o sha.ss sha output*


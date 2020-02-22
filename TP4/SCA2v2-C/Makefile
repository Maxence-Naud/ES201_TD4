TARGET = SSCA2.ss
CC = /usr/ensta/pack/simplescalar-3v0d/bin/sslittle-na-sstrix-gcc		#compilo pour simplescalar
#CC = gcc																															#
#CC = arm-none-linux-gnueabi-gcc																				#compilo pour gem5

LIBS = 
FLAGS = #static -O3 -march=armv7-a	-mtune=cortex-a9 -fno-tree-vectorize -mcpu=cortex-a9 -mfloat-abi=soft 
 -xtarget=ultraT1 -xarch=v9b -xO3

OBJS = SSCA2.o init.o utils.o genScalData.o \
    computeGraph.o getStartLists.o findSubGraphs.o \
    betweennessCentrality.o

all: $(OBJS) defs.h /usr/ensta/pack/simplescalar-3v0d/sslittle-na-sstrix/include/math.h Makefile
	$(CC) $(FLAGS) -o $(TARGET) $(OBJS) $(LIBS)

.c.o: defs.h Makefile
	$(CC) $(FLAGS) -c $<

clean:
	rm -f *.o *~ $(TARGET) core*



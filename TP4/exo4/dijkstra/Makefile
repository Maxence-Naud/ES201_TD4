CC=/usr/ensta/pack/simplescalar-3v0d/bin/sslittle-na-sstrix-gcc

all:  dijkstra_large dijkstra_small

dijkstra_large: dijkstra_large.c Makefile
	$(CC) -static dijkstra_large.c -O3 -o dijkstra_large.ss

dijkstra_small: dijkstra_small.c Makefile
	$(CC) -static dijkstra_small.c -O3 -o dijkstra_small.ss 

clean:
	rm -rf dijkstra_large.ss dijkstra_small.ss output*

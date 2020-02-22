#include "defs.h"

void genScalData(graphSDG* SDGdata) {

    VERT_T *srcs, *dests;
    LONG_T i, j, u, v, step, pos, n, m, count;
    DOUBLE_T *rv;
    LONG_T numRandVals, tmpVal;
    LONG_T numEdgesPerPhase, numEdgesAdded, numEdgesToBeAdded;
    DOUBLE_T av, bv, cv, dv;
    WEIGHT_T *w;
    VERT_T *mapping;
    LONG_T* memBlock;
    dynArray* SDGedges;
    
    n = N;
    m = M;
		
		fprintf(stderr, "Starting counter\n");
   
    /* Allocate a big chunk of memory for the adjacency list 
       dynamic arrays. We do this to avoid O(n) malloc calls */ 
    memBlock = (LONG_T *) malloc(ARRAY_INIT_SIZE*n*sizeof(LONG_T));
    assert(memBlock != NULL);
    SDGedges = (dynArray *) malloc(n*sizeof(dynArray)); 
    assert(SDGedges != NULL);

    /* Initialize the dynamic arrays. Each list is of size ARRAY_INIT_SIZE
       to begin with */   
    for (i=0; i<n; i++) {
        SDGedges[i].vals  = memBlock + i*ARRAY_INIT_SIZE;
        SDGedges[i].count = 0;
        SDGedges[i].max_size = ARRAY_INIT_SIZE;
    }
		

    SDGedges[0].vals[0] = 0;

    /* We need 13*SCALE random numbers for adding one edge */
    /* The edges are generated in phases, in order to be able to
       reproduce the same graph for a given SCALE value */

    /* Let us generate 2^18 edges in each phase */
    /* We fill an array of random numbers of size 5*SCALE*numEdgesPerPhase
       in each phase */

    numEdgesPerPhase = 1<<18;
    if (m  < numEdgesPerPhase)
        numEdgesPerPhase = m;

    numRandVals = numEdgesPerPhase*5*SCALE;

    /* Initialize random number generator */
    srand(SCALE*34535);

    rv = (DOUBLE_T *) malloc(numRandVals*sizeof(float));
    assert(rv != NULL);
    
    /* Start adding edges */
    numEdgesAdded = 0;
		fprintf(stderr, "Preparing to add edges\n");
		printf("Params: %f %f %f %f\n",A,B,C,D);
		fprintf(stderr, "Preparing to add %ld edges\n",m);
//    fprintf(stderr, "Adding edges ... %f %f %f %f %f",0.004,A,B,C,D);

    while (numEdgesAdded < m) {
				printf("start loop\n");
        for (i=0; i<numRandVals; i++)
				{
            rv[i] = (float)rand()/RAND_MAX;
				}
					
				printf("end with rv generation\n");

        if ((m - numEdgesAdded) < numEdgesPerPhase) {
            numEdgesToBeAdded = m - numEdgesAdded;
        } else {
            numEdgesToBeAdded = numEdgesPerPhase;
        }

        count = 0;
        for (i=0; i<numEdgesToBeAdded; i++) {

            u = 1;
            v = 1;
            step = n/2;

            av = A;
            bv = B;
            cv = C;
            dv = D;
					//	printf("%ld / %ld / %d (%Lf %Lf %Lf %Lf) \n", u, v, step, av, bv, cv,	dv);
            for (j=0; j<SCALE; j++) {
                choosePartition(rv[5*(i*SCALE+j)], &u, &v, step, av, bv, cv, dv);
                step = step/2;
                varyParams(rv, 5*(i*SCALE+j), &av, &bv, &cv, &dv);
            }
//						printf("%ld / %ld / %d (%Lf %Lf %Lf %Lf) \n", u, v, step, av, bv, cv,	dv)
            if (u != v) {
                pos = dynArraySortedInsertPos(SDGedges+u-1, v-1);
                /* pos = -1 => there is a duplicate edge */
                if (pos != -1) {
				//						printf("No duplicate ");
                    dynArraySortedInsert(SDGedges+u-1, v-1, pos);
                    count++;
                }
            }

        }

        numEdgesAdded = numEdgesAdded + count;
				////printf(".");
        //fprintf(stderr, "\n %ld (%ld) \n", numEdgesAdded,count); 
    }

    fprintf(stderr, "... done\n");
    free(rv);

    /*
    if (tid == 0) { 
       fprintf(stderr, "\nEdges added:\n");
       for (i=0; i<m; i++) {
           fprintf(stderr, "[%ld %ld] ", srcs[i], dests[i]);
       }
    } 
    */
    
    /* Create the edge arrays */
    
    srcs = (VERT_T *) malloc(m*sizeof(VERT_T));
    assert(srcs != NULL);
    dests = (VERT_T *) malloc(m*sizeof(VERT_T));
    assert(dests != NULL);
    
    count = 0;
    for (i=0; i<n; i++) {
        for (j=0; j<SDGedges[i].count; j++) {
            srcs[count] = i;
            dests[count] = (SDGedges[i].vals)[j];
            count++;
        }
    } 

    assert(count == m);
    free(memBlock);
    for (i=0; i<n; i++) {
        if (SDGedges[i].max_size != ARRAY_INIT_SIZE) {
            free(SDGedges[i].vals);
        }
    }
    free(SDGedges);
        
    /* Permute vertex IDs to remove locality */

    mapping = (VERT_T *) malloc(n*sizeof(VERT_T));
    assert(mapping != NULL);

    for (i=0; i<n; i++) {
        mapping[i] = i;
    }

    srand(SCALE*32425);

    for (i=0; i<n; i++) {
        j = lrand() % n;
        tmpVal = mapping[i];
        mapping[i] = mapping[j];
        mapping[j] = tmpVal;
    }

    for (i=0; i<m; i++) {
        srcs[i] = mapping[srcs[i]];
        dests[i] = mapping[dests[i]];
    } 

    /* Permute edge array */

    srand(SCALE*5674828);
    for (i=0; i<m; i++) {
        j = lrand() % m;
        /* swap edges i and j */
        u = srcs[i];
        v = dests[i];
        srcs[i] = srcs[j];
        dests[i] = dests[j];
        srcs[j] = u;
        dests[j] = v;
    }
    
    /* Generate edge weights */
    
    free(mapping);
    rv = (DOUBLE_T *) malloc(m*sizeof(DOUBLE_T));
    assert(rv != NULL);
    
    w = (WEIGHT_T *) malloc(m*sizeof(WEIGHT_T));
    assert(w != NULL);
    
    srand(SCALE*78956);

    for (i=0; i<m; i++) {
        rv[i] = (float)rand()/RAND_MAX;
    }

    for (i=0; i<m; i++) {
        w[i] = (WEIGHT_T) (1 + rv[i] * MaxIntWeight);
    }

    SDGdata->n = n;
    SDGdata->m = m;
    SDGdata->startVertex = srcs;
    SDGdata->endVertex = dests;
    SDGdata->weight = w;
    free(rv);

    /*
    for (i=0; i<SDGdata->m; i++) {
       fprintf(stderr, "[%ld %ld] ", SDGdata->startVertex[i], SDGdata->endVertex[i]);
    }
    */ 
   
    return;
    
}

void choosePartition(DOUBLE_T p, LONG_T *u, LONG_T *v, LONG_T step, 
        DOUBLE_T av, DOUBLE_T bv, DOUBLE_T cv, DOUBLE_T dv) {

    if (p < av) {
        /* Do nothing */
    } else if ((p >= av) && (p < av+bv)) {
        *v += step;
    } else if ((p >= av+bv) && (p < av+bv+cv)) {
        *u += step;
    } else if ((p >= av+bv+cv) && (p < av+bv+cv+dv)) {
        *u += step;
        *v += step;
    }
}


void varyParams(DOUBLE_T* rv, INT_T offset, DOUBLE_T* av, DOUBLE_T* bv, 
        DOUBLE_T* cv, DOUBLE_T* dv) {

    float v, S;

    /* Allow a max. of 10% variation */
    
    v = 0.2;
    *av *= 0.9 + v*rv[offset+1];
    *bv *= 0.9 + v*rv[offset+2];
    *cv *= 0.9 + v*rv[offset+3];
    *dv *= 0.9 + v*rv[offset+4];

    S = *av + *bv + *cv + *dv;

    *av = *av/S;
    *bv = *bv/S;
    *cv = *cv/S;
    *dv = *dv/S;
}

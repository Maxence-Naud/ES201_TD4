#include "defs.h"

int main(int argc, char **argv)
{
    /* Data structure for storing generated tuples in the 
     * Scalable Data Generation Stage -- see defs.h */
    graphSDG* SDGdata;  

    /* The graph data structure -- see defs.h */
    graph* G;
  
    /* Kernel 2 output */
    edge *maxIntWtList;
    INT_T maxIntWtListSize;
    
    /* Kernel 3 output */
    V **extractedSubGraphs;

    /* Kernel 4 output */
    DOUBLE_T *BC;
   
	 	struct timeval time_st;
	 	struct timeval time_sp;
		DOUBLE_T time_4;
    LONG_T i;

    if (argc != 2) {
        fprintf(stderr, "Usage: ./SSCA2 <SCALE>\n");
        exit(-1);
    }

    SCALE = atoi(argv[1]);

    /* ------------------------------------ */
    /*  Initialization -- Untimed           */
    /* ------------------------------------ */

    fprintf(stderr, "\nHPCS SSCA#2 Graph Analysis Benchmark v2.0\n");
    fprintf(stderr, "Running...\n\n");
    
    init(SCALE);
    
    fprintf(stderr, "SCALE: %d\n\n", SCALE);
 
    /* -------------------------------------------- */
    /*  Scalable Data Generator -- Untimed          */
    /* -------------------------------------------- */

    fprintf(stderr, "Scalable Data Generator -- ");
    fprintf(stderr, "genScalData() beginning execution...\n");
    
    SDGdata  = (graphSDG *) malloc(sizeof(graphSDG));

		gettimeofday(&time_st, NULL);
    genScalData(SDGdata);
		gettimeofday(&time_sp, NULL);
    
		time_4 = (float)(time_sp.tv_sec-time_st.tv_sec) +	((float)time_sp.tv_usec-time_st.tv_usec)/1000000;

    fprintf(stderr, "\n\tgenScalData() completed execution\n");
    fprintf(stderr, "\nTime taken for Scalable Data Generation is %9.6f sec.\n\n", time_4);
    fprintf(stderr, "\tNo. of vertices       : %ld\n", N);
    fprintf(stderr, "\tNo. of edges          : %ld\n", M);

    /* ------------------------------------ */
    /*  Kernel 1 - Graph Construction       */
    /* ------------------------------------ */
  
    /* From the SDG data, construct the graph 'G'  */
    fprintf(stderr, "\nKernel 1 -- computeGraph() beginning execution...\n");

    G = (graph *) malloc(sizeof(graph));
    /* Store the SDG edge lists in a compact representation 
     * which isn't modified in subsequent Kernels */

    computeGraph(G, SDGdata);

    fprintf(stderr, "\n\tcomputeGraph() completed execution\n");
    
    /* Verification? */
    free(SDGdata);

    /* ---------------------------------------------------- */
    /*  Kernel 2 - Find Max weight and sought string        */
    /* ---------------------------------------------------- */
  
    fprintf(stderr, "\nKernel 2 -- getStartLists() beginning execution...\n");

    /* Initialize vars and allocate temp. memory for the edge list */
    maxIntWtListSize = 0;
    maxIntWtList = (edge *) malloc(sizeof(edge));

    getStartLists(G, &maxIntWtList, &maxIntWtListSize);

    fprintf(stderr, "\n\tgetStartLists() completed execution\n\n");
    fprintf(stderr, "Max. int wt. list size is %d\n", maxIntWtListSize);

    /* ------------------------------------ */
    /*  Kernel 3 - Graph Extraction         */
    /* ------------------------------------ */
  
    fprintf(stderr, "\nKernel 3 -- findSubGraphs() beginning execution...\n");

    extractedSubGraphs = (V **) malloc(maxIntWtListSize*sizeof(V*));
    for (i=0; i<maxIntWtListSize; i++) {
        extractedSubGraphs[i] = (V *) malloc((G->n)*sizeof(V));
        assert(extractedSubGraphs[i] != NULL); 
    }

    findSubGraphs(G, extractedSubGraphs, maxIntWtList, maxIntWtListSize);

    fprintf(stderr, "\n\tfindSubGraphs() completed execution\n");
   
    /* Verification? */
    free(maxIntWtList);
         
    for (i=0; i<maxIntWtListSize; i++)
        free(extractedSubGraphs[i]);
    free(extractedSubGraphs);
     
    /* ------------------------------------------ */
    /*  Kernel 4 - Betweenness Centrality         */
    /* ------------------------------------------ */

    fprintf(stderr, "\nKernel 4 -- betweennessCentrality() beginning execution...\n");

    BC = (DOUBLE_T *) calloc(N, sizeof(DOUBLE_T));
		gettimeofday(&time_st, NULL);
    betweennessCentrality(G, BC);
		gettimeofday(&time_sp, NULL);
    
		time_4 = (float)(time_sp.tv_sec-time_st.tv_sec) +	((float)time_sp.tv_usec-time_st.tv_usec)/1000000;

    fprintf(stderr, "\n\tbetweennessCentrality() completed execution.\n");
    fprintf(stderr, "\nTime taken for Kernel 4 is %9.6f sec", time_4);
    fprintf(stderr, "\n\n");
    free(BC);


    fprintf(stderr, "TEPS score for Kernel 4 is %f  \n",7*N*(1<<K4Approx)/time_4);

    /* -------------------------------------------------------------------- */
    
    free(G->numEdges);
    free(G->endV);
    free(G->weight);
    free(G);

    return 0;
}

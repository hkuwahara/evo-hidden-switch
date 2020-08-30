#include <stdio.h>
#include <stdlib.h>

#include "bug.h"
#include "evolution.h"


/*
 *
 */
int main(int argc, char** argv) {
    RET_VAL ret = SUCCESS;

    if( IS_FAILED( ( ret = initializeEvolution(argc, argv) ) ) ) {
        return EXIT_FAILURE;
    }
    performEvolution( argc, argv );
    return (EXIT_SUCCESS);
}




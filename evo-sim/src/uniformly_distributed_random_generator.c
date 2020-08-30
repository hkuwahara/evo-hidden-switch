#include <math.h>

#include "uniformly_distributed_random_generator.h"

double GetNextUniformRandomNumber( double minUniform, double maxUniform ) {
    int value = 0;
    double random = 0.0;

    value = rand();
    random = minUniform +  ( (value + 0.999999) / ( RAND_MAX + 1.0 ) ) * ( maxUniform - minUniform );
    return random;    
}

double GetNextUnitUniformRandomNumber( ) {
    int value = 0;
    double random = 0.0;

    do {
        value = rand();
        random = (double)value / (double)RAND_MAX;
    }while( (random == (double)0.0) || ((random == (double)1.0)) );
    return random;
}


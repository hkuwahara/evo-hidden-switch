#include <math.h>

#include "uniformly_distributed_discrete_random_generator.h"

unsigned int GetNextDiscreteUniformRandomNumber( unsigned int minUniform, unsigned int maxUniform ) {
    int length = maxUniform - minUniform + 1;
    int random = rand() % ( length + 1 );

    return random + minUniform;
}

#include <math.h>
#include "uniformly_distributed_random_generator.h"
#include "exponentially_distributed_random_generator.h"


double GetNextExponentialRandomNumber( double lambda ) {
    double unitUniform = 0.0;
    double exponential = 0.0;
    
    unitUniform = GetNextUnitUniformRandomNumber();
    exponential = -log( unitUniform ) / lambda; 
    return exponential;
}

double GetNextUnitExponentialRandomNumber( ) {
    double unitUniform = 0.0;
    double unitExponential = 0.0;
    
    unitUniform = GetNextUnitUniformRandomNumber();
    unitExponential = -log( unitUniform ); 
    return unitExponential;
}


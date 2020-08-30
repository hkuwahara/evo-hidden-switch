#include "uniformly_distributed_random_generator.h"
#include "normally_distributed_random_generator.h"
#include <math.h>


double GetNextNormalRandomNumber( double mean, double stdDeviation ) {
    double unitNormal = 0.0;
    double normal = 0.0;

    unitNormal = GetNextUnitNormalRandomNumber();
    normal = ( unitNormal * stdDeviation ) + mean;
    
    return normal;
}

double GetNextUnitNormalRandomNumber( ) {
    static BOOL haveNextNormal = FALSE;
    static double nextNormal = 0.0;
    
    double v1;
    double v2;
    double s;
    double multiplier;
    double unitNormal;

    if( haveNextNormal ) {
        haveNextNormal = FALSE;
        return nextNormal;
    }
    else {
        do {
            v1 = 2 * GetNextUnitUniformRandomNumber() - 1.0;
            v2 = 2 * GetNextUnitUniformRandomNumber() - 1.0;
            s = v1 * v1 + v2 * v2;
        } while( s >= 1.0 || s == 0.0 );
        multiplier = sqrt( -2.0 * log( s ) / s );
        haveNextNormal = TRUE;
        nextNormal = v2 * multiplier;
        unitNormal = v1 * multiplier;
        return unitNormal;
    }
}

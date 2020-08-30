#if !defined(HAVE_NORMALLY_DISTRIBUTED_RANDOM_GENERATOR)
#define HAVE_NORMALLY_DISTRIBUTED_RANDOM_GENERATOR


#include "common.h"

BEGIN_C_NAMESPACE

double GetNextNormalRandomNumber( double mean, double stdDeviation );
double GetNextUnitNormalRandomNumber( );

END_C_NAMESPACE

#endif

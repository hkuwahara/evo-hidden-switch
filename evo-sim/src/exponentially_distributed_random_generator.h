#if !defined(HAVE_EXPONENTIALLY_DISTRIBUTED_RANDOM_GENERATOR)
#define HAVE_EXPONENTIALLY_DISTRIBUTED_RANDOM_GENERATOR


#include "common.h"

BEGIN_C_NAMESPACE

double GetNextExponentialRandomNumber( double lambda );
double GetNextUnitExponentialRandomNumber( );

END_C_NAMESPACE

#endif

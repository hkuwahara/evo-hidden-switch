#if !defined(HAVE_UNIFORMLY_DISTRIBUTED_RANDOM_GENERATOR)
#define HAVE_UNIFORMLY_DISTRIBUTED_RANDOM_GENERATOR


#include "common.h"

BEGIN_C_NAMESPACE


double GetNextUniformRandomNumber( double minUniform, double maxUniform );
double GetNextUnitUniformRandomNumber( );

END_C_NAMESPACE

#endif

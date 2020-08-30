#if !defined(HAVE_UNIFORMLY_DISTRIBUTED_DISCRETE_RANDOM_GENERATOR)
#define HAVE_UNIFORMLY_DISTRIBUTED_DISCRETE_RANDOM_GENERATOR


#include "common.h"

BEGIN_C_NAMESPACE


unsigned int GetNextDiscreteUniformRandomNumber( unsigned int minUniform, unsigned int maxUniform );

END_C_NAMESPACE

#endif

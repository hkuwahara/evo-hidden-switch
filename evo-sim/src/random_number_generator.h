#if !defined(HAVE_RANDOM_NUMBER_GENERATOR)
#define HAVE_RANDOM_NUMBER_GENERATOR


#include "common.h"

BEGIN_C_NAMESPACE

/*
typedef union {
    long discreteValue;
    double continuousValue;
} RANDOM_T;
*/

struct _RANDOM_NUMBER_GENERATOR;
typedef struct _RANDOM_NUMBER_GENERATOR  RANDOM_NUMBER_GENERATOR;

struct _RANDOM_NUMBER_GENERATOR {
    RET_VAL (*SetSeed)( UINT seed );

    unsigned int (*GetNextDiscreteUniform)(unsigned int minUniform, unsigned int maxUniform);
    double (*GetNextUniform)( double min, double max );
    double (*GetNextUnitUniform)( );

    double (*GetNextExponential)( double lambda );
    double (*GetNextUnitExponential)( );

    double (*GetNextNormal)( double mean, double stdDeviation );
    double (*GetNextUnitNormal)( );
/*
    UINT seed;
    double minUniform;
    double rangeUniform;
    double meanNormal;
    double stdDeviationNormal;
*/
};

RANDOM_NUMBER_GENERATOR *CreateRandomNumberGenerator( );
RET_VAL FreeRandomNumberGenerator( RANDOM_NUMBER_GENERATOR **generator );



END_C_NAMESPACE

#endif

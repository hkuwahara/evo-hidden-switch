#include <math.h>
#include "random_number_generator.h"
#include "uniformly_distributed_random_generator.h"
#include "uniformly_distributed_discrete_random_generator.h"
#include "exponentially_distributed_random_generator.h"
#include "normally_distributed_random_generator.h"



static RET_VAL _SetSeed( UINT seed );
static double _GetNextUniform( double min, double max );
static double _GetNextUnitUniform( );
static double _GetNextExponential( double lambda );
static double _GetNextUnitExponential( );
static double _GetNextNormal( double mean, double stdDeviation );
static double _GetNextUnitNormal( );
static unsigned int _GetNextDiscreteUniformRandomNumber( unsigned int minUniform, unsigned int maxUniform );


RANDOM_NUMBER_GENERATOR *CreateRandomNumberGenerator( ) {
    static RANDOM_NUMBER_GENERATOR _randomNumberGeneratorInstance;
    
    if( _randomNumberGeneratorInstance.SetSeed == NULL ) {
    	srand(time(0));
        _randomNumberGeneratorInstance.SetSeed = _SetSeed;
        _randomNumberGeneratorInstance.GetNextUniform = _GetNextUniform;
        _randomNumberGeneratorInstance.GetNextUnitUniform = _GetNextUnitUniform;
        _randomNumberGeneratorInstance.GetNextExponential = _GetNextExponential;
        _randomNumberGeneratorInstance.GetNextUnitExponential = _GetNextUnitExponential;
        _randomNumberGeneratorInstance.GetNextNormal = _GetNextNormal;
        _randomNumberGeneratorInstance.GetNextUnitNormal = _GetNextUnitNormal;
        _randomNumberGeneratorInstance.GetNextDiscreteUniform = _GetNextDiscreteUniformRandomNumber;
    }
    return &_randomNumberGeneratorInstance;
}

RET_VAL FreeRandomNumberGenerator( RANDOM_NUMBER_GENERATOR **generator ) {
    (*generator)->SetSeed = NULL;
    return SUCCESS;
}

static RET_VAL _SetSeed( UINT seed ) {
    srand( seed );
    return SUCCESS;
}

static double _GetNextUniform( double min, double max ) {
    return GetNextUniformRandomNumber( min, max );
}

static double _GetNextUnitUniform( ) {
    return GetNextUnitUniformRandomNumber();
}

static unsigned int _GetNextDiscreteUniformRandomNumber( unsigned int minUniform, unsigned int maxUniform ) {
    return GetNextDiscreteUniformRandomNumber( minUniform, maxUniform );
}


static double _GetNextExponential( double lambda ) {
    return GetNextExponentialRandomNumber( lambda ); 
}

static double _GetNextUnitExponential( ) {
    return GetNextUnitExponentialRandomNumber();
}

static double _GetNextNormal( double mean, double stdDeviation ) {
    return GetNextNormalRandomNumber( mean, stdDeviation );
}

static double _GetNextUnitNormal( ) {
    return GetNextUnitNormalRandomNumber();
}




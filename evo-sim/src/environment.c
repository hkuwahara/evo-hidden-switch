#include <math.h>
#include <stdlib.h>
#include "random_number_generator.h"
#include "environment.h"
#include "options.h"

static ENVIRONMENT env;
static double _power;

static RET_VAL _changeMode( ENVIRONMENT *env );
static double _getSignalLevel( ENVIRONMENT *env );
static RET_VAL _setSignalTrust( ENVIRONMENT *env, double signalTrust );

static RANDOM_NUMBER_GENERATOR *_randomGen;

static double synthesisCost = DEFAULT_SYNTHESIS_COST;

static RET_VAL _selectFitnessFunction( ENVIRONMENT *env, char selection );

static double _getPowerFitness( BUG *bug );
static double _getLinearFitness( BUG *bug );
static double _getConvexFitness( BUG *bug );
static double _getConcaveFitness( BUG *bug );
static double _getSigmoidalFitnessLow( BUG *bug );
static double _getSigmoidalFitnessHigh( BUG *bug );
static double _getGaussianFitnessHigh( BUG *bug );
static double _getGaussianFitnessLow( BUG *bug );
static double _getSigmoidalFitnessHighWithPenalty( BUG *bug );


ENVIRONMENT *getEnvironment() {
    char *buf = NULL;
    char *endp = NULL;

    if( env.getFitness == NULL ) {
        env.mode = MODE_HIGH_A;
        env.getFitness = _getSigmoidalFitnessHighWithPenalty;
        env.getFitnessHigh = _getSigmoidalFitnessHighWithPenalty;
        env.getFitnessLow = _getSigmoidalFitnessLow;
        env.changeMode = _changeMode;
        env.getSignalLevel = _getSignalLevel;
        env.setSignalTrust = _setSignalTrust;
        _randomGen = CreateRandomNumberGenerator();

        synthesisCost = DEFAULT_SYNTHESIS_COST;
    }

    return &env;
}


static double _getGaussianFitnessHigh( BUG *bug ) {
    double x = bug->A;
    double y = (x - GAUSSIAN_FITNESS_HIGH_MEAN);
    double y2 = y * y;
    double z = 2.0 * GAUSSIAN_FITNESS_HIGH_SD * GAUSSIAN_FITNESS_HIGH_SD;

    return exp( -y2 / z);
}

static double _getGaussianFitnessLow( BUG *bug ) {
    double x = bug->A;
    double y = (x - GAUSSIAN_FITNESS_LOW_MEAN);
    double y2 = y * y;
    double z = 2.0 * GAUSSIAN_FITNESS_LOW_SD * GAUSSIAN_FITNESS_LOW_SD;

    return exp( -y2 / z);
}



static double _getPowerFitness( BUG *bug ) {
    return pow( bug->A, _power );
}


static double _getLinearFitness( BUG *bug ) {
    return bug->A;
}

static double _getConvexFitness( BUG *bug ) {
    double x = bug->A;
    return x * x;
}

static double _getConcaveFitness( BUG *bug ) {
    return sqrt( bug->A);
}

static double _getSigmoidalFitnessHigh( BUG *bug ) {
    double x = pow( bug->A / FITNESS_K, FITNESS_HILL_COEFFICIENT );
    double y =  x / ( 1.0 + x ) - synthesisCost * bug->A;

    return ( y < 0.0 ) ? 0.0 : y;
}

static double _getSigmoidalFitnessHighWithPenalty( BUG *bug ){
    double x = pow( bug->A / FITNESS_K, FITNESS_HILL_COEFFICIENT );
    double p = pow( bug->A / 1000.0, 2 );
    double y =  x / ( 1.0 + x ) - p / ( 1.0 + p);

    return ( y < 0.0 ) ? 0.0 : y;
}


static double _getSigmoidalFitnessLow( BUG *bug ) {
    double x = pow( bug->A / FITNESS_K, FITNESS_HILL_COEFFICIENT );
    return 1.0 - x / ( 1.0 + x );
}

static RET_VAL _changeMode( ENVIRONMENT *env ) {
#if 1
    if( env->mode == MODE_HIGH_A ) {
        env->mode = MODE_LOW_A;
        env->getFitness = env->getFitnessLow;
    }
    else {
        env->mode = MODE_HIGH_A;
        env->getFitness = env->getFitnessHigh;
    }
#endif
    return SUCCESS;
}

static double _getSignalLevel( ENVIRONMENT *env ) {
    double random;
    
    if( env->mode == MODE_HIGH_A ) {
        random = _randomGen->GetNextUnitUniform();
        if( env->signalTrust >= random ) {
            return LOW_SIGNAL_LEVEL;
        }
        else {
            return HIGH_SIGNAL_LEVEL;
        }
    }
    else {
        return HIGH_SIGNAL_LEVEL;
    }

}

static RET_VAL _setSignalTrust( ENVIRONMENT *env, double signalTrust ) {
    env->signalTrust = signalTrust;
    return SUCCESS;
}



static RET_VAL _selectFitnessFunction( ENVIRONMENT *env, char selection ) {
    char *opt;
    char *endp;

    switch( selection ) {

        case '0':
            env->getFitness = _getPowerFitness;
            opt = getOption( 7 );
            if( opt == NULL ) {
                _power = 1.0;
            }
            else {
                _power = strtod( opt, &endp );
                if( _power == 0.0 ) {
                    _power = 1.0;
                }
            }
            break;

        case '1':
            env->getFitness = _getLinearFitness;
            break;

        case '2':
            env->getFitness = _getConcaveFitness;
            break;

        case '3':
            env->getFitness = _getConvexFitness;
            break;

        case '4':
            env->getFitness = _getSigmoidalFitnessHigh;
            break;

        default:
            env->getFitness = _getLinearFitness;
            break;
    }

    return SUCCESS;
}

#ifndef _ENVIRONMENT_H
#define	_ENVIRONMENT_H

#ifdef	__cplusplus
extern "C" {
#endif

#include "def.h"
#include "bug.h"

#define GAUSSIAN_FITNESS_HIGH_MEAN 100.0
#define GAUSSIAN_FITNESS_LOW_MEAN 0.0
#define GAUSSIAN_FITNESS_HIGH_SD 10.0
#define GAUSSIAN_FITNESS_LOW_SD 10.0
    
    
#define MODE_LOW_A 0
#define MODE_HIGH_A 1
#define FITNESS_HILL_COEFFICIENT 5.0
#define FITNESS_K 50.0
#define SYNTHESIS_COST 0.01
#define LOW_SIGNAL_LEVEL 50.0
#define HIGH_SIGNAL_LEVEL 100.0

#define DEFAULT_SYNTHESIS_COST 0.0


    struct _ENVIRONMENT;
    typedef struct _ENVIRONMENT ENVIRONMENT;

    struct _ENVIRONMENT {
        int mode;
        double signalTrust;
        RET_VAL (*changeMode)( ENVIRONMENT *env );
        RET_VAL (*setSignalTrust)( ENVIRONMENT *env, double signalTrust );
        double (*getSignalLevel)( ENVIRONMENT *env );
        double (*getFitness)(BUG *bug );
        double (*getFitnessLow)(BUG *bug );
        double (*getFitnessHigh)(BUG *bug );
        RET_VAL (*selectFitnessFunction)( ENVIRONMENT *env, char selection );
    };


ENVIRONMENT *getEnvironment();


#ifdef	__cplusplus
}
#endif

#endif	/* _ENVIRONMENT_H */

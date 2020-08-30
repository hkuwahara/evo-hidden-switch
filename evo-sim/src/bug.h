
#ifndef _BUG_H
#define	_BUG_H


#include "def.h"
#include "util.h"

#ifdef	__cplusplus
extern "C" {
#endif

    #define BUG_GENERATION_TIME 2000.0
    #define SAMPLING_START_TIME 1000.0
    #define SAMPLING_INTERVAL 0.1

    
    #define MEAN_LEVEL 100
    #define DEFAULT_K_D 0.002
/*
    #define DEFAULT_BURST 5
 */
    #define DEFAULT_BURST 1
/*
    #define DEFAULT_N 10
 */
    #define DEFAULT_N 0
    #define BASAL_FACTOR 0.2
    #define DEFAULT_THRESHOLD 0.4
    #define DEFAULT_K_P (MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST)
    #define DEFAULT_K_P_BASAL (BASAL_FACTOR * DEFAULT_K_P)
    #define DEFAUL_K_HALF (1/(DEFAULT_THRESHOLD * MEAN_LEVEL))
    #define DEFAULT_K_TRANSL 0.1
    #define DEFAULT_K_MD (DEFAULT_K_TRANSL/DEFAULT_BURST)
    #define REACTION_NUM 4
    
    typedef struct _BUG BUG;
    typedef struct _REACTION REACTION;

    typedef RET_VAL PROPEN_FUNC( REACTION *reaction, BUG *bug );
    typedef RET_VAL UPDATE_FUNC( BUG *bug );

    struct _REACTION {
        PROPEN_FUNC *propen;
        UPDATE_FUNC *update;
        double rate;
        double partialSum;
    };

    struct _BUG {
        double scale;
        double k_pa;
        double k_pa_A;
        double K_a_A;
        
        double k_d_A;

        double n_a_A;
        double burstA;

        double k_transl;
        double k_mdeg;
        
        double A;
        double mRNA;
        double meanA;
        double stanDevA;
        
        REACTION reactions[REACTION_NUM];
        double totalPropensities;
        double fitness0;
        double fitness1;
        int parentIndex;
    };

#define KD_SUFIX ".kd"
#define BURST_SUFIX ".b"
#define SCALE_SUFIX ".a"
#define HILL_SUFIX ".n"
    
    RET_VAL CreateType1Bug( char *id, PROPERTIES *prop );
    RET_VAL CreateType2Bug( char *id, PROPERTIES *prop );
    RET_VAL initializeType1Bug( BUG *bug );
    RET_VAL initializeType2Bug( BUG *bug );

    RET_VAL initializeBug( BUG *bug );
    RET_VAL initializeBugA( BUG *bug );
    RET_VAL initializeBugB( BUG *bug );
    RET_VAL initializeBugC( BUG *bug );
    RET_VAL initializeBugD( BUG *bug );
    RET_VAL initializeMinorityBug( BUG *bug );
    RET_VAL simulateOneGeneration( BUG *bug );
    RET_VAL simulateOneGeneration2( BUG *bug );
    RET_VAL divideBug( BUG *from, BUG *to );

#ifdef	__cplusplus
}
#endif

#endif	/* _BUG_H */


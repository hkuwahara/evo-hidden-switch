#include "bug.h"

#include "random_number_generator.h"
#include "options.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

static RANDOM_NUMBER_GENERATOR *_randomGen;

static double _basalFactor;
static double _threshold;


static RET_VAL _rxnProdmRNA( REACTION *reaction, BUG *bug );
static RET_VAL _rxnDegA( REACTION *reaction, BUG *bug );
static RET_VAL _rxnProdA( REACTION *reaction, BUG *bug );
static RET_VAL _rxnDegmRNA( REACTION *reaction, BUG *bug );

static RET_VAL _updateProdmRNA( BUG *bug );
static RET_VAL _updateDegA( BUG *bug );
static RET_VAL _updateProdA( BUG *bug );
static RET_VAL _updateDegmRNA( BUG *bug );

static RET_VAL _initializeReaction( BUG *bug );

static RET_VAL _calculatePropensities( BUG *bug );
static REACTION *_findNextReaction( BUG *bug );
static double _computeWaitingTime( BUG *bug );

static void _setRandomSeed( unsigned int seed );
static double _getNextUnitUniformRandomNumber( );
static double _GetNextExponentialRandomNumber( double lambda );

typedef struct {
    double kd;
    double a;
    double n;
    double b;
} _BUG_TYPE;

static _BUG_TYPE _type1;
static _BUG_TYPE _type2;


RET_VAL CreateType1Bug( char *id, PROPERTIES *prop ) {
    char buf[2048];
    char *endp = NULL;
    char *val = NULL;
    
    sprintf(buf, "%s%s", id, KD_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type1.kd = _threshold * MEAN_LEVEL;
    }
    else {
        _type1.kd = strtod( val, &endp );        
    }

    sprintf(buf, "%s%s", id, SCALE_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type1.a = 1.0;
    }
    else {
        _type1.a = strtod( val, &endp );        
    }

    sprintf(buf, "%s%s", id, BURST_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type1.b = DEFAULT_BURST;
    }
    else {
        _type1.b = strtod( val, &endp );        
    }
    
    sprintf(buf, "%s%s", id, HILL_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type1.n = 0.0;
    }
    else {
        _type1.n = strtod( val, &endp );        
    }

    return SUCCESS;
}

RET_VAL CreateType2Bug( char *id, PROPERTIES *prop ) {
    char buf[2048];
    char *endp = NULL;
    char *val = NULL;
    
    sprintf(buf, "%s%s", id, KD_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type2.kd = _threshold * MEAN_LEVEL;
    }
    else {
        _type2.kd = strtod( val, &endp );        
    }

    sprintf(buf, "%s%s", id, SCALE_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type2.a = 1.0;
    }
    else {
        _type2.a = strtod( val, &endp );        
    }

    sprintf(buf, "%s%s", id, BURST_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type2.b = DEFAULT_BURST;
    }
    else {
        _type2.b = strtod( val, &endp );        
    }
    
    sprintf(buf, "%s%s", id, HILL_SUFIX );
    val = prop->GetProperty( prop, buf );
    if( val == NULL ) {
        _type2.n = 0.0;
    }
    else {
        _type2.n = strtod( val, &endp );        
    }

    return SUCCESS;
}

RET_VAL initializeType1Bug( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->scale = _type1.a;
    bug->burstA = _type1.b;
    bug->n_a_A = _type1.n;
    bug->K_a_A = 1.0 / _type1.kd;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}


RET_VAL initializeType2Bug( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->scale = _type2.a;
    bug->burstA = _type2.b;
    bug->n_a_A = _type2.n;
    bug->K_a_A = 1.0 / _type2.kd;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}




RET_VAL initializeBug( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->scale = 1.0;
    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;
    bug->K_a_A = 1.0/(_threshold * MEAN_LEVEL);

    bug->n_a_A = DEFAULT_N;

    bug->burstA = DEFAULT_BURST;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = DEFAULT_K_TRANSL;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}


/**
 * 
 * the best one from v = 0.5
 *  0.5, 65.1437, 1, 0.5, 0.941378
 */
RET_VAL initializeBugA( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->scale = 0.941378;
    bug->burstA = 1;
    bug->n_a_A = 0.5;
    bug->K_a_A = 1.0 / 65.1437;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}

/**
 * 
 * the best one from v = 0.1
 *  0.1, 55.2173, 1, 2.5, 1.12812
 */
RET_VAL initializeMinorityBug( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->K_a_A = 1.0 / 55.2173;
    bug->burstA = 1;
    bug->n_a_A = 2.5;
    bug->scale = 1.12812;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;


    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}



/**
 * 
 * the best one from v = 0.05
 *  0.05, 31.1893, 4.78911, 0.5, 0.513174
 */
RET_VAL initializeBugB( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->K_a_A = 1.0 / 31.1893;
    bug->burstA = 4.78911;
    bug->n_a_A = 0.5;
    bug->scale = 0.513174;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;


    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}



/**
 * 
 * the best one from v = 0.01
 *  0.01, 53.3574, 8.67211, 0, 0.312273
 */
RET_VAL initializeBugC( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->K_a_A = 1.0 / 53.3574;
    bug->burstA = 8.67211;
    bug->n_a_A = 0.0;
    bug->scale = 0.312273;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}

/**
 * 
 * the best one from v = 0.001
 *  0.001, 67.6681, 1.58778, 2.5, 1.30497
 */
RET_VAL initializeBugD( BUG *bug ) {
    char *buf = NULL;
    char *endp = NULL;
    double temp = 0.0;

    bug->K_a_A = 1.0 / 67.6681;
    bug->burstA = 1.58778;
    bug->n_a_A = 2.5;
    bug->scale = 1.30497;

    if( ( buf = getOption(6) ) != NULL ) {
        temp = strtod( buf, &endp );
        _basalFactor = temp;
    }
    else {
        _basalFactor = BASAL_FACTOR;
    }
    
    if( ( buf = getOption(7) ) != NULL ) {
        temp = strtod( buf, &endp );
        _threshold = temp;
    }
    else {
        _threshold = DEFAULT_THRESHOLD;
    }

    bug->k_pa = (_basalFactor * MEAN_LEVEL * DEFAULT_K_D/DEFAULT_BURST);
    bug->k_pa_A = DEFAULT_K_P;

    bug->k_d_A = DEFAULT_K_D;

    bug->k_mdeg = DEFAULT_K_MD;
    bug->k_transl = bug->k_mdeg * bug->burstA;

    bug->A = 0.0;

    bug->mRNA = 0.0;
    
    _initializeReaction( bug );
    _randomGen = CreateRandomNumberGenerator();

    bug->parentIndex = -1;
    return SUCCESS;
}


RET_VAL simulateOneGeneration( BUG *bug ) {

    int sampleCounts = 0;
    double meanA = 0.0;
    double varianceA = 0.0;
    double m2A = 0.0;
    double delta = 0.0;

    double nextSampleTime = SAMPLING_START_TIME;
    double t = 0.0;
    double waitingTime = 0.0;
    REACTION *reaction = NULL;


    while( 1 ) {    
        _calculatePropensities( bug );
        reaction = _findNextReaction( bug );
        waitingTime = _computeWaitingTime( bug );
        t += waitingTime;
        while( t >= nextSampleTime ) {            
            /* iteratively calculate means and variance */
            sampleCounts++;
            delta = bug->A - meanA;
            meanA = meanA + delta / sampleCounts;
            m2A = m2A + delta*(bug->A - meanA);
            
            nextSampleTime += SAMPLING_INTERVAL;
        }

        if( t > BUG_GENERATION_TIME ) {
            varianceA = m2A / sampleCounts;
            bug->meanA = meanA;
            bug->stanDevA = sqrt(varianceA);

            return SUCCESS;
        }
        else {
            reaction->update( bug );
        }
    }

    return FAILING;
}


RET_VAL simulateOneGeneration2( BUG *bug ) {

    double t = 0.0;
    double waitingTime = 0.0;
    REACTION *reaction = NULL;

    while( 1 ) {
        _calculatePropensities( bug );
        reaction = _findNextReaction( bug );
        waitingTime = _computeWaitingTime( bug );
        t += waitingTime;
        if( t > BUG_GENERATION_TIME ) {
            return SUCCESS;
        }
        else {
            reaction->update( bug );
        }
    }

    return FAILING;
}





RET_VAL divideBug( BUG *from, BUG *to ) {

    memcpy( (char*)to, (char*)from, sizeof(BUG) );
/*
    to->A = (double)((int)(to->A / 2.0));
    to->mRNA = (double)((int)(to->mRNA / 2.0));
*/
    return SUCCESS;
}

static RET_VAL _rxnProdmRNA( REACTION *reaction, BUG *bug ) {
    double denominator = 0.0;
    double numerator = 0.0;
	double n = (bug->n_a_A > 0 ? bug->n_a_A : 0.0);
    numerator = bug->scale * ( bug->k_pa + bug->k_pa_A * pow( bug->A *bug->K_a_A, n ) );
    denominator = 1 + pow( bug->A *bug->K_a_A, n );

    reaction->rate = (numerator / denominator);
    return SUCCESS;
}


static RET_VAL _rxnDegA( REACTION *reaction, BUG *bug ) {
    reaction->rate = bug->k_d_A * bug->A;
    return SUCCESS;
}

static RET_VAL _rxnProdA( REACTION *reaction, BUG *bug ) {
    reaction->rate = bug->k_transl * bug->mRNA;
    return SUCCESS;
}

static RET_VAL _rxnDegmRNA( REACTION *reaction, BUG *bug ) {
    reaction->rate = bug->k_mdeg * bug->mRNA;
    return SUCCESS;
}



static RET_VAL _updateProdmRNA( BUG *bug ) {
    bug->mRNA += 1.0;
    return SUCCESS;
}


static RET_VAL _updateDegA( BUG *bug ) {
    bug->A -= 1.0;
    return SUCCESS;
}

static RET_VAL _updateProdA( BUG *bug ) {
    bug->A += 1.0;
    return SUCCESS;
}

static RET_VAL _updateDegmRNA( BUG *bug ) {
    bug->mRNA -= 1.0;
    return SUCCESS;
}


static RET_VAL _initializeReaction( BUG *bug ) {
    REACTION *reactions = bug->reactions;
    
    reactions[0].propen = _rxnProdmRNA;
    reactions[0].update = _updateProdmRNA;
    
    reactions[1].propen = _rxnDegA;
    reactions[1].update = _updateDegA;

    reactions[2].propen = _rxnProdA;
    reactions[2].update = _updateProdA;

    reactions[3].propen = _rxnDegmRNA;
    reactions[3].update = _updateDegmRNA;

    return SUCCESS;
}


static RET_VAL _calculatePropensities( BUG *bug ) {
    int i = 0;
    double total = 0.0;
    REACTION *reactions = bug->reactions;

    for( ; i < REACTION_NUM; i++ ) {
        reactions[i].propen( &(reactions[i]), bug );
        total += reactions[i].rate;
        reactions[i].partialSum = total;
    }
    bug->totalPropensities = total;

    return SUCCESS;
}

static REACTION *_findNextReaction( BUG *bug ) {
    int i = 0;
    int right = 0;
    int left = REACTION_NUM - 1;
    int index = 0;
    double threshold = 0.0;
    REACTION *reactions = bug->reactions;

    threshold = _getNextUnitUniformRandomNumber() * bug->totalPropensities;
    while( right < left ) {
        index = (right + left)/2;
        if( reactions[index].partialSum < threshold ) {
            right = index + 1;
        }
        else {
            left = index;
        }
    }

    return &(reactions[right]);
}



static double _computeWaitingTime( BUG *bug ) {
    return _GetNextExponentialRandomNumber( bug->totalPropensities );
}


static void _setRandomSeed( unsigned int seed ) {
    _randomGen->SetSeed(seed);
    return;
}

static double _getNextUnitUniformRandomNumber( ) {
    return _randomGen->GetNextUnitUniform();
}

static double _GetNextExponentialRandomNumber( double lambda ) {
    return _randomGen->GetNextExponential(lambda);
}


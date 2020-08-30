
#ifndef _EVOLUTION_H
#define	_EVOLUTION_H

#ifdef	__cplusplus
extern "C" {
#endif

#include "def.h"
#include "bug.h"


#ifndef DEFAULT_POPULATION_SIZE
#define DEFAULT_POPULATION_SIZE 1000
#endif

#define DEFAULT_GENERATION_NUM 20000
#define DEFAULT_PRINT_GENERATION_INTERVAL 10

#define DEFAULT_ENV_FLUCTUATION_RATE 0.0
#if 0
#define DEFAULT_ENV_FLUCTUATION_RATE (1E-2)
#endif
#define DEFAULT_BUG_MUTATION_RATE (1E-2)

#define EVOLVABLE_SELECTION 1
#define K_HALF_MUTATION_FACTOR 5.0
#define BURST_MUTATION_FACTOR 1.0

#define DEFAULT_SIGNAL_TRUST 1.0


RET_VAL initializeEvolution(int argc, char **argv);
RET_VAL performEvolution();




#ifdef	__cplusplus
}
#endif

#endif	/* _EVOLUTION_H */


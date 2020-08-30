
#ifndef _OPTIONS_H
#define	_OPTIONS_H

#include "common.h"


#ifdef	__cplusplus
extern "C" {
#endif

    RET_VAL setArguments( int argc, char **argv );
    char *getOption( int index );
    


#ifdef	__cplusplus
}
#endif

#endif	/* _OPTIONS_H */


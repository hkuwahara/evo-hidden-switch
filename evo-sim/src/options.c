

#include "options.h"


static char **_argv;
static int _argc;

RET_VAL setArguments( int argc, char **argv ) {
    _argc = argc;
    _argv = argv;

    return SUCCESS;
}


char *getOption( int index ) {
    if( index < _argc ) {
        return _argv[index];
    }
    else {
        return NULL;
    }
}


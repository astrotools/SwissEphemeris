//
//  SwissEphGlue.h
//  SwissEphemeris
//
//  Created by Anner van Hardenbroek on 29-06-14.
//  Copyright (c) 2014 Behind the Scenes Software. All rights reserved.
//

#ifndef __SwissEphGlue__
#define __SwissEphGlue__

#include <stdio.h>
#include <stdbool.h>

// =========
#pragma mark Preprocessor macro's
// =========
#ifndef SEG_PRIVATE_EXTERN
#define SEG_PRIVATE_EXTERN __private_extern__
#endif

#ifndef SEG_PRIVATE
#ifdef DEBUG
    #define SEG_PRIVATE SEG_PRIVATE_EXTERN
#else
    #define SEG_PRIVATE __attribute__((__visibility__("hidden")))
#endif
#endif

#ifndef SEG_CONSTRUCTOR
#define SEG_CONSTRUCTOR __attribute__((constructor))
#endif

#ifndef SEG_DESTRUCTOR
#define SEG_DESTRUCTOR __attribute__((destructor))
#endif

// =========
#pragma mark Library support functions
// =========
SEG_PRIVATE // swi_fopen(): strcpy(s1, ephepath); -> _SEGDataFilesCopyPathForFile(s1, fname, ephepath);
void _SEGDataFilesCopyPathForFile(char *s1, const char *fileName, const char *ephepath);

// =========
#pragma mark swetest support functions
// =========
SEG_PRIVATE_EXTERN // swetest`main(): strcpy(ephepath, ""); -> _SEGDataFilesCopyFrameworkPath(ephepath, "");
void _SEGDataFilesCopyFrameworkPath(char *ephepath, __unused char *empty);

// =========
#pragma mark Library lifecycle
// =========
SEG_PRIVATE SEG_CONSTRUCTOR
void _SEGLibraryInitialize();

SEG_PRIVATE SEG_DESTRUCTOR
void _SEGLibraryFinalize();

#endif /* __SwissEphGlue__ */

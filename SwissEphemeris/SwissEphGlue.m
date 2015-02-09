//
//  SwissEphGlue.m
//  SwissEphemeris
//
//  Created by Anner van Hardenbroek on 29-06-14.
//  Copyright (c) 2014 Behind the Scenes Software. All rights reserved.
//

#import "SwissEphGlue.h"
#import <Foundation/Foundation.h>
#import "swephexp.h"
#import "sweph.h"

static NSBundle *_SWEDataFilesGetBundle() {
#if STATIC_LIBRARY
    return [NSBundle mainBundle];
#else
    return [NSBundle bundleWithIdentifier:@"com.astro.SwissEphemeris"];
#endif
}

static NSURL *SWEDataFilesGetFrameworkURL() {
    return _SWEDataFilesGetBundle().resourceURL;
}

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static NSURL *SWEDataFilesGetExternalURL() {
    static NSURL *pathURL;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        NSArray *appSupportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSCAssert(appSupportPaths.count > 0, @"No Application Support directory found for user '%@'", NSUserName());
        NSString *appSupportPath = appSupportPaths.lastObject;
        NSString *externalPath = [appSupportPath stringByAppendingPathComponent:@"SwissEphemeris"];
        pathURL = [NSURL fileURLWithPath:externalPath];
    });
    
    return pathURL;
}
#endif

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
void _SEGDataFilesCopyFrameworkPath(char *ephepath, __unused char *empty) {
    strcpy(ephepath, SWEDataFilesGetFrameworkURL().fileSystemRepresentation);
}
#endif

void _SEGDataFilesCopyPathForFile(char *datapath, const char *fname, const char *ephepath) {
#if !STATIC_LIBRARY
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fileName = @(fname);
    
#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    // Application Support path
    // This is the escape hatch for code signing (immutable resources)
    NSURL *pathURL = SWEDataFilesGetExternalURL();
    if ([fm fileExistsAtPath:[pathURL URLByAppendingPathComponent:fileName].path]) {
        strcpy(datapath, pathURL.fileSystemRepresentation);
        strcat(datapath, "/");
        return;
    }
#endif
    
    // Given data path
    // There are no ast directories in the framework resources directory
    if (![fileName hasPrefix:@"ast"] && [fm fileExistsAtPath:[@(ephepath) stringByAppendingPathComponent:fileName]]) {
        strcpy(datapath, ephepath);
        return;
    }
#endif

    // Configured ephemeris data path
    // User can change path via manual call to swe_set_ephe_path()
    strcpy(datapath, swed.ephepath);
}

void _SEGLibraryInitialize() {
    swe_set_ephe_path((char *)SWEDataFilesGetFrameworkURL().fileSystemRepresentation);
    
#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSURL *externalURL = SWEDataFilesGetExternalURL();
    if (![[NSFileManager defaultManager] fileExistsAtPath:externalURL.path]) {
        NSError *error;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtURL:externalURL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (!created) {
            NSLog(@"Error creating Application Support directory: %@", error);
        }
    }
#endif
}

void _SEGLibraryFinalize() {
    swe_close();
}

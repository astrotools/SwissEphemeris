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
    return [NSBundle bundleWithIdentifier:@"com.astro.SwissEphemeris"];
}

static NSURL *SWEDataFilesGetFrameworkURL() {
    return _SWEDataFilesGetBundle().resourceURL;
}

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

void _SEGDataFilesCopyFrameworkPath(char *ephepath, __unused char *empty) {
    strcpy(ephepath, SWEDataFilesGetFrameworkURL().fileSystemRepresentation);
}

void _SEGDataFilesCopyPathForFile(char *datapath, const char *fname, const char *ephepath) {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fileName = @(fname);
    
    // Application Support path
    // This is the escape hatch for code signing (immutable resources)
    NSURL *pathURL = SWEDataFilesGetExternalURL();
    if ([fm fileExistsAtPath:[pathURL URLByAppendingPathComponent:fileName].path]) {
        strcpy(datapath, pathURL.fileSystemRepresentation);
        strcat(datapath, "/");
        return;
    }
    
    // Given data path
    // There are no ast directories in the framework resources directory
    if (![fileName hasPrefix:@"ast"] && [fm fileExistsAtPath:[@(ephepath) stringByAppendingPathComponent:fileName]]) {
        strcpy(datapath, ephepath);
        return;
    }
    
    // Configured ephemeris data path
    // User can change path via manual call to swe_set_ephe_path()
    strcpy(datapath, swed.ephepath);
}

void _SEGLibraryInitialize() {
    swe_set_ephe_path((char *)SWEDataFilesGetFrameworkURL().fileSystemRepresentation);
    
    NSURL *externalURL = SWEDataFilesGetExternalURL();
    if (![[NSFileManager defaultManager] fileExistsAtPath:externalURL.path]) {
        NSError *error;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtURL:externalURL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (!created) {
            NSLog(@"Error creating Application Support directory: %@", error);
        }
    }
}

void _SEGLibraryFinalize() {
    swe_close();
}

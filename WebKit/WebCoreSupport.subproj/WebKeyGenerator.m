//
//  WebKeyGenerationFactory.m
//  WebKit
//
//  Created by Chris Blumenberg on Thu Nov 20 2003.
//  Copyright (c) 2003 Apple Computer, Inc. All rights reserved.
//

#import <WebKit/WebKeyGenerator.h>

#import <WebKit/WebAssertions.h>
#import <WebKit/WebKeyGeneration.h>
#import <WebKit/WebLocalizableStrings.h>

@implementation WebKeyGenerator

+ (void)createSharedGenerator
{
    if (![self sharedGenerator]) {
        [[[self alloc] init] release];
    }
    ASSERT([[self sharedGenerator] isKindOfClass:self]);
}

- (void)dealloc
{
    [strengthMenuItemTitles release];
    [super dealloc];
}

- (NSArray *)strengthMenuItemTitles
{
    if (!strengthMenuItemTitles) {
        strengthMenuItemTitles = [[NSArray alloc] initWithObjects:
            UI_STRING("2048 (High Grade)", "Menu item title for KEYGEN pop-up menu"),
            UI_STRING("1024 (Medium Grade)", "Menu item title for KEYGEN pop-up menu"),
            UI_STRING("512 (Low Grade)", "Menu item title for KEYGEN pop-up menu"), nil];
    }
    return strengthMenuItemTitles;
}

- (NSString *)signedPublicKeyAndChallengeStringWithStrengthIndex:(unsigned)index challenge:(NSString *)challenge
{    
    // This switch statement must always be synced with the UI strings returned by strengthMenuItemTitles.
    uint32 keySize;
    switch (index) {
        case 0:
            keySize = 2048;
            break;
        case 1:
            keySize = 1024;
            break;
        case 2:
            keySize = 512;
            break;
        default:
            return nil;
    }
    
    char *key = signedPublicKeyAndChallengeString(keySize, [challenge cString]);
    NSString *result = key ? [NSString stringWithCString:key] : nil;
    free(key);
    
    return result;
}

@end

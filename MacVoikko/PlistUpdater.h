//
//  PlistUpdater.h
//  MacVoikko
//
//  Created by Ben Navetta on 12/17/14.
//  Copyright (c) 2014 Voikko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUpdater : NSObject

+ (void)registerLanguages:(NSArray*)languages;

+ (void)refreshServices;

@end

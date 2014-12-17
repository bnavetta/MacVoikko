//
//  PlistUpdater.m
//  MacVoikko
//
//  Created by Ben Navetta on 12/17/14.
//  Copyright (c) 2014 Voikko. All rights reserved.
//

#import "PlistUpdater.h"

@implementation PlistUpdater

+ (void)registerLanguages:(NSArray*)languages
{
	NSURL* plistUrl = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"Contents/Info.plist"];
	
	NSMutableDictionary* plist = [[NSDictionary dictionaryWithContentsOfURL:plistUrl] mutableCopy];
	
	plist[@"NSServices"][0][@"NSLanguages"] = languages;
	
	NSString* error;
	NSData* newInfoPlist = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	if(newInfoPlist)
	{
		[newInfoPlist writeToURL:plistUrl atomically:YES];
	}
	else
	{
		NSAssert(@"Error writing plist: %@", error);
	}
}

+ (void)refreshServices
{
	NSTask* pbsTask = [[NSTask alloc] init];
	pbsTask.launchPath = @"/System/Library/CoreServices/pbs";
	pbsTask.arguments = @[@"-update"];
	[pbsTask launch];
	[pbsTask waitUntilExit];
}

@end

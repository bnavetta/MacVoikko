//
//  main.m
//  MacVoikko
//

#import <Foundation/Foundation.h>

#import "CocoaVoikko.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NSLog(@"Languages: %@", [CocoaVoikko spellingLanguagesAtPath:nil]);
		
		NSSpellServer* server = [[NSSpellServer alloc] init];
		
		[server run];
	}
}

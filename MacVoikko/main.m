//
//  main.m
//  MacVoikko
//

#import <Foundation/Foundation.h>

#import "VoikkoSpellChecker.h"

#define VoikkoVendor @"Voikko"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		
		VoikkoSpellChecker* checker = [[VoikkoSpellChecker alloc] init];
		
		NSSpellServer* server = [[NSSpellServer alloc] init];
		
		for(NSString* language in [checker supportedLanguages])
		{
			if([server registerLanguage:language byVendor:VoikkoVendor])
			{
				NSLog(@"Registered support for %@", language);
			}
			else
			{
				NSLog(@"Failed to register support for %@", language);
			}
		}
		
		server.delegate = checker;
		
		[server run];
	}
}

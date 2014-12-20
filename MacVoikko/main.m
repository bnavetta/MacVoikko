//
//  main.m
//  MacVoikko
//

#import <Foundation/Foundation.h>

#import "VoikkoSpellChecker.h"
#import "PlistUpdater.h"

#define VoikkoVendor @"MacVoikko"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		
		VoikkoSpellChecker* checker = [[VoikkoSpellChecker alloc] init];
		
		NSArray* languages = [checker supportedLanguages];
		
		[PlistUpdater registerLanguages:languages];
		[PlistUpdater refreshServices];
		
		NSSpellServer* server = [[NSSpellServer alloc] init];
		int registeredLanguages = 0;
		for(NSString* language in languages)
		{
			NSLog(@"Registering %@", language);
			if([server registerLanguage:language byVendor:VoikkoVendor])
			{
				registeredLanguages++;
			}
		}
		
		if(registeredLanguages > 0)
		{
			NSLog(@"Registered %d languages", registeredLanguages);
			[server setDelegate:checker];
			[server run];
			NSLog(@"Unexpected death of MacVoikko spell checker");
		}
		else
		{
			NSLog(@"Unable to register any languages for MacVoikko spell checker");
		}
	}
}

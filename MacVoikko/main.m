//
//  main.m
//  MacVoikko
//

#import <Foundation/Foundation.h>
#import "voikko.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NSSpellServer* server = [[NSSpellServer alloc] init];
		
		[server run];
	}
}

//
//  main.m
//  MacVoikko
//
//  Created by Ben Navetta on 12/13/14.
//  Copyright (c) 2014 Voikko. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NSSpellServer* server = [[NSSpellServer alloc] init];
		
		[server run];
	}
}

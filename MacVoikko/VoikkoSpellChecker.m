//
//  VoikkoSpellChecker.m
//  MacVoikko
//

#import "VoikkoSpellChecker.h"
#import "CocoaVoikko.h"

@implementation VoikkoSpellChecker

- (NSArray *)supportedLanguages
{
	NSLocale* enLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
	
	NSArray* languageCodes = [CocoaVoikko spellingLanguagesAtPath:nil];
	NSMutableArray* languages = [NSMutableArray arrayWithCapacity:[languageCodes count]];
	for(NSString* languageCode in languageCodes)
	{
		NSString* languageName = [enLocale displayNameForKey:NSLocaleIdentifier value:languageCode];
		[languages addObject:languageName];
	}
	return languages;
}

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly
{
	NSLog(@"Find misspelled word in '%@' (language %@)", stringToCheck, language);
	
	return NSMakeRange(0, 0);
}

@end

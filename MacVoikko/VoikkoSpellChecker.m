//
//  VoikkoSpellChecker.m
//  MacVoikko
//

#import "VoikkoSpellChecker.h"
#import "CocoaVoikko.h"

@interface VoikkoSpellChecker ()

@property (nonatomic, strong) NSDictionary* handles;

@end

@implementation VoikkoSpellChecker

- (instancetype)init
{
	self = [super init];
	
	if(self)
	{
		_handles = [VoikkoSpellChecker initializeHandles];
	}
	
	return self;
}

- (NSArray *)supportedLanguages
{
	return [CocoaVoikko spellingLanguages];
}

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language
{
#ifdef DEBUG
	NSLog(@"Finding suggestions for '%@' in %@", word, language);
#endif
	
	CocoaVoikko* handle = self.handles[language];
	if(handle != nil)
	{
		return [handle suggestionsForWord:word];
	}
	else
	{
		NSLog(@"Get suggestions - unknown language: %@", language);
		return [NSArray array];
	}
}

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly
{
#ifdef DEBUG
	NSLog(@"Finding %@ in %@ - '%@'", countOnly ? @"word count" : @"spelling and word count", language, stringToCheck);
#endif
	
	CocoaVoikko* handle = self.handles[language];
	if(handle != nil)
	{
		if(countOnly == YES)
		{
			*wordCount = [handle wordCount:stringToCheck];
			return NSMakeRange(NSNotFound, 0);
		}
		
		// TODO: handle user dictionary
		return [handle nextMisspelledWord:stringToCheck wordCount:wordCount];
	}
	else
	{
		NSLog(@"Find misspellings - unknown language: %@", language);
		return NSMakeRange(NSNotFound, 0);
	}
}

+ (NSDictionary*)initializeHandles
{
	NSError* error = nil;
	NSMutableDictionary* handles = [NSMutableDictionary dictionary];
	for(NSString* languageCode in [CocoaVoikko spellingLanguages])
	{
		CocoaVoikko* handle = [[CocoaVoikko alloc] initWithLangcode:languageCode error:&error];
		
		if(handle == nil)
		{
			NSLog(@"Unable to create Voikko handle for language %@: %@", languageCode, error.localizedDescription);
		}
		else
		{
			handles[languageCode] = handle;
		}
	}
	
	return handles;
}

@end

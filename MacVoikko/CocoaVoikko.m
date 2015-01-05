//
//  CocoaVoikko.m
//  MacVoikko
//

#import "CocoaVoikko.h"

@implementation CocoaVoikko
{
	struct VoikkoHandle* handle;
}

- (instancetype)initWithLangcode:(NSString *)langCode andPath:(NSString *)path error:(NSError *__autoreleasing *)error
{
	if (self = [super init])
	{
		const char* cError = NULL;
		handle = voikkoInit(&cError, [langCode UTF8String], path == nil ? NULL : [path fileSystemRepresentation]);
		
		if(handle == NULL)
		{
			*error = [[NSError alloc] initWithDomain:VoikkoErrorDomain code:VoikkoInitError userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:cError]}];
			return nil;
		}
	}
	
	return self;
}

- (instancetype)initWithLangcode:(NSString *)langCode error:(NSError *__autoreleasing *)error
{
	return [self initWithLangcode:langCode andPath:[[[CocoaVoikko includedDictionariesPath] absoluteURL] path] error:error];
}

- (void)dealloc
{
	if(handle)
	{
		voikkoTerminate(handle);
	}
}

- (void)enumerateTokens:(NSString *)text withBlock:(TokenCallback)callback
{
	// Maintain separate byte and character offsets since they will differ for non-ASCII input
	// See https://github.com/walokra/osxspell/blob/6ab9f886dbf9763587af25cd5f7ed2ac9a92ef2b/VoikkoSpellService.m#L42
	
	const char* byteString = [text UTF8String];
	size_t byteLen = strlen(byteString);
	size_t byteOffset = 0;
	size_t charOffset = 0;
	size_t tokenLen = 0; // voikko returns token length in characters
	
	enum voikko_token_type tokenType;
	do {
		tokenType = voikkoNextTokenCstr(handle, byteString + byteOffset, byteLen - byteOffset, &tokenLen);
		NSRange tokenRange = NSMakeRange(charOffset, tokenLen);
		NSString* token = [text substringWithRange:tokenRange];
		
#ifdef DEBUG
		NSLog(@"Token of type %d in %@ - '%@'", tokenType, NSStringFromRange(tokenRange), token);
#endif
		BOOL keepGoing = callback(tokenType, token, tokenRange);
		
		if(!keepGoing)
		{
			break;
		}
		
		// https://github.com/walokra/osxspell/blob/6ab9f886dbf9763587af25cd5f7ed2ac9a92ef2b/VoikkoSpellService.m#L55
		byteOffset += strlen([token UTF8String]);
		charOffset += tokenLen;
	} while (tokenType != TOKEN_NONE);
}

- (int)checkSpelling:(NSString *)word
{
	return voikkoSpellCstr(handle, [word UTF8String]);
}

- (NSRange)nextMisspelledWord:(NSString *)text wordCount:(NSInteger *)wordCount
{
	__block NSRange range = NSMakeRange(NSNotFound, 0);
	__block int wc = 0;
	[self enumerateTokens:text withBlock:^BOOL(enum voikko_token_type tokenType, NSString* token, NSRange tokenLoc) {
		if(tokenType == TOKEN_WORD)
		{
			wc++;
			int spelling = [self checkSpelling:token];
			if(spelling == VOIKKO_SPELL_FAILED)
			{
				range = tokenLoc;
				return NO;
			}
		}
		return YES;
	}];
	
	*wordCount = wc;
	return range;
}

- (NSInteger)wordCount:(NSString *)text
{
	__block NSInteger wc = 0;
	
	[self enumerateTokens:text withBlock:^BOOL(enum voikko_token_type tokenType, NSString* token, NSRange tokenLoc) {
		if(tokenType == TOKEN_WORD)
		{
			wc++;
		}
		return YES;
	}];
	
	return wc;
}

- (NSArray *)suggestionsForWord:(NSString *)word
{
	char** cSuggestions = voikkoSuggestCstr(handle, [word UTF8String]);
	NSMutableArray* suggestions = [NSMutableArray array];
	
	if(cSuggestions)
	{
		for(char** suggestionPtr = cSuggestions; *suggestionPtr != NULL; suggestionPtr++)
		{
			NSString* suggestion = [NSString stringWithUTF8String:*suggestionPtr];
			[suggestions addObject:suggestion];
		}
		voikkoFreeCstrArray(cSuggestions);
	}
	
	return suggestions;
}

+ (NSArray *)spellingLanguagesAtPath:(NSString*)path
{
	char** languageCodes = voikkoListSupportedSpellingLanguages(path == nil ? 0 : [path fileSystemRepresentation]);
	
	NSMutableArray* languages = [NSMutableArray array];
	for(char** i = languageCodes; *i != 0; i++)
	{
		[languages addObject:[NSString stringWithUTF8String:*i]];
	}
	voikkoFreeCstrArray(languageCodes);
	
	return languages;
}

+ (NSArray*)spellingLanguages
{
	return [CocoaVoikko spellingLanguagesAtPath:[[[CocoaVoikko includedDictionariesPath] absoluteURL] path]];
}

+ (NSURL*)includedDictionariesPath
{
	return [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Dictionaries" isDirectory:YES];
}

@end

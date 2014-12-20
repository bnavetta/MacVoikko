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
	const char* cText = [text UTF8String];
	size_t textLen = strlen(cText);
	size_t offset = 0;
	size_t tokenLen = 0;
	
	enum voikko_token_type tokenType;
	while(tokenType != TOKEN_NONE)
	{
		tokenType = voikkoNextTokenCstr(handle, cText + offset, textLen, &tokenLen);
		
		NSString* token = [[NSString alloc] initWithBytes:cText + offset length:tokenLen - offset encoding:NSUTF8StringEncoding];
		BOOL keepGoing = callback(tokenType, token, NSMakeRange(offset, tokenLen));
	
		offset += tokenLen;
		
		if(!keepGoing)
		{
			break;
		}
	}
}

- (int)checkSpelling:(NSString *)word
{
	return voikkoSpellCstr(handle, [word UTF8String]);
}

- (NSRange)nextMisspelledWord:(NSString *)text wordCount:(NSInteger *)wordCount
{
	__block NSRange range;
	__block int wc = 0;
	[self enumerateTokens:text withBlock:^BOOL(enum voikko_token_type tokenType, NSString* token, NSRange tokenLoc) {
		NSLog(@"Token '%@' of type %d at %@", token, tokenType, NSStringFromRange(tokenLoc));
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

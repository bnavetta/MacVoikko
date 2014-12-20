//
//  CocoaVoikko.h
//  MacVoikko
//

#import <Foundation/Foundation.h>
#import "libvoikko/voikko.h"

#define VoikkoErrorDomain @"VoikkoError"

#define VoikkoInitError 1

typedef BOOL (^TokenCallback)(enum voikko_token_type tokenType, NSString* token, NSRange tokenLoc);

@interface CocoaVoikko : NSObject

/**
 *	Initialize a Voikko instance
 *
 *	@param langCode the BCP 47 language tag for the language to be used
 *	@param path     an additional dictionary search path
 *	@param error    this will be set to a NSError instance if the call to voikkoInit fails
 *
 *	@return this
 */
- (instancetype)initWithLangcode:(NSString*)langCode andPath:(NSString*)path error:(NSError**)error;

/**
 *	Initialize a Voikko instance
 *  No additional search paths will be used
 *
 *	@param langCode the BCP 47 language tag for the language to be used
 *	@param error    this will be set to a NSError instance if the call to voikkoInit fails
 *
 *	@return this
 */
- (instancetype)initWithLangcode:(NSString*)langCode error:(NSError**)error;

- (void)enumerateTokens:(NSString*)text withBlock:(TokenCallback)callback;

- (NSInteger)wordCount:(NSString*)text;

- (NSRange)nextMisspelledWord:(NSString*)text wordCount:(NSInteger*)wordCount;

- (int)checkSpelling:(NSString*)word;

+ (NSArray*)spellingLanguagesAtPath:(NSString*)path;

+ (NSArray*)spellingLanguages;

+ (NSURL*)includedDictionariesPath;

@end

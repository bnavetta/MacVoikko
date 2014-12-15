//
//  VoikkoSpellChecker.h
//  MacVoikko
//

#import <Foundation/Foundation.h>

@interface VoikkoSpellChecker : NSObject <NSSpellServerDelegate>

- (NSArray*)supportedLanguages;

@end

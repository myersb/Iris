//
//  CreateHash.m
//  Iris
//
//  Created by Benjamin Myers on 6/3/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "MD5Hasher.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ConvertString)


- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
	
    return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end

@implementation MD5Hasher

- (NSString *)createHashWithUserInput:(NSString *)userInput andSalt:(NSString *)salt
{
	NSString *userInputPlusSalt = [NSString stringWithFormat:@"%@%@", userInput, salt];
	NSString *generatedInput = [userInputPlusSalt MD5String];
	
	return generatedInput;
}

@end
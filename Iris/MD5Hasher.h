//
//  CreateHash.h
//  Iris
//
//  Created by Benjamin Myers on 6/3/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Hasher : NSObject

- (NSString *)createHashWithUserInput:(NSString *)userInput andSalt:(NSString *)salt;

@end

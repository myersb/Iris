//
//  UserLogin.h
//  Iris
//
//  Created by Benjamin Myers on 6/25/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLogin : NSObject

// Variable Properties
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

// Public Methods
- (BOOL)validateLoginWithUsername:(NSString *)username andPassword:(NSString *)password;

@end

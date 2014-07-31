//
//  UserLogin.m
//  Iris
//
//  Created by Benjamin Myers on 6/25/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "UserLogin.h"
#import "InventoryDataHandler.h"

#define webServiceLoginURL @"https://claytonupdatecenter.com/cfide/remoteInvoke.cfc?method=processPostJSONArray&obj=LINK&MethodToInvoke=login&key=MDBUSS9CRE9WSlA6I1RJTjVHJU0rX0AgIAo=&datasource=appclaytonweb&linkonly=0&"

@implementation UserLogin

- (BOOL)validateLoginWithUsername:(NSString *)username andPassword:(NSString *)password
{
	InventoryDataHandler *dataHandler;
	dataHandler = [[InventoryDataHandler alloc] init];
	BOOL segue = FALSE;
	
	// Setup params
    NSString *urlString = [NSString stringWithFormat:@"%@", webServiceLoginURL];
	
    // Create request
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
	
    // Setup Post Body
    NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
	
    // setup request header
    //[request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
	
    // Setup the Body of hte post
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *requestBodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
	NSLog(@"REQUEST: %@", requestBodyString);
	
    // Post data and put the returned data into a variable
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil ];
	
    // Stick the encoded returned data into a variable
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"RS: %@", returnString);
	
    // Serialize the jSON return
	NSDictionary *jSON = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
	
	// Creates a dictionary that goes inside the first data object eg. {data:[
	NSDictionary *dataDictionary = [jSON objectForKey:@"data"];
	NSLog(@"Dictionary: %@", dataDictionary);
	if ([dataDictionary count] > 0)
	{
		for (NSDictionary *item in dataDictionary)
		{
			int isActive = [[item objectForKey:@"isactive"] intValue];
			int isError = [[item objectForKey:@"iserror"] intValue];
			NSLog(@"isActive: %d", isActive);
			NSLog(@"isError: %d", isError);
			if (isActive == 1 && isError == 0)
			{
				[dataHandler downloadInventoryAndActions];
				segue = TRUE;
			} else {
				segue = FALSE;
			}
		}
	} else {
		segue = FALSE;
	}
	
	return segue;
}

@end

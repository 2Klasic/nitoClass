//
//  Credentials.h
//  iOS-URLDownloader
//
//  Created by Kristijan Sedlak on 7/21/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#define OurLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);

#import <Foundation/Foundation.h>


@interface URLCredential : NSObject
{
    NSString *username;
    NSString *password;
    NSURLCredentialPersistence persistance;
}

@property(retain) NSString *username;
@property(retain) NSString *password;
@property(assign) NSURLCredentialPersistence persistance;

+ (id)credentialWithUsername:(NSString *)user andPassword:(NSString *)pass;
- (id)initWithDefaults;

@end

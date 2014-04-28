//
//  TXHConfiguration.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHConfiguration.h"

@implementation TXHConfiguration

+ (TXHConfiguration *)sharedInstance
{
    static TXHConfiguration *_sharedInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TXHConfiguration alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        //The name of each configuration file can be set in the build configurations info.plist under the corresponding Key.
        NSString *mainConfig   = [self pathForConfigFileInMainPlist:@"TXHMainConfigFile"];
        NSString *sharedConfig = [self pathForConfigFileInMainPlist:@"TXHSharedConfigFile"];
        
        _configuration = [NSMutableDictionary dictionaryWithContentsOfFile:mainConfig];
        
        [_configuration addEntriesFromDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:sharedConfig]];
    }
    return self;
}

- (NSString *)pathForConfigFileInMainPlist:(NSString *)key
{
    NSString *configFileName = [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
    return [[NSBundle bundleForClass:[self class]] pathForResource:configFileName ofType:nil];
}

@end


@implementation TXHConfiguration (subscripts)

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    NSParameterAssert(key);
    if (!obj)
    {
        [_configuration removeObjectForKey:key];
        [_userDefaults removeObjectForKey:(NSString *)key];
        [_userDefaults synchronize];
        return;
    }
    else
    {
        _configuration[key] = obj;
        [_userDefaults setObject:obj forKey:(NSString*)key];
        [_userDefaults synchronize];
    }
    
}

- (id)objectForKeyedSubscript:(id)key
{
    NSParameterAssert(key);
    id obj = _configuration[key];
    if (!obj)
        obj = [_userDefaults objectForKey:key];
    return obj;
}

@end

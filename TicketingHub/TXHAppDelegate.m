//
//  TXHAppDelegate.m
//  TicketingHub
//
//  Created by Mark Brindle on 06/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHAppDelegate.h"
#import "TXHTicketingHubManager.h"
#import "AFNetworkActivityLogger.h"
#import <AFNetworking.h>

//printers - move that away from app delegate
#import "TXHPrintersManager.h"
#import "TXHStarIOPrintersEngine.h"

@interface TXHAppDelegate ()

@end

@implementation TXHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    // Remove all local data when launching app
    [TXHTicketingHubManager clearLocalData];

    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:1.0f / 255.0f green:46.0f / 255.0f blue:67.0f / 255.0f alpha:1.0f]];

    
    TXHStarIOPrintersEngine *starEngine = [TXHStarIOPrintersEngine new];
    [TXHPRINTERSMANAGER addPrinterEngine:starEngine];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called just before the application is terminated.
}

@end

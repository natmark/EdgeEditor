//
//  AppDelegate.m
//  ColorPicker
//
//  Created by Atsuya Sato on 2014/08/24.
//  Copyright (c) 2014年 Atsuya Sato. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     NSSetUncaughtExceptionHandler(&exceptionHandler);
    // Override point for customization after application launch.
    return YES;
}
void exceptionHandler(NSException *exception)
{
    /*
     LOG関数は コンソールログを出力する関数 DEBUG時にとても有効です。
     別エントリーで解説します。
     */
    // 不正終了した箇所を示す スタックトレースをコンソールログに出力する
    NSLog(@"stackSymbols:%@", [exception callStackSymbols]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  AppDelegate.m
//  SPCanvasDemo
//
//  Created by Super Y on 2019/12/3.
//  Copyright © 2019 Super Y. All rights reserved.
//

#import "AppDelegate.h"
#import "SPCanvasVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[SPCanvasVC alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end

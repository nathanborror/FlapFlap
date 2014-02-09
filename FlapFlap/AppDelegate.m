//
//  AppDelegate.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/5/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  ViewController *viewController = [[ViewController alloc] init];
  [_window setRootViewController:viewController];

  [_window setBackgroundColor:[UIColor whiteColor]];
  [_window makeKeyAndVisible];
  return YES;
}

@end

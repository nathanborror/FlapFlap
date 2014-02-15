//
//  ViewController.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/5/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "ViewController.h"
#import "NewGameScene.h"

@implementation ViewController

- (void)loadView
{
  self.view  = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

  SKView *view = (SKView *)[self view];
  [view setShowsFPS:YES];
  [view setShowsNodeCount:YES];

  SKScene *scene = [NewGameScene sceneWithSize:view.bounds.size];
  [scene setScaleMode:SKSceneScaleModeAspectFill];

  [view presentScene:scene];
}

@end

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

  SKView *skView = (SKView *)[self view];
  [skView setShowsFPS:YES];
  [skView setShowsNodeCount:YES];

  SKScene *scene = [NewGameScene sceneWithSize:skView.bounds.size];
  [scene setScaleMode:SKSceneScaleModeAspectFill];

  [skView presentScene:scene];
}

@end

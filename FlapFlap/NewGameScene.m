//
//  NewGameScene.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/9/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "NewGameScene.h"
#import "MainScene.h"

@implementation NewGameScene {
  SKSpriteNode *_button;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    [self setBackgroundColor:[SKColor colorWithRed:.61 green:.74 blue:.86 alpha:1]];

    _button = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:1 alpha:1] size:CGSizeMake(128, 32)];
    [_button setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self addChild:_button];
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:.4];
  MainScene *main = [[MainScene alloc] initWithSize:self.size];
  [self.scene.view presentScene:main transition:transition];
}

@end

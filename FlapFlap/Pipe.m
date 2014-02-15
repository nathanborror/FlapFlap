//
//  Pipe.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/8/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "Pipe.h"

static const CGFloat kPipeWidth = 56.0;
static const CGFloat kGroundHeight = 56.0;

@implementation Pipe

+ (Pipe *)pipeWithHeight:(CGFloat)height withStyle:(PipeStyle)style
{
  NSString *pipeImageName;
  CGFloat pipeYOffset;

  if (style == PipeStyleTop) {
    pipeImageName = @"PipeTop";
    pipeYOffset = -[[UIScreen mainScreen] applicationFrame].size.height;
  } else {
    pipeImageName = @"PipeBottom";
    pipeYOffset = kGroundHeight-2;
  }

  Pipe *pipe = [[Pipe alloc] initWithImageNamed:pipeImageName];
  [pipe setCenterRect:CGRectMake(26.0/kPipeWidth, 26.0/kPipeWidth, 4.0/kPipeWidth, 4.0/kPipeWidth)];
  [pipe setYScale:height/pipe.size.height];
  [pipe setPosition:CGPointMake(320+(pipe.size.width/2), abs(pipeYOffset + (pipe.size.height/2)))];

  pipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe.size];
  [pipe.physicsBody setAffectedByGravity:NO];
  [pipe.physicsBody setDynamic:NO];

  return pipe;
}

- (void)setPipeCategory:(uint32_t)pipe playerCategory:(uint32_t)player
{
  [self.physicsBody setCategoryBitMask:pipe];
  [self.physicsBody setCollisionBitMask:player];
}

@end

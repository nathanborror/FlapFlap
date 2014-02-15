//
//  Pipe.h
//  FlapFlap
//
//  Created by Nathan Borror on 2/8/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, PipeStyle) {
  PipeStyleTop,
  PipeStyleBottom,
};

@interface Pipe : SKSpriteNode

+ (Pipe *)pipeWithHeight:(CGFloat)height withStyle:(PipeStyle)style;

- (void)setPipeCategory:(uint32_t)pipe playerCategory:(uint32_t)player;

@end

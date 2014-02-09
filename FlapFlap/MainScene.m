//
//  MainScene.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/5/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "MainScene.h"
#import "Player.h"
#import "Obstacle.h"

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;

static const CGFloat kGravity = -10;
static const CGFloat kThrust = 50;
static const CGFloat kDensity = 1.5;

static const CGFloat kObstacleSpeed = 6;

@implementation MainScene {
  Player *_player;

  Obstacle *_pipeTop;
  Obstacle *_pipeBottom;

  SKSpriteNode *_ground;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    [self setBackgroundColor:[SKColor colorWithWhite:.1 alpha:1]];

    [self.physicsWorld setGravity:CGVectorMake(0, kGravity)];
    [self.physicsWorld setContactDelegate:self];

    _ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor] size:CGSizeMake(self.size.width, 64)];
    [_ground setPosition:CGPointMake(self.size.width/2, _ground.size.height/2)];
    [self addChild:_ground];

    _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
    [_ground.physicsBody setCategoryBitMask:kGroundCategory];
    [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
    [_ground.physicsBody setAffectedByGravity:NO];
    [_ground.physicsBody setDynamic:NO];

    [self setupPlayer];
    [self setupObstacle];
  }
  return self;
}

- (void)setupPlayer
{
  _player = [Player spriteNodeWithColor:[SKColor colorWithWhite:1 alpha:1] size:CGSizeMake(32, 32)];
  [_player setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
  [self addChild:_player];

  _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
  [_player.physicsBody setDensity:kDensity];
  [_player.physicsBody setCategoryBitMask:kPlayerCategory];
  [_player.physicsBody setContactTestBitMask:kPipeCategory | kGroundCategory];
  [_player.physicsBody setCollisionBitMask:kGroundCategory];
}

- (void)setupObstacle
{
  _pipeTop = [Obstacle spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(64, 200)];
  [_pipeTop setPosition:CGPointMake(self.size.width+(_pipeTop.size.width/2), self.size.height-(_pipeTop.size.height/2))];
  [self addChild:_pipeTop];

  _pipeTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_pipeTop.size];
  [_pipeTop.physicsBody setCategoryBitMask:kPipeCategory];
  [_pipeTop.physicsBody setCollisionBitMask:0];
  [_pipeTop.physicsBody setAffectedByGravity:NO];

  _pipeBottom = [Obstacle spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(64, 200)];
  [_pipeBottom setPosition:CGPointMake(self.size.width+(_pipeBottom.size.width/2), (_pipeBottom.size.height/2))];
  [self addChild:_pipeBottom];

  _pipeBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_pipeBottom.size];
  [_pipeBottom.physicsBody setCategoryBitMask:kPipeCategory];
  [_pipeBottom.physicsBody setCollisionBitMask:0];
  [_pipeBottom.physicsBody setAffectedByGravity:NO];

  // Move top pipe
  SKAction *pipeTopAction = [SKAction moveToX:-(_pipeTop.size.width/2) duration:kObstacleSpeed];
  SKAction *pipeTopSequence = [SKAction sequence:@[pipeTopAction, [SKAction runBlock:^{
    [_pipeTop setPosition:CGPointMake(self.size.width+(_pipeTop.size.width/2), self.size.height-(_pipeTop.size.height/2))];
  }]]];

  [_pipeTop runAction:[SKAction repeatActionForever:pipeTopSequence]];

  // Move bottom pipe
  SKAction *pipeBottomAction = [SKAction moveToX:-(_pipeBottom.size.width/2) duration:kObstacleSpeed];
  SKAction *pipeBottomSequence = [SKAction sequence:@[pipeBottomAction, [SKAction runBlock:^{
//    [_pipeBottom setPosition:CGPointMake(self.size.width+(_pipeBottom.size.width/2), self.size.height-(_pipeBottom.size.height/2))];
    [_pipeBottom setPosition:CGPointMake(self.size.width+(_pipeBottom.size.width/2), (_pipeBottom.size.height/2))];
  }]]];

  [_pipeBottom runAction:[SKAction repeatActionForever:pipeBottomSequence]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [_player.physicsBody applyImpulse:CGVectorMake(0, kThrust)];
}

@end

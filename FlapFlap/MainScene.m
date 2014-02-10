//
//  MainScene.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/5/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "MainScene.h"
#import "NewGameScene.h"
#import "Player.h"
#import "Obstacle.h"

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;

static const CGFloat kGravity = -10;
static const CGFloat kDensity = 1.15;
static const CGFloat kMaxVelocity = 400;

static const CGFloat kPipeSpeed = 4;
static const CGFloat kPipeWidth = 64;
static const CGFloat kPipeGap = 130;
static const CGFloat kPipeFrequency = 2;

static const CGFloat randomFloat(CGFloat Min, CGFloat Max){
  return floor(((arc4random() % RAND_MAX) / (RAND_MAX * 1.0)) * (Max - Min) + Min);
}

@implementation MainScene {
  Player *_player;
  SKSpriteNode *_ground;
  SKLabelNode *_scoreLabel;
  NSInteger _score;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    _score = 0;

    [self setBackgroundColor:[SKColor colorWithRed:.45 green:.77 blue:.81 alpha:1]];

    [self.physicsWorld setGravity:CGVectorMake(0, kGravity)];
    [self.physicsWorld setContactDelegate:self];

    _ground = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:.87 green:.84 blue:.59 alpha:1] size:CGSizeMake(self.size.width, 64)];
    [_ground setPosition:CGPointMake(self.size.width/2, _ground.size.height/2)];
    [self addChild:_ground];

    _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
    [_ground.physicsBody setCategoryBitMask:kGroundCategory];
    [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
    [_ground.physicsBody setAffectedByGravity:NO];
    [_ground.physicsBody setDynamic:NO];

    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    [_scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height-50)];
    [_scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)_score]];
    [self addChild:_scoreLabel];

    [self setupPlayer];

    [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(addObstacle) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(startScoreTimer) userInfo:nil repeats:nil];
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
  [_player.physicsBody setAllowsRotation:NO];

  [_player.physicsBody setCategoryBitMask:kPlayerCategory];
  [_player.physicsBody setContactTestBitMask:kPipeCategory | kGroundCategory];
  [_player.physicsBody setCollisionBitMask:kGroundCategory | kPipeCategory];
}

- (void)addObstacle
{
  CGFloat centerY = randomFloat(kPipeGap, self.size.height-kPipeGap);
  CGFloat pipeTopHeight = centerY - (kPipeGap/2);
  CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap/2));

  // Top Pipe
  Obstacle *pipeTop = [Obstacle spriteNodeWithColor:[SKColor colorWithRed:.34 green:.49 blue:.18 alpha:1] size:CGSizeMake(kPipeWidth, pipeTopHeight)];
  [pipeTop setPosition:CGPointMake(self.size.width+(pipeTop.size.width/2), self.size.height-(pipeTop.size.height/2))];
  [self addChild:pipeTop];

  pipeTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeTop.size];
  [pipeTop.physicsBody setAffectedByGravity:NO];
  [pipeTop.physicsBody setDynamic:NO];

  [pipeTop.physicsBody setCategoryBitMask:kPipeCategory];
  [pipeTop.physicsBody setCollisionBitMask:kPlayerCategory];

  // Bottom Pipe
  Obstacle *pipeBottom = [Obstacle spriteNodeWithColor:[SKColor colorWithRed:.34 green:.49 blue:.18 alpha:1] size:CGSizeMake(kPipeWidth, pipeBottomHeight)];
  [pipeBottom setPosition:CGPointMake(self.size.width+(pipeBottom.size.width/2), (pipeBottom.size.height/2))];
  [self addChild:pipeBottom];

  pipeBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeBottom.size];
  [pipeBottom.physicsBody setAffectedByGravity:NO];
  [pipeBottom.physicsBody setDynamic:NO];

  [pipeBottom.physicsBody setCategoryBitMask:kPipeCategory];
  [pipeBottom.physicsBody setCollisionBitMask:kPlayerCategory];

  // Move top pipe
  SKAction *pipeTopAction = [SKAction moveToX:-(pipeTop.size.width/2) duration:kPipeSpeed];
  SKAction *pipeTopSequence = [SKAction sequence:@[pipeTopAction, [SKAction runBlock:^{
    [pipeTop removeFromParent];
  }]]];

  [pipeTop runAction:[SKAction repeatActionForever:pipeTopSequence]];

  // Move bottom pipe
  SKAction *pipeBottomAction = [SKAction moveToX:-(pipeBottom.size.width/2) duration:kPipeSpeed];
  SKAction *pipeBottomSequence = [SKAction sequence:@[pipeBottomAction, [SKAction runBlock:^{
    [pipeBottom removeFromParent];
  }]]];

  [pipeBottom runAction:[SKAction repeatActionForever:pipeBottomSequence]];
}

- (void)startScoreTimer
{
  [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}

- (void)incrementScore
{
  _score++;
  [_scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)_score]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [_player.physicsBody setVelocity:CGVectorMake(_player.physicsBody.velocity.dx, kMaxVelocity)];
}

- (void)update:(NSTimeInterval)currentTime
{
  if (_player.physicsBody.velocity.dy > kMaxVelocity) {
    [_player.physicsBody setVelocity:CGVectorMake(_player.physicsBody.velocity.dx, kMaxVelocity)];
  }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
  SKNode *node = contact.bodyA.node;
  if ([node isKindOfClass:[Player class]]) {
    SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:.4];
    NewGameScene *newGame = [[NewGameScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newGame transition:transition];
  }
}

@end

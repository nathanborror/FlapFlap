//
//  GameScene.m
//  FlapFlap
//
//  Created by Nathan Borror on 2/5/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "GameScene.h"
#import "NewGameScene.h"
#import "Player.h"
#import "Pipe.h"

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;

static const CGFloat kGravity = -9.5;
static const CGFloat kDensity = 1.15;
static const CGFloat kMaxVelocity = 400;

static const CGFloat kPipeSpeed = 3.5;
static const CGFloat kPipeGap = 120;
static const CGFloat kPipeFrequency = kPipeSpeed/2;

static const CGFloat kGroundHeight = 56.0;

static const NSInteger kNumLevels = 20;

static const CGFloat randomFloat(CGFloat Min, CGFloat Max){
  return floor(((rand() % RAND_MAX) / (RAND_MAX * 1.0)) * (Max - Min) + Min);
}

@implementation GameScene {
  Player *_player;
  SKSpriteNode *_ground;
  SKLabelNode *_scoreLabel;
  NSInteger _score;
  NSTimer *_pipeTimer;
  NSTimer *_scoreTimer;
  SKAction *_pipeSound;
  SKAction *_punchSound;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    _score = 0;

    srand((time(nil) % kNumLevels)*10000);

    [self setBackgroundColor:[SKColor colorWithRed:.69 green:.84 blue:.97 alpha:1]];

    [self.physicsWorld setGravity:CGVectorMake(0, kGravity)];
    [self.physicsWorld setContactDelegate:self];

    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud"];
    [cloud1 setPosition:CGPointMake(100, self.size.height - (cloud1.size.height*3))];
    [self addChild:cloud1];

    SKSpriteNode *cloud2 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud"];
    [cloud2 setPosition:CGPointMake(self.size.width - (cloud2.size.width/2) + 50, self.size.height - (cloud2.size.height*5))];
    [self addChild:cloud2];

    _ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    [_ground setCenterRect:CGRectMake(26.0/kGroundHeight, 26.0/kGroundHeight, 4.0/kGroundHeight, 4.0/kGroundHeight)];
    [_ground setXScale:self.size.width/kGroundHeight];
    [_ground setPosition:CGPointMake(self.size.width/2, _ground.size.height/2)];
    [self addChild:_ground];

    _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
    [_ground.physicsBody setCategoryBitMask:kGroundCategory];
    [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
    [_ground.physicsBody setAffectedByGravity:NO];
    [_ground.physicsBody setDynamic:NO];

    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    [_scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height-50)];
    [_scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_score]]];
    [self addChild:_scoreLabel];

    [self setupPlayer];

    _pipeTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(addObstacle) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(startScoreTimer) userInfo:nil repeats:NO];
      
    _pipeSound = [SKAction playSoundFileNamed:@"pipe.mp3" waitForCompletion:NO];
    _punchSound = [SKAction playSoundFileNamed:@"punch3.mp3" waitForCompletion:NO];
  }
  return self;
}

- (void)setupPlayer
{
  _player = [Player spriteNodeWithImageNamed:@"Bird"];
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
  CGFloat pipeBottomHeight = (self.size.height - kGroundHeight) - (centerY + (kPipeGap/2));

  // Top Pipe
  Pipe *pipeTop = [Pipe pipeWithHeight:pipeTopHeight withStyle:PipeStyleTop];
  [pipeTop setPipeCategory:kPipeCategory playerCategory:kPlayerCategory];
  [self addChild:pipeTop];

  // Bottom Pipe
  Pipe *pipeBottom = [Pipe pipeWithHeight:pipeBottomHeight withStyle:PipeStyleBottom];
  [pipeBottom setPipeCategory:kPipeCategory playerCategory:kPlayerCategory];
  [self addChild:pipeBottom];

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
  _scoreTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}

- (void)incrementScore
{
  _score++;
  [_scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_score]]];
  [self runAction:_pipeSound];
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

  CGFloat rotation = ((_player.physicsBody.velocity.dy + kMaxVelocity) / (2*kMaxVelocity)) * M_2_PI;
  [_player setZRotation:rotation-M_1_PI/2];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
  SKNode *node = contact.bodyA.node;
  if ([node isKindOfClass:[Player class]]) {
    [_pipeTimer invalidate];
    [_scoreTimer invalidate];
    [self runAction:_punchSound completion:^{
      SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:.4];
      NewGameScene *newGame = [[NewGameScene alloc] initWithSize:self.size];
      [self.scene.view presentScene:newGame transition:transition];
    }];
  }
}

@end

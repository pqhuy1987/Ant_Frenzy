//
//  MyScene.h
//  Ants
//

//  Copyright (c) 2013 Third Boot. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import "LevelOverScene.h"
#import "Level.h"
#import "User.h"

@interface MyScene : SKScene

-(void)loadLevel:(int)levelNumber;

-(void)loadUser;

-(void)switch_weapon:(int)newWeaponMode;

-(CGPoint)pickRandomPoint:(SKSpriteNode*)ant;

-(CGPoint)pickPointTowardsBasket:(SKSpriteNode*)ant;

//-(void)reportScore:(int*)highScore;

-(void)endGame;

-(void)stopMusic;
-(void)startMusic;



@property int currentScore;
@property int levelNumber;
@property User *userData;
@property Level *current_level;

@end

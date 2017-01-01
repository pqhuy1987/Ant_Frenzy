//
//  ViewController.h
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "StoreViewController.h"
#import "LevelSelectViewController.h"
#import <GameKit/GameKit.h>
#import "User.h"

@interface ViewController : UIViewController <GKGameCenterControllerDelegate>


-(IBAction)openScores;

-(void)reportScore:(int)newScore;

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

-(void)removeChild:(UIViewController *) child;

-(void)saveUserData;

-(void)loadUserData;

-(void)updateUserDataFromStore;




@property (nonatomic) int score;
@property (nonatomic) User* userData;
@property (nonatomic) UIImageView *titleImage;

@end

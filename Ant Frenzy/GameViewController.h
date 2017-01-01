//
//  GameViewController.h
//  Ants
//
//  Created by Me on 2/8/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "ViewController.h"
#import "User.h"
#import "weapon.h"
#import "WeaponsPageContentViewController.h"
#import "LevelOverViewController.h"



@interface GameViewController : UIViewController <UIPageViewControllerDataSource>
{
    IBOutlet UILabel *gameOverLabel;
    IBOutlet UIButton *playAgainButton;
    IBOutlet UIButton *returnToMenuButton;
    IBOutlet UIButton *musicMute;
    
}


-(IBAction)switchWeapon:(id)sender;


-(IBAction)playAgain;

-(void)gameOver;
-(void)reportScore;

@property (nonatomic) int currentScore;
@property (nonatomic) int level;
@property (nonatomic) User* userData;

//Weapons Page Controller Stuff
@property (strong, nonatomic) UIPageViewController *weaponsPageViewController;
@property (nonatomic, strong) NSMutableArray *weapons;

@property (nonatomic) LevelOverViewController *levelOverViewController;

@end

//
//  LevelSelectPageContentViewController.h
//  Ant Frenzy
//
//  Created by Blaine Kelley on 3/4/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level.h"
#import "User.h"
#import "GameViewController.h"

@interface LevelSelectPageContentViewController : UIViewController
{
    IBOutlet UIButton *levelButton_1;
    IBOutlet UIButton *levelButton_2;
    IBOutlet UIButton *levelButton_3;
    IBOutlet UIButton *levelButton_4;
    IBOutlet UIButton *levelButton_5;
    
    IBOutlet UIImageView *levelNumber_1A;
    IBOutlet UIImageView *levelNumber_1B;
    IBOutlet UIImageView *levelNumber_2A;
    IBOutlet UIImageView *levelNumber_2B;
    IBOutlet UIImageView *levelNumber_3A;
    IBOutlet UIImageView *levelNumber_3B;
    IBOutlet UIImageView *levelNumber_4A;
    IBOutlet UIImageView *levelNumber_4B;
    IBOutlet UIImageView *levelNumber_5A;
    IBOutlet UIImageView *levelNumber_5B;
}

@property NSUInteger pageIndex;
@property NSInteger level_1_tag;
@property NSInteger level_2_tag;
@property NSInteger level_3_tag;
@property NSInteger level_4_tag;
@property NSInteger level_5_tag;

@property Level *level1;
@property Level *level2;
@property Level *level3;
@property Level *level4;
@property Level *level5;

@property (weak, nonatomic) NSArray *levels;

@property (nonatomic) User* userData;

-(IBAction)playLevel:(id)sender;

-(void)updateButtons;

@end

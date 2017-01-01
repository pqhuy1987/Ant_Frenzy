//
//  LevelOverViewController.h
//  Ant Frenzy
//
//  Created by Blaine Kelley on 9/4/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelOverViewController : UIViewController
{
    IBOutlet UIButton *continue_button;
    IBOutlet UIButton *play_again_button;
    IBOutlet UIButton *level_select_button;
    IBOutlet UIButton *main_menu_button;
}

@property (nonatomic) int starsEarned;
@property (nonatomic) int oneStarScore;
@property (nonatomic) int twoStarScore;
@property (nonatomic) int threeStarScore;
@property (nonatomic) int actualScore;


-(IBAction)_main_menu;
-(IBAction)_continue;
-(IBAction)_level_select;
-(IBAction)_play_again;

@end

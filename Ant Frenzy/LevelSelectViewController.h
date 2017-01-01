//
//  LevelSelectViewController.h
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "User.h"
#import "LevelSelectPageContentViewController.h"


@interface LevelSelectViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (nonatomic) int lastLevel;
@property (nonatomic) User* userData;

@property (nonatomic) NSMutableArray *levelPages;


-(IBAction)returnToMenu:(id)sender;


-(void)loadLevelProgress;
-(void)reportScore:(int)newScore;



@property (nonatomic, strong) UIPageViewController *levelPageViewController;
@property (strong, nonatomic) NSArray *levelSets;


@end

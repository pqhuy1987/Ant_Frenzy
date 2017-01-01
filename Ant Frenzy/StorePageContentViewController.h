//
//  StorePageContentViewController.h
//  Ant Frenzy
//
//  Created by Me on 3/1/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weapon.h"
#import "User.h"

@interface StorePageContentViewController : UIViewController


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@property weapon *weapon;
@property User *userData;

@property (weak, nonatomic) IBOutlet UIButton *buy1;
@property (weak, nonatomic) IBOutlet UIButton *buy2;
@property (weak, nonatomic) IBOutlet UIButton *buy3;
@property (weak, nonatomic) IBOutlet UIButton *buy4;
@property (weak, nonatomic) IBOutlet UIButton *buy5;

@property (weak, nonatomic) IBOutlet UILabel *level1Cost;
@property (weak, nonatomic) IBOutlet UILabel *level2Cost;
@property (weak, nonatomic) IBOutlet UILabel *level3Cost;
@property (weak, nonatomic) IBOutlet UILabel *level4Cost;
@property (weak, nonatomic) IBOutlet UILabel *level5Cost;

@property (weak, nonatomic) IBOutlet UIImageView *weaponPicture;
//@property (weak, nonatomic) IBOutlet UILabel *weaponTitle;
@property (weak, nonatomic) IBOutlet UILabel *weaponLevel;


@end

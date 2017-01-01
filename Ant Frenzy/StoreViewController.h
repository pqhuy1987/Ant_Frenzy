//
//  StoreViewController.h
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ViewController.h"
#import "User.h"
#import "weapon.h"
#import "StorePageContentViewController.h"

@interface StoreViewController : UIViewController <ADBannerViewDelegate, UIPageViewControllerDataSource>
{
//    ADBannerView *_bannerView;
    IBOutlet UILabel *cashAvailable;
    IBOutlet UIImageView *coin;
}


@property (nonatomic) User *userData;
//@property (nonatomic) int currentWeapon;

@property (nonatomic, retain) IBOutlet ADBannerView *_bannerView;



//Page controller stuff
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *weapons;


-(IBAction)returnToMenu;

@end

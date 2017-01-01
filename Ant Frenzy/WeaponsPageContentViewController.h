//
//  WeaponsPageContentViewController.h
//  Ant Frenzy
//
//  Created by Blaine Kelley on 3/3/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeaponsPageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSUInteger tag;
@property NSString *buttonText;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;


-(IBAction)buttonPressed:(id)sender;

@end

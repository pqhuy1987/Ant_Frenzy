//
//  WeaponsPageContentViewController.m
//  Ant Frenzy
//
//  Created by Blaine Kelley on 3/3/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "WeaponsPageContentViewController.h"

@interface WeaponsPageContentViewController ()

@end

@implementation WeaponsPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.button setTitle:self.buttonText forState:UIControlStateNormal];
    [self.button setTag:self.tag];
    [self buttonPressed:self.button];
    
    NSString *buttonImage = [NSString stringWithFormat:@"%@Icon.png", self.buttonText];
    NSLog(@"Added Image: %@", buttonImage);
    [self.button setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    
    [self buttonPressed:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(IBAction)buttonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"weaponChange" object:sender userInfo:nil];
}

@end

//
//  StorePageContentViewController.m
//  Ant Frenzy
//
//  Created by Me on 3/1/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "StorePageContentViewController.h"

@interface StorePageContentViewController ()

@end

@implementation StorePageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"page Index: %d", _pageIndex);
 
    [self refresh];
    
}


-(void)refresh
{
    self.weaponPicture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon.png", _weapon.name]];
    //self.weaponTitle.text = _weapon.name;
    self.weaponLevel.text = [NSString stringWithFormat:@"Level: %d", _weapon.level];
    
    //Only show the price of the next available level
    
    switch (_weapon.level) {
        case 0:
            //Buttons
            _buy1.enabled = YES;
            _buy2.enabled = NO;
            _buy3.enabled = NO;
            _buy4.enabled = NO;
            _buy5.enabled = NO;
            _level1Cost.text = [NSString stringWithFormat:@"%d", _weapon.level_1_cost];
            _level2Cost.text = [NSString stringWithFormat:@" ??? "];
            _level3Cost.text = [NSString stringWithFormat:@" ??? "];
            _level4Cost.text = [NSString stringWithFormat:@" ??? "];
            _level5Cost.text = [NSString stringWithFormat:@" ??? "];
            break;
            
        case 1:
            //Buttons
            _buy1.enabled = NO;
            _buy2.enabled = YES;
            _buy3.enabled = NO;
            _buy4.enabled = NO;
            _buy5.enabled = NO;
            _level1Cost.text = [NSString stringWithFormat:@" - - "];
            _level2Cost.text = [NSString stringWithFormat:@"%d", _weapon.level_2_cost];
            _level3Cost.text = [NSString stringWithFormat:@" ??? "];
            _level4Cost.text = [NSString stringWithFormat:@" ??? "];
            _level5Cost.text = [NSString stringWithFormat:@" ??? "];
            break;
            
        case 2:
            //Buttons
            _buy1.enabled = NO;
            _buy2.enabled = NO;
            _buy3.enabled = YES;
            _buy4.enabled = NO;
            _buy5.enabled = NO;
            _level1Cost.text = [NSString stringWithFormat:@" - - "];
            _level2Cost.text = [NSString stringWithFormat:@" - - "];
            _level3Cost.text = [NSString stringWithFormat:@"%d", _weapon.level_3_cost];
            _level4Cost.text = [NSString stringWithFormat:@" ??? "];
            _level5Cost.text = [NSString stringWithFormat:@" ??? "];
            
            break;
            
        case 3:
            //Buttons
            _buy1.enabled = NO;
            _buy2.enabled = NO;
            _buy3.enabled = NO;
            _buy4.enabled = YES;
            _buy5.enabled = NO;
            _level1Cost.text = [NSString stringWithFormat:@" - - "];
            _level2Cost.text = [NSString stringWithFormat:@" - - "];
            _level3Cost.text = [NSString stringWithFormat:@" - - "];
            _level4Cost.text = [NSString stringWithFormat:@"%d", _weapon.level_4_cost];
            _level5Cost.text = [NSString stringWithFormat:@" ??? "];
            break;
            
        case 4:
            //Buttons
            _buy1.enabled = NO;
            _buy2.enabled = NO;
            _buy3.enabled = NO;
            _buy4.enabled = NO;
            _buy5.enabled = YES;
            _level1Cost.text = [NSString stringWithFormat:@" - - "];
            _level2Cost.text = [NSString stringWithFormat:@" - - "];
            _level3Cost.text = [NSString stringWithFormat:@" - - "];
            _level4Cost.text = [NSString stringWithFormat:@" - - "];
            _level5Cost.text = [NSString stringWithFormat:@"%d", _weapon.level_5_cost];
            break;
            
        case 5:
            //Buttons
            _buy1.enabled = NO;
            _buy2.enabled = NO;
            _buy3.enabled = NO;
            _buy4.enabled = NO;
            _buy5.enabled = NO;
            _level1Cost.text = [NSString stringWithFormat:@" - - "];
            _level2Cost.text = [NSString stringWithFormat:@" - - "];
            _level3Cost.text = [NSString stringWithFormat:@" - - "];
            _level4Cost.text = [NSString stringWithFormat:@" - - "];
            _level5Cost.text = [NSString stringWithFormat:@" - - "];
            break;
            
            
        default:
            break;
    }
}


-(IBAction)purchaseUpgrade:(id)sender
{
    //Will bring up an "Are you sure?" window later
    
    //If cost is higher than available cash, do not sell
    int cost = 0;
    switch ([sender tag]) {
        case 1:
            cost = _weapon.level_1_cost;
            break;
        case 2:
            cost = _weapon.level_2_cost;
            break;
        case 3:
            cost = _weapon.level_3_cost;
            break;
        case 4:
            cost = _weapon.level_4_cost;
            break;
        case 5:
            cost = _weapon.level_5_cost;
            break;
        default:
            break;
    }
    
    NSLog(@"User Cash: %d", _userData.cash);
    NSLog(@"Cost: %d", cost);
    if (_userData.cash >= cost) {
        NSLog(@"Unlocked level %ld", (long)[sender tag]);
        _userData.cash -= cost;
        NSLog(@"Weapon Level: %d", _weapon.level);
        if (_weapon.level < 5)
            _weapon.level++;
        if (_weapon.level >= 1)
            _weapon.unlocked = YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserBoughtUpgrade" object:nil];
        
        [self refresh];
    }
    
    else
        NSLog(@"Not enough cash to buy that!");
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

@end

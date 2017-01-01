//
//  LevelSelectPageContentViewController.m
//  Ant Frenzy
//
//  Created by Blaine Kelley on 3/4/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "LevelSelectPageContentViewController.h"

@interface LevelSelectPageContentViewController ()

@end

@implementation LevelSelectPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"New page");
    [self updateButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)playLevel:(id)sender
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"playLevel" object:sender userInfo:nil];
}

-(void)updateButtons
{
    [levelButton_1 setTag:_level1.levelNumber];
    [levelButton_2 setTag:_level2.levelNumber];
    [levelButton_3 setTag:_level3.levelNumber];
    [levelButton_4 setTag:_level4.levelNumber];
    [levelButton_5 setTag:_level5.levelNumber];
    
    NSLog(@"PageIndex = %lu", (unsigned long)_pageIndex);

    
    Level* tempLevel;
    for (int i=1; i<=5; i++) {
        //NSLog(@"i = %d", i);
        switch (i) {
            case 1:
                NSLog(@"tempLevel: %d", (levelButton_1.tag - 1));
                tempLevel = _level1;
                
                NSLog(@"Derp");
                
                if (tempLevel.unlocked) {
                    //[levelButton_1 setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton_1.tag] forState:UIControlStateNormal];
                    
                    //set the numbers
                    int numA = tempLevel.levelNumber/10;
                    int numB = tempLevel.levelNumber%10;
                    NSLog(@"numA: %d", numA);
                    NSLog(@"numB: %d", numB);
                    
                    //[levelNumber_1A setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", numA]]];
                    //[levelNumber_1B setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", numB]]];
                    
                    levelNumber_1A.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", numA]];
                    levelNumber_1B.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", numB]];
                    
                    
                    NSLog(@"Level 1 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [levelButton_1 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [levelButton_1 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [levelButton_1 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars"] forState:UIControlStateNormal];
                            break;
                        default:
                            [levelButton_1 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    levelButton_1.enabled = YES;
                }
                else{
                    [levelButton_1 setTitle:@"Locked" forState:UIControlStateNormal];
                    levelButton_1.enabled = NO;
                }
                break;
            case 2:
                tempLevel = _level2;
                NSLog(@"tempLevel: %d", (levelButton_2.tag - 1));
                if (tempLevel.unlocked) {
                    [levelButton_2 setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton_2.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 2 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [levelButton_2 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [levelButton_2 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [levelButton_2 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [levelButton_2 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    levelButton_2.enabled = YES;
                }
                else{
                    [levelButton_2 setTitle:@"Locked" forState:UIControlStateNormal];
                    levelButton_2.enabled = NO;
                }
                break;
            case 3:
                tempLevel = _level3;
                //NSLog(@"tempLevel: %d", (level3.tag - 1));
                if (tempLevel.unlocked) {
                    [levelButton_3 setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton_3.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 3 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [levelButton_3 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [levelButton_3 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [levelButton_3 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [levelButton_3 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    levelButton_3.enabled = YES;
                }
                else{
                    [levelButton_3 setTitle:@"Locked" forState:UIControlStateNormal];
                    levelButton_3.enabled = NO;
                }
                break;
            case 4:
                tempLevel = _level4;
                //NSLog(@"tempLevel: %d", (level4.tag - 1));
                if (tempLevel.unlocked) {
                    [levelButton_4 setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton_4.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 4 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [levelButton_4 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [levelButton_4 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [levelButton_4 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [levelButton_4 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    levelButton_4.enabled = YES;
                }
                else{
                    [levelButton_4 setTitle:@"Locked" forState:UIControlStateNormal];
                    levelButton_4.enabled = NO;
                }
                break;
            case 5:
                tempLevel = _level5;
                //NSLog(@"tempLevel: %d", (level5.tag - 1));
                if (tempLevel.unlocked) {
                    [levelButton_5 setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton_5.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 5 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [levelButton_5 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [levelButton_5 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [levelButton_5 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [levelButton_5 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    levelButton_5.enabled = YES;
                }
                else{
                    [levelButton_5 setTitle:@"Locked" forState:UIControlStateNormal];
                    levelButton_5.enabled = NO;
                }
                break;
                
            default:
                break;
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger level = [sender tag];
    NSLog(@"preparing for level: %li", (long)level);
    GameViewController *game = (GameViewController*)[segue destinationViewController];
    game.level = (int)level;
    game.userData = _userData;
}


@end

//
//  User.m
//  Kill the Ants
//
//  Created by Me on 9/20/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import "User.h"

@implementation User


-(id)init
{
    NSLog(@"User init called");
    _cash = 0;
    _highScore = 0;
    _totalScore = 0;
    
    _weapons = [[NSMutableArray alloc] init];
    
    for (int i=0; i<6; i++) {
        weapon *temp = [[weapon alloc] init];
        temp.weaponMode = i;
        temp.level = 1;
        if (i == 0) {
            temp.unlocked = YES;
        }
        else
            temp.unlocked = NO;
        
        switch (i) {
            case 0:
                temp.name = @"Tap";
                temp.level = 1;
                temp.unlocked = YES;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            case 1:
                temp.name = @"Fireballs";
                temp.level = 1;
                temp.unlocked = NO;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            case 2:
                temp.name = @"Bug Spray";
                temp.level = 1;
                temp.unlocked = NO;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            case 3:
                temp.name = @"Zapper";
                temp.level = 1;
                temp.unlocked = NO;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            case 4:
                temp.name = @"Turret";
                temp.level = 1;
                temp.unlocked = NO;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            case 5:
                temp.name = @"Bomb";
                temp.level = 1;
                temp.unlocked = NO;
                temp.level_1_cost = 0;
                temp.level_2_cost = 0;
                temp.level_3_cost = 0;
                temp.level_4_cost = 0;
                temp.level_5_cost = 0;
                break;
            default:
                break;
        }
        
        [_weapons addObject:temp];
        
        
        NSLog(@"weapon %d : %@", i, temp.name);
        
    }
    
    
    
    return self;
}



-(void)addToTotal:(int)newScore
{
    NSLog(@"addToTotal called");
    NSLog(@"newScore value passed = %d", newScore);
    _totalScore = _totalScore + newScore;
    
    NSLog(@"New totalScore should be = %d", _totalScore);
}


-(BOOL)checkIfEnoughLives{
    if (_currentLives >= 0) {
        return YES;
    }
    return NO;
}

-(void)setRegenDate{
    _resetDate = NSTimeIntervalSince1970;
    _resetDate = _resetDate + _regenDelay;
}


-(void)checkIfRegenDate{
    if (_resetDate <= NSTimeIntervalSince1970) {
        //Time has passed, reset lives
        [self resetLives];
        return;
    }
}

-(void)resetLives{
    _currentLives = _MaxLives;
    _currentHearts = _maxHearts;
}

-(void)addOneLife{
    if (_currentLives < _MaxLives) {
        _currentLives++;
    }
}


-(void)addPointsToRegenCount:(int)points
{
    if (_addPointsToRegenCount) {
        _pointRegenCount += points;
    }
}


@end

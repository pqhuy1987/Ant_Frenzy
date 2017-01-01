//
//  weapon.h
//  Kill the Ants
//
//  Created by Me on 10/22/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weapon : NSObject

//set properties of weapon class
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL unlocked;
@property (nonatomic) int level;
@property (nonatomic) NSUInteger tag;

@property (nonatomic) int level_1_cost;
@property (nonatomic) int level_2_cost;
@property (nonatomic) int level_3_cost;
@property (nonatomic) int level_4_cost;
@property (nonatomic) int level_5_cost;

@property (nonatomic) int weaponMode;

@end

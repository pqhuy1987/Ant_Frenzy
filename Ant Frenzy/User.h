//
//  User.h
//  Kill the Ants
//
//  Created by Me on 9/20/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weapon.h"

@interface User : NSObject


@property (nonatomic)int highScore;
@property (nonatomic)int totalScore;
@property (nonatomic)int cash;
@property (nonatomic)int lastLevel;
@property (nonatomic)int currentLives;
@property (nonatomic)int currentHearts;
@property (nonatomic)int maxHearts;
@property (nonatomic)int MaxLives;
@property (nonatomic)int regenDelay;
@property (nonatomic)int pointRegenCount;
@property (nonatomic)BOOL addPointsToRegenCount;
@property (nonatomic)int resetDate;
@property (nonatomic)int timeToResetLives;

@property NSMutableArray *weapons;

//weapon variables

//tap
@property (nonatomic) int tap_hit_area_radius;
@property (nonatomic) int tap_stun_area_radius;
@property (nonatomic) int tap_damage;
@property (nonatomic) BOOL tap_shoots_fireballs;



//fireballs
@property (nonatomic) NSTimeInterval fireballs_shot_delay;
@property (nonatomic) int fireballs_burst;
@property (nonatomic) BOOL fireballs_shoot_in_burst;
@property (nonatomic) BOOL fireballs_shoot_in_spread;
@property (nonatomic) int fireball_damage;


//Zapper
@property (nonatomic) int zapper_damage;
@property (nonatomic) BOOL zapper_arcs;
@property (nonatomic) int zapper_chain_length;
@property (nonatomic) int zapper_arc_length;
@property (nonatomic) int zapper_num_chains;

//Bug Spray
@property (nonatomic) BOOL sprayRegenDelay;
@property (nonatomic) int bugSprayFull;
@property (nonatomic) int bugSprayInCan;
@property (nonatomic) int bugSpray_area_radius;
@property (nonatomic) int bugSpray_regen_rate;

//Sentry
@property (nonatomic) NSTimeInterval sentry_shot_delay;
@property (nonatomic) int sentry_area_radius;
@property (nonatomic) BOOL sentry_shoots_burst;
@property (nonatomic) BOOL sentry_shoots_spread;
//@property (nonatomic) BOOL sentry_shoots_rockets;

//target
@property (nonatomic) int basketHealth;
@property (nonatomic) BOOL target_has_shield;
@property (nonatomic) int target_shield_strength;
@property (nonatomic) NSTimeInterval target_shield_delay;
@property (nonatomic) NSTimeInterval target_shield_recharge_time;
@property (nonatomic) BOOL target_shield_regenerates;



-(BOOL)checkIfEnoughLives;

-(void)addToTotal:(int)newScore;
-(void)setRegenDate;
-(void)checkIfRegenDate;
-(void)resetLives;
-(void)addOneLife;
-(void)addPointsToRegenCount:(int)points;

@end

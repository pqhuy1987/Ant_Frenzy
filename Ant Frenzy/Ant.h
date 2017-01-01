//
//  Ant.h
//  Kill the Ants
//
//  Created by Me on 10/3/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ant : SKSpriteNode {
    //int health;
    //int ant_speed;
    //int ant_type;
    
    NSMutableArray *spriteTexture;
    
}

-(void)setHealth;

@property (nonatomic) int health;
@property (nonatomic) int ant_type;
@property (nonatomic) int ant_speed;
@property (nonatomic) BOOL isNew;

-(void)reduceHealthby:(int)damage;


@end

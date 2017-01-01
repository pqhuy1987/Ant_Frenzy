//
//  Ant.m
//  Kill the Ants
//
//  Created by Me on 10/3/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import "Ant.h"



@implementation Ant



-(void)setHealth
{
    _health = 1;
    //NSLog(@"New Ant, Health = %d", _health);
}

-(void)reduceHealthby:(int)damage
{
    if (_health >= damage)
        _health = (_health - damage);
    else
        _health = 0;
}

@end

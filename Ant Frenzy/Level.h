//
//  Level.h
//  Kill the Ants
//
//  Created by Me on 10/28/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject
{
    int antsToGenerate;
    NSString *backgroundName;
    int antLimit;
    int spawnSpeed;
    //bool unlocked;
    NSString *backgroundMusic;
    int basicAntLimit;
    int fastAntLimit;
    int armoredAntLimit;
    int moneyBagAntLimit;
    
    int oneStarScore;
    int twoStarScore;
    int threeStarScore;
}


@property int levelNumber;
@property BOOL unlocked;
@property int starsEarned;



@end

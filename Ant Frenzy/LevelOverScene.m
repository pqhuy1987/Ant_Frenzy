//
//  LevelOverScene.m
//  Ant Frenzy
//
//  Created by Me on 1/10/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "LevelOverScene.h"
#import "MyScene.h"

@implementation LevelOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won stars:(int)stars score:(int)score cash:(int)cash{
    if (self = [super initWithSize:size]) {
        
        NSLog(@"LevelOverScene initialized");
        
        self.size = size;
        
        //Sets background color to white
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // Depending on whether won = true or false, sets message
        NSString * message;
        if (won) {
            message = @"You Won!";
        }
        else{
            message = @"You Lose :[";
        }
        
        NSString *score_message = [NSString stringWithFormat:@"Score: %d", score];
        NSString *stars_message = [NSString stringWithFormat:@"Stars: %d", stars];
        NSString *cash_message = [NSString stringWithFormat:@"Cash Earned: %d", cash];
        
        
        //Creates and adds a label to the scene that displays message
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height*2/3);
        [self addChild:label];
        
        //Creates and adds a label to the scene that displays message
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = [NSString stringWithFormat:@"%@", score_message];
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(self.size.width/2, (label.position.y - (label.frame.size.height + scoreLabel.frame.size.height/2 + 20)));
        [self addChild:scoreLabel];
        
        
        //Creates and adds a label to the scene that displays message
        SKLabelNode *starsLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        starsLabel.text = [NSString stringWithFormat:@"%@", stars_message];
        starsLabel.fontSize = 20;
        starsLabel.fontColor = [SKColor blackColor];
        starsLabel.position = CGPointMake(self.size.width/2, (scoreLabel.position.y - (scoreLabel.frame.size.height + starsLabel.frame.size.height/2 + 20)));
        [self addChild:starsLabel];
        
        //Creates and adds a label to the scene that displays message
        SKLabelNode *cashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        cashLabel.text = [NSString stringWithFormat:@"%@", cash_message];
        cashLabel.fontSize = 20;
        cashLabel.fontColor = [SKColor blackColor];
        cashLabel.position = CGPointMake(self.size.width/2, (starsLabel.position.y - (starsLabel.frame.size.height + cashLabel.frame.size.height/2 + 20)));
        [self addChild:cashLabel];
        
        
        // Action sequence that waits 3 seconds, then runs the block of code that transitions the scene
        /*[self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:3.0],
                              [SKAction runBlock:^{
             // Creates new scene and transitions to it
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];*/
    }
    return self;
}

@end

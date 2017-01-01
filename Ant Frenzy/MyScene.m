//
//  MyScene.m
//  Ants
//
//  Created by Me on 12/20/13.
//  Copyright (c) 2013 Third Boot. All rights reserved.
//

#import "MyScene.h"
#import "GameViewController.h"
#import "ViewController.h"
#import "Ant.h"
#import "ZapArea.h"

@import AVFoundation;

//HUD
#define kScoreHudName @"scoreHud"
#define kHealthHudName @"healthHud"
#define ksprayCanHudName @"sprayCan"


@interface MyScene () <SKPhysicsContactDelegate>

//Level properties
@property (nonatomic) int weapon_mode;
@property (nonatomic) SKNode *world;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, strong) SKSpriteNode *selectedNode;
@property (nonatomic) SKSpriteNode *basket;
@property (nonatomic) int tileSize;
@property (nonatomic) int randomness;
@property (nonatomic) int antsSmashed;
@property (nonatomic) int score;



//Score combo items
@property (nonatomic) int combo;
@property (nonatomic) int lastCombo;
@property (nonatomic) NSTimeInterval comboTimeLimit;
@property (nonatomic) NSTimer *comboTimer;
@property (nonatomic) int multiplierLimit2;
@property (nonatomic) int multiplierLimit3;
@property (nonatomic) int multiplierLimit4;
@property (nonatomic) int multiplierLimit5;
@property (nonatomic) int scoreMultiplier;
//@property (nonatomic) int cashMultiplier;


@property (nonatomic) int ant_speed;


@property (nonatomic) BOOL isTouching;


@property (nonatomic) NSMutableArray* ants;
@property (nonatomic) NSMutableArray* antWalkingFrames;
@property (nonatomic) NSMutableArray* fastAntWalkingFrames;
@property (nonatomic) NSMutableArray* armoredAntWalkingFrames;
@property (nonatomic) NSMutableArray* moneyBagAntWalkingFrames;


@property (nonatomic) NSMutableArray* bombFrames;
@property (nonatomic) NSMutableArray* fireballFrames;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic) int allowedSentries;
@property (nonatomic) int deployedSentries;

@property (nonatomic) NSMutableArray* sprayFrames;
@property (nonatomic) NSMutableArray* zapperFrames;
@property (nonatomic) NSMutableArray* coinFrames;


@property (nonatomic) NSMutableArray* scoreNumbers;
@property (nonatomic) NSMutableArray* scoreImages;
@property (nonatomic) NSMutableArray* heartsArray;

//weapon variables

//@property (nonatomic) User *userData;

//tap
@property (nonatomic) int tap_hit_area_radius;
@property (nonatomic) int tap_does_stun;
@property (nonatomic) int tap_stun_area_radius;
@property (nonatomic) int tap_damage;
@property (nonatomic) BOOL tap_shoots_fireballs;


//fireballs
@property (nonatomic) NSTimeInterval fireballs_shot_delay;
@property (nonatomic) int fireballs_burst;
@property (nonatomic) BOOL fireballs_shoot_in_burst;
@property (nonatomic) BOOL fireballs_shoot_in_spread;
@property (nonatomic) int fireball_damage;

@property (nonatomic) CGPoint last_touchLocation;

//Zapper
@property (nonatomic) int zapper_damage;
@property (nonatomic) BOOL zapper_arcs;
@property (nonatomic) int zapper_chain_length;
@property (nonatomic) int zapper_radius;
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
@property (nonatomic) int hearts;
@property (nonatomic) BOOL target_has_shield;
@property (nonatomic) int target_shield_strength;
@property (nonatomic) NSTimeInterval target_shield_delay;
@property (nonatomic) NSTimeInterval target_shield_recharge_time;
@property (nonatomic) BOOL target_shield_regenerates;


//Level Completion Control
@property (nonatomic) int antsGenerated;
@property (nonatomic) BOOL shouldSpawnAnts;

// Level Specifics
@property (nonatomic) int numAntsToGenerate;
@property (nonatomic) NSString *backgroundName;
@property (nonatomic) int antsLimit;
@property (nonatomic) float generationTime;
@property (nonatomic) float baseGenerationTime;
@property (nonatomic) NSString *musicName;

//Ant type probalities
@property (nonatomic) int basicAntLimit;
@property (nonatomic) int fastAntLimit;
@property (nonatomic) int armoredAntLimit;
@property (nonatomic) int moneyBagAntLimit;

//Score Tiers
@property (nonatomic) int oneStarScore;
@property (nonatomic) int twoStarScore;
@property (nonatomic) int threeStarScore;


@end

@implementation MyScene

//Physics categories constants

static const uint32_t antCategory     = 0x1 << 0;
static const uint32_t basketCategory  = 0x1 << 1;
static const uint32_t fireballCategory = 0x1 << 2;
static const uint32_t bugSprayCategory = 0x1 << 3;
static const uint32_t sentryTrigger = 0x1 << 4;
static const uint32_t tap_Category = 0x1 << 5;
static const uint32_t tap_stun_Category = 0x1 << 6;
static const uint32_t explosion_category = 0x1 << 7;
static const uint32_t zap_Category = 0x1 << 8;
static const uint32_t coin_Category = 0x1 << 9;
static const uint32_t coinFall_Category = 0x1 << 11;

/*
static const uint32_t antCategory     = 0x0;
static const uint32_t basketCategory  = 0x1;
static const uint32_t fireballCategory = 0x2;
static const uint32_t bugSprayCategory = 0x3;
static const uint32_t sentryTrigger = 0x4;
static const uint32_t tap_Category = 0x5;
static const uint32_t tap_stun_Category = 0x6;
static const uint32_t explosion_category = 0x7;
static const uint32_t zap_Category = 0x8;
static const uint32_t coin_Category = 0x9;
static const uint32_t coinFall_Category = 0x11;
*/
int lastDeadAntsValue;



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]){
        /* Setup your scene here */

    
        self.tileSize = 25;
        
        if (!self.world){
            self.world = [SKNode node];
            
            //does this even matter?
            _antsSmashed = 0;
            
            self.ants = [[NSMutableArray alloc] init];
            self.physicsWorld.contactDelegate = self;
        
            [self setupScore];
            
        }}
    
    [self loadAnimationFrames];
    
    
    return self;
}


-(void)loadUser
{
    //variable that will be from ant object
    _ant_speed= 12.5;
    //-------------------------------------
    
    // Some of this will come from level plists
    
    _weapon_mode = 0;
    _randomness = 20;
    _hearts = self.userData.maxHearts;
    _isTouching = FALSE;
    lastDeadAntsValue = 0;
    _allowedSentries = 3;
    _deployedSentries = 0;
    _bugSprayFull = self.userData.bugSprayFull;
    _bugSprayInCan = _bugSprayFull;
    _shouldSpawnAnts = TRUE;
    _antsGenerated = 0;
    
    
    //Combo Timer Stuff
    _combo = 0;
    _comboTimeLimit = 2;
    _score = 0;
    _scoreMultiplier = 1;
    _multiplierLimit2 = 5;
    _multiplierLimit3 = 10;
    _multiplierLimit4 = 15;
    _multiplierLimit5 = 20;
    
    
    
    
    //Set up tap
    weapon *tempWeapon = self.userData.weapons[0];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //this level should not exist for tap, it is the default weapon
            //let fall through just in case
        case 1:
            //basic damage, no stun
            _tap_damage = 1;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_does_stun = NO;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 2:
            //add stun
            _tap_damage = 1;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 3:
            //increase damage
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 4:
            //Increase hit area and stun area
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = NO;
            break;
        case 5:
            //shoots fireballs, increase damage
            _tap_damage = 3;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = YES;
            break;
            
            
        default:
            break;
    }
    /*
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@"Tap Values");
    NSLog(@"------------------");
    NSLog(@"tap_damage : %d", _tap_damage);
    NSLog(@"tap_does_stun : %d", _tap_does_stun);
    NSLog(@"tap_stun_area_rad : %d", _tap_stun_area_radius);
    NSLog(@"tap_hit_area_rad : %d", _tap_hit_area_radius);
    NSLog(@"tap_shoots_fireballs : %d", _tap_shoots_fireballs);
    NSLog(@" ");
    NSLog(@" ");
    */
    
    
    
    //Set up fireballs
    tempWeapon = self.userData.weapons[1];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //fireballs should be locked if level is 0
            break;
        case 1:
            //basic fireball
            _fireball_damage = 1;
            _fireballs_shoot_in_burst = NO;
            _fireballs_shoot_in_spread = NO;
            _fireballs_burst = 1;
            _fireballs_shot_delay = 1.5;
            break;
        case 2:
            //reduce delay
            _fireball_damage = 1;
            _fireballs_shoot_in_burst = NO;
            _fireballs_shoot_in_spread = NO;
            _fireballs_burst = 1;
            _fireballs_shot_delay = 1;
            break;
        case 3:
            //increase damage, reduce delay further
            _fireball_damage = 2;
            _fireballs_shoot_in_burst = NO;
            _fireballs_shoot_in_spread = NO;
            _fireballs_burst = 1;
            _fireballs_shot_delay = 0.5;
            break;
        case 4:
            //allow burst
            _fireball_damage = 2;
            _fireballs_shoot_in_burst = YES;
            _fireballs_shoot_in_spread = NO;
            _fireballs_burst = 1;
            _fireballs_shot_delay = 0.5;
            break;
        case 5:
            //allow spread
            _fireball_damage = 2;
            _fireballs_shoot_in_burst = YES;
            _fireballs_shoot_in_spread = YES;
            _fireballs_burst = 1;
            _fireballs_shot_delay = 0.5;
            break;
            
        default:
            break;
    }
    
    
    NSLog(@"\n\nFireball damage: %d \nBurst: %d \nSpread: %d\nShotsInBurst: %d\nShotDelay: %f \n\n", _fireball_damage, _fireballs_shoot_in_burst, _fireballs_shoot_in_spread, _fireballs_burst, _fireballs_shot_delay);
    
    
    
    //set up bug spray
    tempWeapon = self.userData.weapons[2];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //this level should not exist for tap, it is the default weapon
            //let fall through just in case
        case 1:
            //basic damage, no stun
            _tap_damage = 1;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_does_stun = NO;
            _tap_shoots_fireballs = NO;
            break;
        case 2:
            //add stun
            _tap_damage = 1;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 3:
            //increase damage
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 4:
            //Increase hit area and stun area
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = NO;
            break;
        case 5:
            //shoots fireballs, increase damage
            _tap_damage = 3;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = YES;
            break;
            
            
        default:
            break;
    }
    
    
    
    //Set up zapper
    tempWeapon = self.userData.weapons[3];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //should be locked
            break;
        case 1:
            //basic zap
            _zapper_damage = self.userData.zapper_damage;
            _zapper_arcs = NO;
            _zapper_chain_length = 1;
            _zapper_num_chains = 1;
            _zapper_radius = self.userData.zapper_arc_length;
            break;
        case 2:
            //
            _zapper_damage = self.userData.zapper_damage;
            _zapper_arcs = YES;
            _zapper_chain_length = 3;
            _zapper_num_chains = 1;
            _zapper_radius = self.userData.zapper_arc_length*2;
            break;
        case 3:
            //
            _zapper_damage = self.userData.zapper_damage;
            _zapper_arcs = YES;
            _zapper_chain_length = 3;
            _zapper_num_chains = 3;
            _zapper_radius = self.userData.zapper_arc_length*2;
            break;
        case 4:
            //
            _zapper_damage = self.userData.zapper_damage;
            _zapper_arcs = YES;
            _zapper_chain_length = 5;
            _zapper_num_chains = 5;
            _zapper_radius = self.userData.zapper_arc_length*3;
            break;
        case 5:
            //
            _zapper_damage = self.userData.zapper_damage*3;
            _zapper_arcs = YES;
            _zapper_chain_length = 10;
            _zapper_num_chains = 10;
            _zapper_radius = self.userData.zapper_arc_length*5;
            break;
            
            
        default:
            break;
    }
    
    
    
    
    //set up sentry turret
    tempWeapon = self.userData.weapons[4];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //this level should not exist for tap, it is the default weapon
            //let fall through just in case
        case 1:
            //basic damage, no stun
            _tap_damage = 1;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_does_stun = NO;
            _tap_shoots_fireballs = NO;
            break;
        case 2:
            //add stun
            _tap_damage = 1;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 3:
            //increase damage
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 4:
            //Increase hit area and stun area
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = NO;
            break;
        case 5:
            //shoots fireballs, increase damage
            _tap_damage = 3;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = YES;
            break;
            
            
        default:
            break;
    }
    
    //set up bombs
    tempWeapon = self.userData.weapons[5];
    NSLog(@"\n\n Weapon: %@\nUnlocked: %d\nLevel: %d\n\n", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    switch (tempWeapon.level) {
        case 0:
            //this level should not exist for tap, it is the default weapon
            //let fall through just in case
        case 1:
            //basic damage, no stun
            _tap_damage = 1;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_does_stun = NO;
            _tap_shoots_fireballs = NO;
            break;
        case 2:
            //add stun
            _tap_damage = 1;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 3:
            //increase damage
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius;
            _tap_shoots_fireballs = NO;
            break;
        case 4:
            //Increase hit area and stun area
            _tap_damage = 2;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = NO;
            break;
        case 5:
            //shoots fireballs, increase damage
            _tap_damage = 3;
            _tap_does_stun = YES;
            _tap_stun_area_radius = self.userData.tap_stun_area_radius*1.5;
            _tap_hit_area_radius = self.userData.tap_hit_area_radius*1.5;
            _tap_shoots_fireballs = YES;
            break;
            
            
        default:
            break;
    }
    
    [self setupHearts];
    
}


-(void)loadAnimationFrames
{
    
    
    _antWalkingFrames = [[NSMutableArray alloc] init];
    _fastAntWalkingFrames = [[NSMutableArray alloc] init];
    _armoredAntWalkingFrames = [[NSMutableArray alloc] init];
    _moneyBagAntWalkingFrames = [[NSMutableArray alloc] init];
    
    //Set up array to hold frames
    //NSMutableArray *walkFrames = [NSMutableArray array];
    //load and set up texture atlas
    SKTextureAtlas *antAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Basic_Ant"];
    
    // Gather list of basic ant frames
    NSUInteger numImages = antAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"BasicAnt%d", i];
        SKTexture *temp = [antAnimatedAtlas textureNamed:textureName];
        [_antWalkingFrames addObject:temp];
    }
    //_antWalkingFrames = walkFrames;
    
    
    //set up FastAnt frames
    //NSMutableArray *fastWalkFrames = [NSMutableArray array];
    SKTextureAtlas *fastAntAnimatedAtlas = [SKTextureAtlas atlasNamed:@"FastAnt"];
    numImages = fastAntAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"FastAnt%d", i];
        SKTexture *temp = [fastAntAnimatedAtlas textureNamed:textureName];
        [_fastAntWalkingFrames addObject:temp];
    }
    //_fastAntWalkingFrames = fastWalkFrames;
    
    for (int i=1; i<=numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"FastAnt%d", i];
        SKTexture *temp = [fastAntAnimatedAtlas textureNamed:textureName];
        [_fastAntWalkingFrames addObject:temp];
    }
    
    
    //set up Armored Ant frames
    //NSMutableArray *armoredWalkFrames = [NSMutableArray array];
    SKTextureAtlas *armoredAntAnimatedAtlas = [SKTextureAtlas atlasNamed:@"ArmoredAnt"];
    numImages = armoredAntAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"ArmoredAnt%d", i];
        SKTexture *temp = [armoredAntAnimatedAtlas textureNamed:textureName];
        [_armoredAntWalkingFrames addObject:temp];
    }
    //_armoredAntWalkingFrames = armoredWalkFrames;
    
    
    //set up moneybag ant frames
    //NSMutableArray *moneyBagWalkFrames = [NSMutableArray array];
    SKTextureAtlas *moneyBagAntAnimatedAtlas = [SKTextureAtlas atlasNamed:@"MoneyAnt"];
    numImages = moneyBagAntAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"MoneyAnt%d", i];
        SKTexture *temp = [moneyBagAntAnimatedAtlas textureNamed:textureName];
        [_moneyBagAntWalkingFrames addObject:temp];
    }
    //_moneyBagAntWalkingFrames = moneyBagWalkFrames;
    
    
    //Set up array to hold frames
    NSMutableArray *sprayFrames = [NSMutableArray array];
    
    //load and set up texture atlas
    SKTextureAtlas *sprayAnimatedAtlas = [SKTextureAtlas atlasNamed:@"BugSpray"];
    
    // Gather list of frames
    numImages = sprayAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"BugSpray%d", i];
        SKTexture *temp = [sprayAnimatedAtlas textureNamed:textureName];
        [sprayFrames addObject:temp];
        //NSLog(@"%@ added to Frames", temp);
    }
    _sprayFrames = sprayFrames;
    [self setupSprayCanLabel];
    
    
    NSMutableArray *bombFrames = [NSMutableArray array];
    SKTextureAtlas *bombAnimatedAtlas = [SKTextureAtlas atlasNamed:@"bomb"];
    // Gather list of frames
    numImages = bombAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bomb%d", i];
        SKTexture *temp = [bombAnimatedAtlas textureNamed:textureName];
        [bombFrames addObject:temp];
        //NSLog(@"%@ added to Frames", temp);
    }
    _bombFrames = bombFrames;
    
    //Set up Fireball frames
    NSMutableArray *fireballFrames = [NSMutableArray array];
    SKTextureAtlas *fireballAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Fireball"];
    // Gather list of frames
    numImages = fireballAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Fireball%d", i];
        SKTexture *temp = [fireballAnimatedAtlas textureNamed:textureName];
        [fireballFrames addObject:temp];
        //NSLog(@"%@ added to Frames", temp);
    }
    _fireballFrames = fireballFrames;
    
    
    
    NSMutableArray *zapFrames = [NSMutableArray array];
    SKTextureAtlas *zapperAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Zapper"];
    NSLog(@"Attempting to load from atlas: ");
    NSLog(@"%@", zapperAnimatedAtlas);
    
    //Gather list of frames
    numImages = zapperAnimatedAtlas.textureNames.count;
    for(int i=0; i<numImages; i++){
        NSLog(@"Getting zapper # %d", i);
        NSString *textureName = [NSString stringWithFormat:@"Zapper%d", i];
        SKTexture *temp = [zapperAnimatedAtlas textureNamed:textureName];
        [zapFrames addObject:temp];
        NSLog(@"%@ added to Frames", temp);
    }
    _zapperFrames = zapFrames;
    
    
    
    
    NSMutableArray *coinFrames = [NSMutableArray array];
    SKTextureAtlas *coinAtlas = [SKTextureAtlas atlasNamed:@"Coin"];
    
    //Gather list of frames
    numImages = coinAtlas.textureNames.count;
    for(int i=0; i<numImages; i++){
        NSString *textureName = [NSString stringWithFormat:@"Coin%d", i];
        SKTexture *temp = [coinAtlas textureNamed:textureName];
        [coinFrames addObject:temp];
    }
    _coinFrames = coinFrames;
    
    
}





-(void)loadLevel:(int)levelNumber
{
    _levelNumber = levelNumber;
    
    self.userData.fireballs_burst = 3;
    
    //Make level file name string
    NSString *levelName = [NSString stringWithFormat:@"Level%d", _levelNumber];
    NSLog(@"level number = %d", _levelNumber);
    //load data from plist
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Level%d.plist", _levelNumber]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
    }
    
    NSMutableDictionary *levelInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    //Add all of the level info to MyScene
    
    //_backgroundName = [levelInfo objectForKey:@"BackgroundName"];
    
    //Just to test
    _backgroundName = @"Background2Ground";
    
    
    
    _antsLimit = [[levelInfo objectForKey:@"AntLimit"] intValue];
    _baseGenerationTime = [[levelInfo objectForKey:@"SpawnSpeed"] floatValue];
    _musicName = [levelInfo objectForKey:@"BackgroundMusic"];
    
    _numAntsToGenerate = [[levelInfo objectForKey:@"AntsToGenerate"] intValue];
    _basicAntLimit = [[levelInfo objectForKey:@"BasicAntLimit"] intValue];
    _fastAntLimit = [[levelInfo objectForKey:@"FastAntLimit"] intValue];
    _armoredAntLimit = [[levelInfo objectForKey:@"ArmoredAntLimit"] intValue];
    _moneyBagAntLimit = [[levelInfo objectForKey:@"MoneyBagAntLimit"] intValue];
    
    _oneStarScore = [[levelInfo objectForKey:@"OneStarScore"] intValue];
    _twoStarScore = [[levelInfo objectForKey:@"TwoStarScore"] intValue];
    _threeStarScore = [[levelInfo objectForKey:@"ThreeStarScore"] intValue];
    
    self.userData.tap_damage = 3;
    
    _last_touchLocation = self.basket.position;
    
    _generationTime = 1.5*_baseGenerationTime;
    
    //NSLog(@"antsLimit = %d", _antsLimit);
    //NSLog(@"numAntsToGenerate = %d", _numAntsToGenerate);
    //NSLog(@"generationTime = %f", _generationTime);
    //NSLog(@"basicAntLimit = %d", _basicAntLimit);
    //NSLog(@"fastAntLimit = %d", _fastAntLimit);
    //NSLog(@"armoredAntLimit = %d", _armoredAntLimit);
    //NSLog(@"money Ant Limit = %d", _moneyBagAntLimit);
    NSLog(@"oneStarScore = %d", _oneStarScore);
    NSLog(@"twoStarScore = %d", _twoStarScore);
    NSLog(@"threeStarScore = %d", _threeStarScore);
    
    
    //SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:_backgroundName];
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"Background2Ground.png"];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.size = self.size;
    [self addChild:bgImage];
    
    /*
    //add top layer
    SKSpriteNode *bgTop = [SKSpriteNode spriteNodeWithImageNamed:@"Background1Top.png"];
    bgTop.position = bgImage.position;
    bgTop.size = self.size;
    bgTop.zPosition = 10;
    [self addChild:bgTop];
    */
    
    
    //Set up the music player
    //NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"AntsBackground" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.enableRate = YES;
    self.backgroundMusicPlayer.rate = 0.80f;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    
    
    //Basket/target stuff
    self.basket = [SKSpriteNode spriteNodeWithImageNamed:@"Sandwich"];
    //self.basket = [SKSpriteNode spriteNodeWithTexture:_fireballFrames[0]];
    self.basket.xScale = (self.frame.size.width/self.basket.size.width); //0.5
    self.basket.yScale = 0.01; //0.5

    
    self.basket.position = CGPointMake(self.frame.size.width/2, 0);
    self.basket.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.basket.size.width/2, self.basket.size.height/2)];
    self.basket.physicsBody.dynamic = NO;
    //self.basket.physicsBody.affectedByGravity = NO;
    self.basket.physicsBody.categoryBitMask = basketCategory;
    self.basket.physicsBody.contactTestBitMask = antCategory;
    self.basket.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:self.basket];
    
    self.physicsWorld.gravity = CGVectorMake(0, -1);
}





-(void)setupScore
{
    //NSLog(@"MyScene setupScore called");
    
    NSMutableArray *scoreNumbers = [NSMutableArray array];
    SKTextureAtlas *scoreNumbersAtlas = [SKTextureAtlas atlasNamed:@"Number"];
    int numImages = (int)scoreNumbersAtlas.textureNames.count;
    for (int i=0; i<numImages; i++) {
        //NSLog(@"getting number image: %d", i);
        NSString *textureName = [NSString stringWithFormat:@"Number%d", i];
        SKTexture *temp = [scoreNumbersAtlas textureNamed:textureName];
        //NSLog(@"texture: %@", temp);
        [scoreNumbers addObject:temp];
    }
    _scoreNumbers = scoreNumbers;
    
    //SKLabelNode* scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    SKSpriteNode *tempNode = [SKSpriteNode spriteNodeWithTexture:_scoreNumbers[0]];
    //tempNode.xScale = 0.5;
    //tempNode.yScale = 0.5;
    
    tempNode.xScale = self.xScale;
    tempNode.yScale = self.yScale;
    
    _scoreImages = [NSMutableArray array];
    //CGPoint placement = CGPointMake(30 + tempNode.frame.size.width/2, self.frame.size.height - (20 + tempNode.frame.size.height/2));
    CGPoint placement = CGPointMake((self.frame.size.width/2 - (1.5*tempNode.frame.size.width)), self.frame.size.height - tempNode.frame.size.height/2);
    //CGPoint placement = CGPointMake(0, 0);
    for (int i=0; i<4; i++) {
        SKSpriteNode *temp = [SKSpriteNode spriteNodeWithTexture:_scoreNumbers[0]];
        temp.zPosition = 100;
        temp.xScale = 0.5;
        temp.yScale = 0.5;
        temp.position = placement;
        //NSLog(@"node added at (%f, %f)", placement.x, placement.y);
        [self addChild:temp];
        [_scoreImages addObject:temp];
        placement = CGPointMake(placement.x + temp.frame.size.width, placement.y);
        
        
        //SKSpriteNode *tempNode = [_scoreImages objectAtIndex:i];
        //NSLog(@"actual position: %f , %f", tempNode.position.x, tempNode.position.y);
    }
}


-(void)setupSprayCanLabel
{
    //NSLog(@"MyScene setupScore called");
    
    SKLabelNode* sprayCanDisplay = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    // Give score label a name
    sprayCanDisplay.name = ksprayCanHudName;
    sprayCanDisplay.fontSize = 30;
    sprayCanDisplay.zPosition = 1;
    
    // Color label text
    sprayCanDisplay.fontColor = [SKColor greenColor];
    sprayCanDisplay.text = [NSString stringWithFormat:@"Score: %04u", 0];
    
    // Place label near bottom left
    sprayCanDisplay.position = CGPointMake(self.frame.size.width - (30 +sprayCanDisplay.frame.size.width/2), self.frame.size.height -(50 + sprayCanDisplay.frame.size.height/2));
    [self addChild:sprayCanDisplay];
    [self adjustSpraycan];
    
    
    //Add something here for GameView score
}



-(void)adjustScoreBy:(int)points {
    //NSLog(@"MyScene adjustScoreBy: called");
    self.antsSmashed += points;
    [self checkCombo];
    //NSLog(@"Score: %d", _score);
    
    //get the individual digits of score
    int ones_place = _score % 10;
    int tens_place = _score % 100;
    tens_place = floor(tens_place/10);
    
    int hundreds_place = _score % 1000;
    hundreds_place = floor(hundreds_place/100);
    
    int thousands_place = _score % 10000;
    thousands_place = floor(thousands_place/1000);
    
    //NSLog(@"Digits: %d %d %d %d", thousands_place, hundreds_place, tens_place, ones_place);
    
    //update _scoreImages
    int i=0;
    while (i<_scoreImages.count) {
        SKSpriteNode *tempNode = _scoreImages[i];
        switch (i) {
            case 0:
                tempNode.texture = _scoreNumbers[thousands_place];
                break;
            case 1:
                tempNode.texture = _scoreNumbers[hundreds_place];
                break;
            case 2:
                tempNode.texture = _scoreNumbers[tens_place];
                break;
            case 3:
                tempNode.texture = _scoreNumbers[ones_place];
                break;
                
            default:
                break;
        }
        i++;
    }
     
    
     
    
    /*
    SKLabelNode* score = (SKLabelNode*)[self childNodeWithName:kScoreHudName];
    score.text = [NSString stringWithFormat:@"Score: %04u", _score];
    */
    
    _currentScore = _score;
    [self updateScore];
}


-(void)adjustSpraycan
{
    SKLabelNode* sprayCan = (SKLabelNode*)[self childNodeWithName:ksprayCanHudName];
    
    if (_bugSprayInCan <= 0) {
        sprayCan.text = [NSString stringWithFormat:@"SprayCan: %04u", 0];
    }
    else {
        sprayCan.text = [NSString stringWithFormat:@"SprayCan: %04u", _bugSprayInCan];
    }
}

-(void)setupHearts
{
    //NSLog(@"MyScene setupScore called");
    _heartsArray = [[NSMutableArray alloc] init];
    SKSpriteNode *tempNode = [SKSpriteNode spriteNodeWithImageNamed:@"BadHeart"];
    tempNode.xScale = 0.2;
    tempNode.yScale = 0.2;
    CGPoint placement = CGPointMake(0+tempNode.frame.size.width, 0+tempNode.frame.size.height);
    for (int i=0; i<_hearts; i++) {
        SKSpriteNode *temp = [SKSpriteNode spriteNodeWithImageNamed:@"BadHeart"];
        temp.zPosition = 100;
        temp.xScale = 0.1;
        temp.yScale = 0.1;
        temp.position = placement;
        [self addChild:temp];
        [_heartsArray addObject:temp];
        placement = CGPointMake(placement.x + temp.frame.size.width, placement.y);
    }
}


-(void)adjustHearts{
    if (_hearts < [_heartsArray count]) {
        SKSpriteNode *lastNode = [_heartsArray lastObject];
        [lastNode removeFromParent];
        [_heartsArray removeLastObject];
    }
}
 
-(void)switch_weapon:(int)newWeaponMode {
    // sets weapon mode to the tag value of the button pressed
    _weapon_mode = newWeaponMode;
}



-(void)generateAnt
{
    //NSLog(@"MyScene generateAnt method called");
    
    //NSArray *_antWalkingFrames;
    
    SKTexture *temp = _antWalkingFrames[0];
    Ant *ant = [Ant spriteNodeWithTexture:temp];
    [ant setHealth];
    
    _antsGenerated++;
    if (_antsGenerated >= _numAntsToGenerate) {
        _shouldSpawnAnts = FALSE;
    }
    
    int temp_random = (arc4random() % 1000) + 1;
    //NSLog(@"temp_random = %i", temp_random);
    if (temp_random <= _basicAntLimit) {
        //set to basic ant
        ant.ant_type = 1;
        ant.ant_speed = _ant_speed;
        ant.xScale = 0.4;
        ant.yScale = 0.4;
    }
    else if ((temp_random > _basicAntLimit) && (temp_random <= _fastAntLimit)){
        //set to Fast ant
        ant.ant_type = 2;
        ant.ant_speed = _ant_speed*1.5;
        ant.xScale = 0.3;
        ant.yScale = 0.3;
    }
    else if ((temp_random > _fastAntLimit) && (temp_random <= _armoredAntLimit)){
        //set to Armored ants
        ant.ant_type = 3;
        ant.ant_speed = _ant_speed;
        ant.health = 5;
        ant.xScale = 0.8;
        ant.yScale = 0.8;
    }
    else if (temp_random < _moneyBagAntLimit){
        //set to moneybag ants
        ant.ant_type = 4;
        ant.ant_speed = _ant_speed/2;
        ant.xScale = 0.4;
        ant.yScale = 0.4;
    }
    else{
        ant.ant_type = 1;
        ant.ant_speed = _ant_speed;
        ant.xScale = 0.4;
        ant.yScale = 0.4;
    }
    
    
    //NSLog(@"ant_type set to: %i", ant.ant_type);
    
    
    //Create a physics body for the ant
    //ant.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ant.size.height/2];
    ant.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake((ant.size.width/3), ((ant.size.height*3)/4))];
    
    // Make movement controlled by physics but not gravity
    ant.physicsBody.dynamic = YES;
    ant.physicsBody.affectedByGravity = NO;
    
    // Set category bitmask to ant category
    ant.physicsBody.categoryBitMask = antCategory;
    
    // Determine which physics objects trigger the contact listener when touched
    ant.physicsBody.collisionBitMask = fireballCategory;
    ant.physicsBody.contactTestBitMask = basketCategory;
    ant.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    
    
    //int division_size= 10;
    int side = (arc4random() % 3) + 1;
    float spawnPoint;
    int quadrant;
    //int max_width = self.map.gridSize.width;
    int max_width = (self.frame.size.width)/_tileSize;
    //int max_height = self.map.gridSize.height;
    int max_height = (self.frame.size.height)/_tileSize;
    switch (side) {
        case 1:
            //spawnPoint = ((self.frame.size.width/division_size) * (arc4random()%division_size));
            spawnPoint = (1 + arc4random() % max_width)*self.tileSize;
            ant.position = CGPointMake(spawnPoint ,(self.frame.size.height /*-*/+ ant.size.height));
            
            //determine quadrant of ant
            if(ant.position.x >= self.basket.position.x){
                quadrant = 1;
            }
            else{
                quadrant = 2;
            }
            break;
        case 2:
            //spawnPoint = ((self.frame.size.height)/ division_size) * (arc4random()% division_size);
            spawnPoint = ((max_height/3) + arc4random() % max_height)*self.tileSize;
            ant.position = CGPointMake((self.frame.size.width /*-*/+ ant.size.height), spawnPoint);
            
            if(ant.position.y >= self.basket.position.y){
                quadrant = 1;
            }
            else{
                quadrant = 4;
            }
            break;

        case 3:
            //spawnPoint = ((self.frame.size.width)/division_size) * (arc4random()% division_size);
            spawnPoint = ((max_height/3) + arc4random() % max_height)*self.tileSize;
            ant.position = CGPointMake((0 /*+*/- ant.size.height), spawnPoint);
            
            if(ant.position.y >= self.basket.position.y){
                quadrant = 2;
            }
            else{
                quadrant = 3;
            }
            break;
    }
    
    
    [self addChild:ant];
    [_ants addObject:ant];
    //NSLog(@"Ants Generated = %d", _antsGenerated);
    //NSLog(@"Added ant at position: %f . %f", ant.position.x, ant.position.y);
    [self startAntWalkingAnimation:ant];
    [self animateAnt:ant];
    
    
}




// New ant movement stuff -------------------------------------------------------------------------------------------------
-(void)startAntWalkingAnimation:(Ant*)ant
{
    switch (ant.ant_type) {
        case 1:{
            //set to basic ant
            [ant runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: _antWalkingFrames
                                                                          timePerFrame:0.02f
                                                                                resize:NO
                                                                               restore:YES]] withKey:@"walkingAnt"];
            break;
        }
        case 2:{
            //set to fast ant
            [ant runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: _fastAntWalkingFrames
                                                                          timePerFrame:0.01f
                                                                                resize:NO
                                                                               restore:YES]] withKey:@"fastWalkingAnt"];
            break;
        }
        case 3:{
            //set to armored ant
            [ant runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: _armoredAntWalkingFrames
                                                                          timePerFrame:0.05f
                                                                                resize:NO
                                                                               restore:YES]] withKey:@"armoredWalkingAnt"];
            break;
        }
        case 4:{
            //set to moneyBag ant
            [ant runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: _moneyBagAntWalkingFrames
                                                                          timePerFrame:0.02f
                                                                                resize:NO
                                                                               restore:YES]] withKey:@"moneyBagWalkingAnt"];
            break;
        }
        default:
            break;
    }
}

// Move the ant towards basket
- (void) animateAnt:(Ant*)ant
{
    //NSLog(@"animateAnt called");
    
    //determine new destination
    CGPoint intendedPosition;
    if ([self shouldMoveRandomly]){
        intendedPosition = [self pickRandomPoint:ant];
    }
    else{
        intendedPosition = [self pickPointTowardsBasket:ant];
    }
    
    

    
    
    [self rotateAnt:ant towardsPosition:intendedPosition];
    SKAction * move = [SKAction moveTo:intendedPosition duration:_tileSize/(ant.ant_speed)];
    
    SKAction * moveDone = [SKAction runBlock:^{
        [self antMoveFinished:ant];
    }];

    [ant runAction:[SKAction sequence:@[move, moveDone]]];

    
}



//start another iteration of ant movement
-(void)antMoveFinished:(id)sender
{
    //NSLog(@"antMoveFinished called");
    
    [self animateAnt: sender];
}


-(CGPoint)pickRandomPoint:(Ant*)ant
{
    //NSLog(@"pickRandomPoint called");
    CGPoint intendedPosition;
    int direction = [self pickRandomDirection:ant];
    switch (direction) {
        case 1:
            intendedPosition = CGPointMake(ant.position.x, ant.position.y + self.tileSize);
            break;
        case 2:
            intendedPosition = CGPointMake(ant.position.x + self.tileSize, ant.position.y + self.tileSize);
            break;
        case 3:
            intendedPosition = CGPointMake(ant.position.x + self.tileSize, ant.position.y);
            break;
        case 4:
            intendedPosition = CGPointMake(ant.position.x + self.tileSize, ant.position.y - self.tileSize);
            break;
        case 5:
            intendedPosition = CGPointMake(ant.position.x, ant.position.y - self.tileSize);
            break;
        case 6:
            intendedPosition = CGPointMake(ant.position.x - self.tileSize, ant.position.y - self.tileSize);
            break;
        case 7:
            intendedPosition = CGPointMake(ant.position.x - self.tileSize, ant.position.y);
            break;
        case 8:
            intendedPosition = CGPointMake(ant.position.x - self.tileSize, ant.position.y + self.tileSize);
            break;
        default:
            break;
    }
    
    return intendedPosition;
}

-(CGPoint)pickPointTowardsBasket:(Ant*)ant
{
    //NSLog(@"pickPointTowardBasket called");
    CGPoint intendedPosition;
    int xDistance = (ant.position.y - self.basket.position.y)/8;
    
    // Select x coordinate
    if (ant.position.x > self.basket.position.x) {
        intendedPosition.x = ant.position.x - (self.tileSize + xDistance);
    }
    else if (ant.position.x < self.basket.position.x) {
        intendedPosition.x = ant.position.x + (self.tileSize + xDistance);
    }
    else if (ant.position.x == self.basket.position.x) {
        //intendedPosition.x = ant.position.x;
        intendedPosition.x = ant.position.x + (arc4random()%(2*xDistance))-(xDistance);
    }
    
    // Select y coordinate
    if (ant.position.y > self.basket.position.y) {
        intendedPosition.y = ant.position.y - (self.tileSize+xDistance);
    }
    else if (ant.position.y < self.basket.position.y) {
        intendedPosition.y = ant.position.y + (self.tileSize+xDistance);
    }
    else if (ant.position.y == self.basket.position.y) {
        intendedPosition.y = ant.position.y;
    }
    
    return intendedPosition;
    
}




//------------------------------------------------------------------------------------------------------------------------




// Added to Ant Class
-(BOOL)shouldMoveRandomly
{
    //NSLog(@"MyScene shouldMoveRandomly method called");
    int randomChance = arc4random()%100;
    
    if (randomChance > _randomness){
        return (FALSE);
    }
    else{
        return (TRUE);
    }
}



-(int)pickRandomDirection:(SKNode*)antCurrentTile{
    //NSLog(@"MyScene pickRandomDirection called");
    int direction = 0;
    BOOL movementPossible = FALSE;
    
    while (movementPossible == FALSE){
        //NSLog(@"began pickRandomDirection while loop");
        direction = (1 + arc4random()%(8));
        
        switch (direction) {
            case 1:
                // if tile above current tile is traversable
                movementPossible = TRUE;
                break;
            case 2:
                // if tile to the NW of current tile is traversable
                movementPossible = TRUE;
                break;
            case 3:
                // if tile to the West of current tile is traversable
                movementPossible = TRUE;
                break;
            case 4:
                // if tile to the SW current tile is traversable
                movementPossible = TRUE;
                break;
            case 5:
                // if tile to the South of current tile is traversable
                movementPossible = TRUE;
                break;
            case 6:
                // if tile to the SE current tile is traversable
                movementPossible = TRUE;
                break;
            case 7:
                // if tile to the East current tile is traversable
                movementPossible = TRUE;
            case 8:
                // if tile to the NE  current tile is traversable
                movementPossible = TRUE;
            default:
                break;
        }
    }
    //NSLog(@"direction = %i", direction);
    return direction;
}




-(void)rotateAnt:(Ant*)ant towardsPosition:(CGPoint)intendedPosition
{
    //NSLog(@"MyScene rotateAnt called");
    
    float rotationAngle = 0;
    int quadrant;
    
    if (ant.position.x >= intendedPosition.x) {
        if (ant.position.y >= intendedPosition.y) {
            quadrant = 1;
        }
        else{
            quadrant = 4;
        }
    }
    else{
        if (ant.position.y >= intendedPosition.y){
            quadrant = 2;
        }
        else{
            quadrant = 3;
        }
    }
    
    switch (quadrant) {
        case 1:
        {
            rotationAngle = (atan2f((ant.position.x - intendedPosition.x), (ant.position.y - intendedPosition.y))) * (-1);
            break;
        }
            
        case 2:
        {
            rotationAngle = atan2f((intendedPosition.x - ant.position.x), (ant.position.y - intendedPosition.y));
            rotationAngle = (2*M_PI) + rotationAngle;
            break;
        }
            
        case 3:
        {
            rotationAngle = atan2f((intendedPosition.x - ant.position.x), (intendedPosition.y - ant.position.y));
            rotationAngle = M_PI - rotationAngle;
            break;
        }
            
        case 4:
        {
            rotationAngle = atan2f((ant.position.x - intendedPosition.x), (intendedPosition.y - ant.position.y));
            rotationAngle = M_PI + rotationAngle;
            break;
        }
    }
    
    [ant runAction:[SKAction rotateToAngle:rotationAngle duration:(_tileSize/(10*_ant_speed))]];
    //return rotationAngle;
}






-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //NSLog(@"MyScene touchesBegan called");
    
    /* Called when a touch begins */
    _isTouching = TRUE;
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    [self selectNodeForTouch:positionInScene];
    
    
    switch (_weapon_mode){
        
        //Regular taps
        case 0:{
            
            //[self selectNodeForTouch:positionInScene];
            [self basicTap:positionInScene];
            break;
            }
            
        //Fireballs
        case 1: {
            
            [self shootFireballs:positionInScene];
            break;
            }
        
            
            // Bug Spray
        case 2: {
            [self sprayBugSpray:positionInScene];
            break;
        }
            
            
        // Bug Zapper
        case 3: {
            //stuff for zapping---------------------------This all needs it's own method!!!
            if (!self.paused) {
                
                NSLog(@"Zap called");
                NSLog(@"zapper_chain_length = %d", _zapper_chain_length);
                
                [self newZapArea:positionInScene arcLevel:_zapper_chain_length];
                //[self selectNodeForTouch:positionInScene];
                
                //add lightning bolt
                [self drawBolt:CGPointMake(self.size.width/2, self.size.height+20) toPoint:positionInScene];
                
                }
            break;
        }
        
        
            
        // Sentries
        case 4: {
            [self placeSentry:positionInScene];
            break;
        }
            
        case 5: {
            [self placeBomb:positionInScene];
            break;
        }
            
        default: {
            break;
            }
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"MyScene touchesMoved called");
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    if (_weapon_mode == 2) {
        [self sprayBugSpray:positionInScene];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"MyScene touchesEnded called");
    
    _isTouching = FALSE;
}


-(void)basicTap:(CGPoint)touchLocation
{
    //SKSpriteNode *tapArea = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    
    SKShapeNode *tapArea = [SKShapeNode shapeNodeWithCircleOfRadius:_tap_hit_area_radius/4];
    tapArea.fillColor = [SKColor blueColor];
    tapArea.strokeColor = [SKColor blackColor];
    tapArea.alpha = 0.3;
    tapArea.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_tap_hit_area_radius/4];
    tapArea.physicsBody.dynamic = NO;
    tapArea.physicsBody.usesPreciseCollisionDetection = YES;
    tapArea.physicsBody.categoryBitMask = tap_Category;
    //tapArea.physicsBody.collisionBitMask = antCategory;
    tapArea.physicsBody.contactTestBitMask = antCategory;
    tapArea.physicsBody.affectedByGravity = NO;
    
    tapArea.position = touchLocation;
    //SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *expand = [SKAction scaleTo:4 duration:0.1];
    [self addChild:tapArea];
    [tapArea runAction:[SKAction sequence:@[expand, [SKAction removeFromParent]]]];
   
    
    _tap_does_stun = YES;
    if (_tap_does_stun) {
        NSLog(@"Stun called");
        SKShapeNode *tapStunArea = [SKShapeNode shapeNodeWithCircleOfRadius:_tap_stun_area_radius/4];
        tapStunArea.fillColor = [SKColor clearColor];
        tapStunArea.strokeColor = [SKColor blackColor];
        tapStunArea.alpha = 0.3;
        tapStunArea.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_tap_stun_area_radius/4];
        tapStunArea.physicsBody.dynamic = NO;
        tapStunArea.physicsBody.categoryBitMask = tap_stun_Category;
        tapStunArea.physicsBody.usesPreciseCollisionDetection = YES;
        //tapStunArea.physicsBody.collisionBitMask = antCategory;
        tapStunArea.physicsBody.contactTestBitMask = antCategory;
        tapStunArea.physicsBody.affectedByGravity = NO;
        
        tapStunArea.position = touchLocation;
        //SKAction *wait_stun = [SKAction waitForDuration:0.5];
        SKAction *expand_stun = [SKAction scaleTo:4 duration:0.1];
        [self addChild:tapStunArea];
        [tapStunArea runAction:[SKAction sequence:@[expand_stun, [SKAction removeFromParent]]]];
    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation
{
    NSLog(@"MyScene selectNodeForTouch called");
    /*
    NSArray *nodesTouched = [self nodesAtPoint:touchLocation];
    if ([nodesTouched count]) {
        for (SKSpriteNode *touchedNode in nodesTouched) {
            _selectedNode = touchedNode;
     
            if(_selectedNode.physicsBody.categoryBitMask == antCategory){
                Ant *tempAnt = (Ant*)_selectedNode;
                [tempAnt reduceHealthby:self.userData.tap_damage];
                
             
                if (tempAnt.health == 0) {
                    
                    [_selectedNode removeAllActions];
                    [_ants removeObject:_selectedNode];
                    
                    if (([_ants count] < 1) && (_shouldSpawnAnts == FALSE)) {
                        NSLog(@"Level completed");
                        [self endGame];
                    }
                    
                    if (_weapon_mode == 0) {
                        [self generateSquish:_selectedNode.position];
                        [_selectedNode removeFromParent];
                    }
                    else if (_weapon_mode == 2) {
                        //NSLog(@"ant was zapped");
                        [self generateZappedAnt:_selectedNode.position];
                        [self newZapArea:_selectedNode.position arcLevel:_zapper_chain_length];
                        [_selectedNode removeFromParent];
                    }
                    //_antsSmashed++;
                    //[GameViewController incrementScoreBy:1];
                    [self adjustScoreBy:1];
                }
                break;
             
            }
            
            if(_selectedNode.physicsBody.categoryBitMask == coin_Category){
                self.userData.cash = self.userData.cash + 1;
                [_selectedNode removeFromParent];
                NSLog(@"Cash: %d", self.userData.cash);
            }
     
        }
    }
    */
    // asks scene for node that is on the position touchLocation
    //SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    
}

-(void)newZapArea:(CGPoint)position arcLevel:(int)arcLevel
{
    NSLog(@"\n\nNew Zap Area, level: %D\n", arcLevel);
    
    
    ZapArea *newZapArea = [ZapArea shapeNodeWithCircleOfRadius:_zapper_radius];
    newZapArea.fillColor = [SKColor clearColor];
    newZapArea.strokeColor = [SKColor clearColor];
    //newZapArea.alpha = 0.1;
    newZapArea.possibleArcs = _zapper_num_chains;
    newZapArea.arclevel = arcLevel;
    newZapArea.position = position;
    
    NSLog(@"arcLevel: %d", newZapArea.arclevel);
    NSLog(@"possibleArcs: %d", newZapArea.possibleArcs);
    
    SKAction *wait;
    
    //newZapArea.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    if (arcLevel == _zapper_chain_length){
        wait = [SKAction waitForDuration:0.1];
        newZapArea.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    }
    else{
        wait = [SKAction waitForDuration:1];
        newZapArea.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    }
    
    
    newZapArea.physicsBody.dynamic = YES;
    newZapArea.physicsBody.affectedByGravity = NO;
    newZapArea.physicsBody.categoryBitMask = zap_Category;
    newZapArea.physicsBody.contactTestBitMask = antCategory;
    newZapArea.physicsBody.collisionBitMask = 0;
    newZapArea.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    
    
    
    [self addChild:newZapArea];
    [newZapArea runAction:[SKAction sequence:@[wait, [SKAction removeFromParent]]]];
    
    
    SKShapeNode *tapArea = [SKShapeNode shapeNodeWithCircleOfRadius:50];
    tapArea.fillColor = [SKColor clearColor];
    tapArea.strokeColor = [SKColor blackColor];
}


-(void)placeSentry:(CGPoint)touchLocation {
    
    if (_deployedSentries < _allowedSentries) {
        
        SKSpriteNode *sentry = [SKSpriteNode spriteNodeWithImageNamed:@"MockSentry"];
        sentry.position = touchLocation;
        sentry.color = [UIColor redColor];
        sentry.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sentry.size.height/2];
        sentry.physicsBody.dynamic = NO;
        sentry.physicsBody.affectedByGravity = NO;
        sentry.physicsBody.categoryBitMask = sentryTrigger;
        sentry.physicsBody.contactTestBitMask = antCategory;
        sentry.physicsBody.collisionBitMask = antCategory;
        _deployedSentries++;
        [self addChild:sentry];
    }
    else
        NSLog(@"Max number of sentries reached. %d sentries active", _deployedSentries);
}





-(void)placeBomb:(CGPoint)touchLocation {
    
    SKTexture *temp = _bombFrames[0];
    SKSpriteNode *bomb = [SKSpriteNode spriteNodeWithTexture:temp];
    bomb.position = touchLocation;
    CGPoint bombLocation = bomb.position;
    
    SKAction * fuse = [SKAction animateWithTextures:self.bombFrames timePerFrame:0.05f];
    [self addChild:bomb];
    //[bomb runAction:[SKAction sequence:@[fuse, [SKAction removeFromParent] ]]];
    
    [bomb runAction:[SKAction sequence:@[fuse, [SKAction removeFromParent] ]] completion:^{
        [self explodeBomb:bombLocation];
    }];
}





-(void)explodeBomb:(CGPoint)bombLocation
{
    SKShapeNode *explosion = [SKShapeNode shapeNodeWithCircleOfRadius:50];
    explosion.fillColor = [UIColor redColor];
    explosion.alpha = 0.3;
    explosion.position = bombLocation;
    
    
    //Create a physics body for the explosion
    explosion.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:explosion.frame.size.height];
 
    explosion.physicsBody.dynamic = YES;
    explosion.physicsBody.affectedByGravity = NO;
    
    // Set category bitmask to ant category
    //fireball.physicsBody.categoryBitMask = fireballCategory;
    
    explosion.physicsBody.categoryBitMask = explosion_category;
    // Determine which physics objects trigger the contact listener when touched
    //fireball.physicsBody.contactTestBitMask = antCategory;
    
    explosion.physicsBody.contactTestBitMask = antCategory;
    
    explosion.physicsBody.collisionBitMask = antCategory;
    explosion.physicsBody.usesPreciseCollisionDetection = YES;

    
    SKAction *expand = [SKAction scaleTo:4 duration:.25];
    //SKAction *expand = [SKAction m]
    [self addChild:explosion];
    [explosion runAction:[SKAction sequence:@[expand, [SKAction removeFromParent]]]];
}






-(void)shootFireballsAt:(Ant*)ant fromSentry:(SKSpriteNode*)sentry {
    [self shootFireballFrom:sentry.position towards:ant.position];
}




-(void)shootFireballs:(CGPoint)touchLocation {
    
    //just testing
    self.userData.fireballs_shoot_in_burst = YES;
    self.userData.fireballs_shoot_in_spread = YES;
    
    if (self.userData.fireballs_shoot_in_burst) {
        //NSLog(@"Fireballs shoot in burst");
        _last_touchLocation = touchLocation;
        [self shootFireballFrom:self.basket.position towards:touchLocation];
        [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(shootDelayedFireball) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(shootDelayedFireball) userInfo:nil repeats:NO];
        
    }
    else
        [self shootFireballFrom:self.basket.position towards:touchLocation];
}

-(void)shootDelayedFireball
{
    //NSLog(@"ShootDelayedFireball");
    //NSLog(@"last_touch_Location = %@", _last_touchLocation);
    [self shootFireballFrom:self.basket.position towards:_last_touchLocation];
}


-(float)getFireballAngle:(CGPoint)startPoint dest:(CGPoint)endPoint
{
    //determine rotation of fireball
    float rotationAngle = 0;
    int quadrant = 0;
    
    if (startPoint.x >= endPoint.x) {
        if (startPoint.y >= endPoint.y) {
            quadrant = 3;
        }
        else{
            quadrant = 2;
        }
    }
    else{
        if (startPoint.y >= endPoint.y){
            quadrant = 4;
        }
        else{
            quadrant = 1;
        }
    }
    
    switch (quadrant) {
        case 1:
        {
            //rotationAngle = (atan2f((endPoint.x - startPoint.x), (startPoint.y - endPoint.y)));
            
            rotationAngle = atan2f((startPoint.y - endPoint.y), (endPoint.x - startPoint.x));
            
            //rotationAngle = M_PI + rotationAngle;
            break;
        }
            
        case 2:
        {
            //rotationAngle = atan2f((startPoint.x - endPoint.x), (startPoint.y - endPoint.y));
            rotationAngle = atan2f((startPoint.y - endPoint.y), (startPoint.x - endPoint.x));
            rotationAngle = M_PI - rotationAngle;
            break;
        }
            
        case 3:
        {
            //rotationAngle = atan2f((startPoint.x - endPoint.x), (endPoint.y - startPoint.y));
            rotationAngle = atan2f((endPoint.y - startPoint.y), (startPoint.x - endPoint.x));
            //rotationAngle = M_PI - rotationAngle;
            rotationAngle = rotationAngle + M_PI;
            break;
        }
            
        case 4:
        {
            //rotationAngle = atan2f((endPoint.x - startPoint.x), (endPoint.y - startPoint.y));
            rotationAngle = atan2f((endPoint.y - startPoint.y), (endPoint.x - startPoint.x));
            rotationAngle = 2*M_PI - rotationAngle;
            break;
        }
    }
    return (float)rotationAngle;
}


-(void)shootFireballFrom:(CGPoint)startPoint towards:(CGPoint)endPoint
{
    
    float angle = [self getFireballAngle:startPoint dest:endPoint];
    
    float angleA = angle - (0.1*M_PI);
    float angleB = angle + (0.1*M_PI);
    
    float length = sqrtf( (startPoint.x - endPoint.x)*(startPoint.x - endPoint.x)  + (startPoint.y - endPoint.y)*(startPoint.y - endPoint.y));
    
    
    if (!(self.userData.fireballs_shoot_in_spread)) {
        //NSLog(@"Doesn't shoot in spread");
        //[self actually_shootFireballFrom:startPoint towards:endPoint];
        [self fireballWithAngle:angle length:length from:startPoint];
        return;
    }
    
    
    
    [self fireballWithAngle:angle length:length from:startPoint];
    [self fireballWithAngle:angleA length:length from:startPoint];
    [self fireballWithAngle:angleB length:length from:startPoint];
    
}


-(void)actually_shootFireballFrom:(CGPoint)startPoint towards:(CGPoint)endPoint
{
    SKSpriteNode *fireball = [SKSpriteNode spriteNodeWithTexture:_fireballFrames[0]];
    fireball.xScale = 0.2;
    fireball.yScale = 0.2;
    
    fireball.position = startPoint;
    
    //Create a physics body for the fireball
    fireball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:fireball.size.height/4];
    // Make movement controlled by physics
    fireball.physicsBody.dynamic = YES;
    fireball.physicsBody.affectedByGravity = NO;
    // Set category bitmask to ant category
    fireball.physicsBody.categoryBitMask = fireballCategory;
    // Determine which physics objects trigger the contact listener when touched
    fireball.physicsBody.contactTestBitMask = antCategory;
    
    fireball.physicsBody.collisionBitMask = 0;
    fireball.physicsBody.usesPreciseCollisionDetection = YES;
    
    //determine rotation of fireball
    float rotationAngle;
    int quadrant;
    
    if (startPoint.x >= endPoint.x) {
        if (startPoint.y >= endPoint.y) {
            quadrant = 3;
        }
        else{
            quadrant = 2;
        }
    }
    else{
        if (startPoint.y >= endPoint.y){
            quadrant = 4;
        }
        else{
            quadrant = 1;
        }
    }
    
    switch (quadrant) {
        case 1:
        {
            rotationAngle = (atan2f((startPoint.x - endPoint.x), (startPoint.y - endPoint.y))) * (-1);
            //rotationAngle = atan2f((touchLocation.x - fireball.position.x), (fireball.position.y - touchLocation.y));
            rotationAngle = M_PI + rotationAngle;
            break;
        }
            
        case 2:
        {
            rotationAngle = atan2f((endPoint.x - startPoint.x), (startPoint.y - endPoint.y));
            //rotationAngle = atan2f((fireball.position.y - touchLocation.y), (touchLocation.x - fireball.position.x));
            rotationAngle = M_PI + rotationAngle;
            break;
        }
            
        case 3:
        {
            rotationAngle = atan2f((startPoint.x - endPoint.x), (endPoint.y - startPoint.y));
            //rotationAngle = M_PI - rotationAngle;
            //rotationAngle = rotationAngle + M_PI;
            break;
        }
            
        case 4:
        {
            rotationAngle = atan2f((startPoint.x - endPoint.x), (endPoint.y - startPoint.y));
            //rotationAngle = M_PI + rotationAngle;
            break;
        }
    }
    
    fireball.zRotation = rotationAngle;
    
    //NSLog(@"Rotation Angle: %f", rotationAngle);
    
    [self addChild:fireball];
    
    int fireball_speed = 500;
    
    float fireball_distance = 10*sqrtf( ((endPoint.x - fireball.position.x)*(endPoint.x - fireball.position.x)) + ( (endPoint.y - fireball.position.y)*(endPoint.y - fireball.position.y)));
    
    SKAction * remove = [SKAction removeFromParent];
    SKAction *fire =[SKAction moveBy:(CGVectorMake((10*(endPoint.x - fireball.position.x)), (10*(endPoint.y - fireball.position.y)))) duration:(fireball_distance/fireball_speed)];
    
    
    
    //Animate fireball
    SKAction *animateFireball = [SKAction repeatAction:
                                 [SKAction animateWithTextures:_fireballFrames timePerFrame:0.05f resize:NO restore:YES]
                                                 count:100];
    [fireball runAction:animateFireball];
    [fireball runAction:[SKAction sequence:@[fire, remove]]];
}



-(void)fireballWithAngle:(float)angle length:(float)length from:(CGPoint)position
{
    //NSLog(@"Fireball with Angle called");
    int opposite = length * sinf(angle);
    int adj = length * cosf(angle);
    
    CGPoint destination;
    
    if (angle >= 0 && angle <= M_PI/2) {
        destination = CGPointMake((CGFloat)(position.x - adj), (CGFloat)(position.y - opposite));
    }
    
    else
        destination = CGPointMake((CGFloat)(position.x + adj), (CGFloat)(position.y - opposite));
    
    [self actually_shootFireballFrom:position towards:destination];
}








-(void)sprayBugSpray:(CGPoint)touchLocation {
    
    
    if (_bugSprayInCan > 0) {
        //NSLog(@"Spraying bug spray...");
        SKTexture *temp = _sprayFrames[0];
        SKSpriteNode *bugSpray = [SKSpriteNode spriteNodeWithTexture:temp];
    
        // Create physics body
        bugSpray.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bugSpray.size.height/2];
    
        //Make movement controlled by physics but not by gravity
        bugSpray.physicsBody.dynamic = NO;
        bugSpray.physicsBody.affectedByGravity = NO;
    
        //set category bitmask to Bugspray
        bugSpray.physicsBody.categoryBitMask = bugSprayCategory;
        bugSpray.physicsBody.contactTestBitMask = antCategory;
    
    
    
    
        // Place where user touched
        bugSpray.position = touchLocation;
    
        [self addChild:bugSpray];
    
        //Reduce spray in the can
        _bugSprayInCan -= 5;
        if ((_bugSprayInCan <= 0) && !_sprayRegenDelay){
            _bugSprayInCan -= 100;
            _sprayRegenDelay = YES;
        }
        else if ((_bugSprayInCan >= 0) && _sprayRegenDelay){
            _sprayRegenDelay = NO;
        }
        [self adjustSpraycan];
        
        //Animate the bugspray
        SKAction *sprayCloud = [SKAction repeatAction:
                                [SKAction animateWithTextures:_sprayFrames timePerFrame:0.1f resize:NO restore:YES]
                                            count:3];
    
        SKAction *sprayDone = [SKAction removeFromParent];
    
        [bugSpray runAction:[SKAction sequence:@[sprayCloud, sprayDone]]];
    }
    
    else {
        //Play empty can sound
        //NSLog(@"Out of bug spray");
    }
}


-(void)drawBolt:(CGPoint)origin toPoint:(CGPoint)destination
{
    //get the midpoint between the two points
    CGPoint midpoint = CGPointMake((origin.x + (destination.x - origin.x)/2), (origin.y + (destination.y - origin.y)/2));
    //make this the bolts position
    SKSpriteNode *bolt = [SKSpriteNode spriteNodeWithTexture:_zapperFrames[0]];
    bolt.position = midpoint;
    
    //distance between the points is the height of the bolt
    bolt.yScale = (sqrtf((destination.x - origin.x)*(destination.x - origin.x) + (destination.y - origin.y)*(destination.y - origin.y)))/bolt.size.height;
    bolt.xScale = bolt.yScale;

    
    //rotate bolt to the angle between the midpoint and the destination
    float angle = atan2f((destination.y - origin.y), (destination.x - origin.x));
    
    bolt.zRotation = angle + M_PI/2;
    
    //bolt.position = CGPointMake((positionInScene.x + (bolt.size.width/2)), (positionInScene.y + (bolt.size.height/2)));
    
    //bolt.position = CGPointMake(0,self.frame.size.height/2);
    
    
    
    
    [self addChild:bolt];
    
    //Animate the bolt
    SKAction *animateBolt = [SKAction repeatActionForever:
                             [SKAction animateWithTextures:_zapperFrames timePerFrame:0.05 resize:YES restore:YES]];
    [bolt runAction:animateBolt];
    
    SKAction *playZap = [SKAction playSoundFileNamed:@"Zap.wav" waitForCompletion:YES];
    SKAction *remove = [SKAction removeFromParent];
    [bolt runAction:[SKAction sequence:@[playZap, remove]]];
}



-(void)updateScore
{
    int deadAntsValue = floor(_antsSmashed /15);
    
    if (deadAntsValue != lastDeadAntsValue) {
        lastDeadAntsValue = deadAntsValue;
        switch (deadAntsValue){
            case 0:
            {
                _generationTime = 1.5*_baseGenerationTime;
                _ant_speed = 12.5;
                self.backgroundMusicPlayer.rate = 0.80f;
                break;
            }
            case 1:
            {
                _generationTime = 1.0*_baseGenerationTime;
                _ant_speed = 13;
                //_randomness = 27;
                self.backgroundMusicPlayer.rate = 0.85f;
                break;
            }
            case 2:
            {
                _generationTime = 0.9*_baseGenerationTime;
                //_randomness = 24;
                _ant_speed = 13.5;
                self.backgroundMusicPlayer.rate = 0.90f;
                break;
            }
            case 3:
            {
                _generationTime = 0.8*_baseGenerationTime;
                //_randomness = 21;
                _ant_speed = 14;
                self.backgroundMusicPlayer.rate = 0.95f;
                break;
            }
            case 4:
            {
                _generationTime = 0.7*_baseGenerationTime;
                //_randomness = 18;
                _ant_speed = 14.5;
                self.backgroundMusicPlayer.rate = 1.0f;
                break;
            }
            case 5:
            {
                _generationTime = 0.6*_baseGenerationTime;
                //_randomness = 15;
                _ant_speed = 15;
                self.backgroundMusicPlayer.rate = 1.05f;
                break;
            }
            case 6:
            {
                _generationTime = 0.5*_baseGenerationTime;
                //_randomness = 12;
                _ant_speed = 15.5;
                self.backgroundMusicPlayer.rate = 1.10f;
                break;
            }
            case 7:
            {
                _generationTime = 0.4*_baseGenerationTime;
                //_randomness = 9;
                _ant_speed = 16;
                self.backgroundMusicPlayer.rate = 1.15f;
                break;
            }
            case 8:
            {
                _generationTime = 0.3*_baseGenerationTime;
                //_randomness = 6;
                _ant_speed = 16.5;
                self.backgroundMusicPlayer.rate = 1.2f;
                break;
            }
            case 9:
            {
                _generationTime = 0.2*_baseGenerationTime;
                //_randomness = 3;
                _ant_speed = 17;
                self.backgroundMusicPlayer.rate = 1.25f;
                break;
            }
            case 10:
            {
                _generationTime = 0.1*_baseGenerationTime;
                //_randomness = 1;
                _ant_speed = 17.5;
                self.backgroundMusicPlayer.rate = 1.30f;
                break;
            }
            default:
            {
                break;
            }
        }
    }
}



-(CGPoint)convertPixelstoGrid:(CGPoint)PixelPoint
{
    int xCoordinate = floor(PixelPoint.x / self.tileSize);
    int yCoordinate = floor(PixelPoint.y / self.tileSize);
    
    return (CGPointMake(xCoordinate, yCoordinate));
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
   //NSLog(@"MyScene update called");
    
    if (_bugSprayInCan < _bugSprayFull) {
        _bugSprayInCan++;
        [self adjustSpraycan];
    }
    
    
    
    // Handle time delta.
    // If we drop below 60 fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1) {
        //more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    //NSLog(@"MyScene updateWithTimeSinceLastUpdate called");
    
    //NSLog(@"MyScene updateWithTimeSinceLastUpdate called");
    
    //Every frame, adds time since last update, when > 1 second, spawns ant
    // and resets time
    self.lastSpawnTimeInterval += timeSinceLast;

    if ((self.lastSpawnTimeInterval > _generationTime) && (_ants.count < _antsLimit) && _shouldSpawnAnts){
        self.lastSpawnTimeInterval = 0;
        [self generateAnt];
        //NSLog(@"update method called generateAnt");
    }
}

-(void)generateSquish:(CGPoint)antLocation {
    //NSLog(@"MyScene generateSquish called");
    
    //Play associated sound file
    [self runAction:[SKAction playSoundFileNamed:@"Squish.wav" waitForCompletion:NO]];
    
    SKSpriteNode *squish = [SKSpriteNode spriteNodeWithImageNamed:@"squished_ant"];
    squish.position = antLocation;
    [self showMultiplier:&antLocation];
    [self addChild:squish];
    SKAction *linger = [SKAction waitForDuration:0.1];
    SKAction *remove = [SKAction removeFromParent];
    
    [squish runAction:[SKAction sequence:@[linger, remove]]];

}

-(void)generateAntOnFire:(CGPoint)antLocation {
    
    //NSLog(@"MyScene generateAntOnFire called");
    
    //play associated sound file
    [self runAction:[SKAction playSoundFileNamed:@"Fire.wav" waitForCompletion:NO]];
    
    SKSpriteNode *antOnFire = [SKSpriteNode spriteNodeWithImageNamed:@"AntOnFire"];
    antOnFire.position = antLocation;
    [self showMultiplier:&antLocation];
    [self addChild:antOnFire];
    
    SKAction *linger = [SKAction waitForDuration:0.2];
    SKAction *remove = [SKAction removeFromParent];
    
    [antOnFire runAction:[SKAction sequence:@[linger, remove]]];
}

-(void)generateZappedAnt:(CGPoint)antLocation {
    //NSLog(@"MyScene generateZappedAnt called");
    SKSpriteNode *ZappedAnt = [SKSpriteNode spriteNodeWithImageNamed:@"ZappedAnt"];
    ZappedAnt.position = antLocation;
    [self showMultiplier:&antLocation];
    [self addChild:ZappedAnt];
    
    SKAction *linger = [SKAction waitForDuration:1];
    SKAction *remove = [SKAction removeFromParent];
    
    [ZappedAnt runAction:[SKAction sequence:@[linger, remove]]];
}


-(BOOL)shouldSpawnCoin
{
    int chance = (arc4random() % 100) + 1;
    
    if (chance > 90)
        return YES;
    else
        return NO;
}


-(void)spawnCoin:(CGPoint)spawnLocation
{
    NSLog(@"spawnCoin called");
    if(self.shouldSpawnCoin){
        
        NSLog(@"coin bitmask = %d", coin_Category);
        NSLog(@"Coinfall bitmask = %d", coinFall_Category);
        
        SKTexture *temp = _coinFrames[0];

        SKSpriteNode *coin = [SKSpriteNode spriteNodeWithTexture:temp];
        coin.position = spawnLocation;
    
        coin.xScale = 0.3;
        coin.yScale = 0.3;
        //coin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coin.frame.size.height center:coin.position];
        coin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coin.frame.size.height/2];
        NSLog(@"coin physics body: %@", coin.physicsBody);
        
        coin.physicsBody.categoryBitMask = coin_Category;
        coin.physicsBody.contactTestBitMask = coinFall_Category;
        coin.physicsBody.collisionBitMask = coinFall_Category;
        coin.physicsBody.usesPreciseCollisionDetection = YES;
        coin.physicsBody.affectedByGravity = YES;
        coin.physicsBody.dynamic = YES;
        coin.physicsBody.allowsRotation = NO;
        coin.physicsBody.mass = 10000000;
        coin.physicsBody.restitution = 0.999;
        
        SKAction *linger = [SKAction waitForDuration:1];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
        SKAction *blink = [SKAction repeatAction:[SKAction sequence:@[fadeOut, fadeIn]] count:3];
        
        [self addChild:coin];
        
        [coin runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_coinFrames timePerFrame:0.02]]];
        
        
        //create main fallSurface
        //CGRect fallRect = CGRectMake(10, spawnLocation.y-200, self.frame.size.width, 10);
        CGRect fallRect = CGRectMake(self.frame.size.width/2, spawnLocation.y-100, self.frame.size.width+300, 10);
        //SKShapeNode *fallSurface = [SKShapeNode shapeNodeWithRect:fallRect];
        SKSpriteNode *fallSurface = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:fallRect.size];
        fallSurface.position = fallRect.origin;
        
        
        //fallSurface.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fallRect.size center:CGPointMake(-200, spawnLocation.y-200)];
        fallSurface.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fallRect.size];
        
        //fallSurface.physicsBody.pinned = YES;
        NSLog(@"fall surface: %@", fallSurface);
        NSLog(@"fall Surface physics body: %@", fallSurface.physicsBody);
        fallSurface.physicsBody.dynamic = NO;
        fallSurface.physicsBody.affectedByGravity = NO;
        //fallSurface.physicsBody.pinned = YES;
        fallSurface.physicsBody.usesPreciseCollisionDetection = YES;
        
        fallSurface.physicsBody.categoryBitMask = coinFall_Category;
        fallSurface.physicsBody.collisionBitMask = coin_Category;
        //fallSurface.physicsBody.collisionBitMask = antCategory;
        fallSurface.physicsBody.contactTestBitMask = coin_Category;
        fallSurface.physicsBody.allowsRotation = NO;
        fallSurface.physicsBody.mass = 100000;
        fallSurface.physicsBody.restitution = 0.0001;
        
        //fallSurface.fillColor = [SKColor blackColor];
        [self addChild:fallSurface];
        
        NSLog(@"z fall surface: %f", fallSurface.zPosition);
        NSLog(@"z coin: %f", coin.zPosition);
        NSLog(@"fall surface is dynamic: %i", fallSurface.physicsBody.isDynamic);
        
        NSLog(@"coin is dynamic: %i", coin.physicsBody.isDynamic);
        
        NSLog(@"coin AND fall_surface: %u and %u", coin.physicsBody.collisionBitMask, fallSurface.physicsBody.categoryBitMask);
        NSLog(@"fall_surface AND coin: %u and %u", fallSurface.physicsBody.collisionBitMask, coin.physicsBody.categoryBitMask);
        
        [coin runAction:[SKAction sequence:@[linger,blink, remove]]];
        [fallSurface runAction:[SKAction sequence:@[[SKAction waitForDuration:3], remove]]];
        
        self.userData.cash = self.userData.cash + 1;
        
        NSLog(@"Physics world: %@", self.physicsWorld.description);
        
    }
}


-(void)projectile:(SKSpriteNode *)projectile didCollideWithAnt:(Ant *)ant {
    
    //NSLog(@"Hit");
    [projectile removeFromParent];
    [ant reduceHealthby:self.userData.fireball_damage];
    
    if (ant.health == 0) {
            //[ant removeAllActions];
            [self generateAntOnFire:ant.position];
            [self spawnCoin:ant.position];
            [_ants removeObject:ant];
            [ant removeFromParent];
            [self adjustScoreBy:1];
        
        if (([_ants count] < 1) && (_shouldSpawnAnts == FALSE)) {
            NSLog(@"Level completed");
            [self endGame];
        }
        
        }
}



-(void)explosion_didCollideWithAnt:(Ant*)ant {
    //NSLog(@"Hit");
    
    [ant reduceHealthby:10];
    
    if (ant.health == 0) {
        //[ant removeAllActions];
        [self generateAntOnFire:ant.position];
        [self spawnCoin:ant.position];
        [_ants removeObject:ant];
        [ant removeFromParent];
        [self adjustScoreBy:1];
        
        if (([_ants count] < 1) && (_shouldSpawnAnts == FALSE)) {
            NSLog(@"Level completed");
            [self endGame];
        }
        
    }
}





-(void)bugSpray:(SKSpriteNode *)bugSprayNode didCollideWithAnt:(Ant *)ant {
    
    //NSLog(@"Hit");
    //[bugSprayNode removeFromParent];
    
    [ant reduceHealthby:1];
    if (ant.health == 0) {
        // Replace later with poisoned ant animation
        
        [self generateAntOnFire:ant.position];
        [self spawnCoin:ant.position];
        [_ants removeObject:ant];
        [ant removeFromParent];
        [self adjustScoreBy:1];
        
        if (([_ants count] < 1) && (_shouldSpawnAnts == FALSE)) {
            NSLog(@"Level completed");
            [self endGame];
        }
        
    }

    
}


-(void)tapArea:(SKShapeNode*)tapArea didCollideWithAnt:(Ant*)ant
{
    //check if ant has already been hit by this particular area
    //check ant against array of ants hit
    
    [ant reduceHealthby:_tap_damage];
    [tapArea removeFromParent];
    
    if (ant.health <= 0) {
        [self generateSquish:ant.position];
        [self spawnCoin:ant.position];
        [_ants removeObject:ant];
        [ant removeFromParent];
        [self adjustScoreBy:1];
        
        if (([_ants count] < 1) && (_shouldSpawnAnts == FALSE)) {
            NSLog(@"Level completed");
            [self endGame];
        }
        
    }
}


-(void)tapStunArea:(SKShapeNode*)tapStunArea didCollideWithAnt:(Ant*)ant
{
    SKAction *slowDown = [SKAction speedTo:0.01 duration:0.01];
    SKAction *stay = [SKAction waitForDuration:0.03];
    SKAction *backToNormal = [SKAction speedTo:1 duration:0.01];
    
    [ant runAction:[SKAction sequence:@[slowDown, stay, backToNormal]]];
}






-(void)zapArea:(ZapArea*)zapArea didCollideWithAnt:(Ant*)ant
{
    NSLog(@"zap area did collide with ant");
    NSLog(@"arcLevel: %d, \npossibleArcs: %d", zapArea.arclevel, zapArea.possibleArcs);
    if ((zapArea.arclevel >= 1) && (zapArea.possibleArcs > 0)) {
        // create new zap area on ants position, with arclevel-1, reduce possible arcs on main
        
        //draw bolt from existing zap area to ant position
        [self drawBolt:zapArea.position toPoint:ant.position];
        
        //[self newZapArea:ant.position arcLevel:(zapArea.arclevel - 1)];
        
        CGPoint ant_position = ant.position;
        
        //zap ant
        NSLog(@"Zapper damage: %d", _zapper_damage);
        NSLog(@"Ant Healt: %d", ant.health);
        [ant reduceHealthby:_zapper_damage];
        if(ant.health >= 0){
            //NSLog(@"Ant killed");
            [self generateZappedAnt:ant.position];
            [self spawnCoin:ant.position];
            [_ants removeObject:ant];
            [ant removeFromParent];
            [self adjustScoreBy:1];
        }
        
        NSLog(@"make new zap Area");
        [self newZapArea:ant_position arcLevel:(zapArea.arclevel - 1)];
        
    }
}



-(void)showMultiplier:(CGPoint*)antLocation {
    if (_scoreMultiplier > 1) {
        SKSpriteNode *multiplier = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"X%d", _scoreMultiplier]];
        
        if ((antLocation->x) > self.frame.size.width)
            multiplier.position = CGPointMake(antLocation->x - 10, antLocation->y +10);
        else
            multiplier.position = CGPointMake(antLocation->x + 10, antLocation->y +10);
        
        multiplier.xScale = 0.1;
        multiplier.yScale = 0.1;
        multiplier.alpha = 0;
        [multiplier setUserInteractionEnabled:NO];
        [self addChild:multiplier];
        SKAction *appear = [SKAction fadeInWithDuration:0.5];
        SKAction *test = [SKAction scaleTo:0.3 duration:1];
        SKAction *linger = [SKAction waitForDuration:0.5];
        SKAction *remove = [SKAction removeFromParent];
        [multiplier runAction:test];
        [multiplier runAction:[SKAction sequence:@[appear, linger, remove]]];
        
    }
}


-(void)basket:(SKSpriteNode*)basket didCollideWithAnt:(Ant*)ant{
    _hearts--;
    [self adjustHearts];
    NSLog(@"hearts: %d", _hearts);
    
    if (_hearts <=0) {
        //game over
        //NSLog(@"Game Over");
        [self endGame];
    }
    [_ants removeObject:ant];
    [ant removeFromParent];
    
    //create red flash
    SKShapeNode *flash = [SKShapeNode shapeNodeWithRectOfSize:self.frame.size];
    flash.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    flash.fillColor = [UIColor redColor];
    flash.alpha = 0.2;
    
    SKAction *hit = [SKAction waitForDuration:0.1];
    [self addChild:flash];
    [flash runAction:[SKAction sequence:@[hit, [SKAction removeFromParent]]]];
}






- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Collision:");
    
    //Sorts out the two bodies that are passed according to their categoryBitMask
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    
    
    // Determines which objects are colliding and calls the appropriate method
    
    if (firstBody.categoryBitMask == antCategory) {
        
        switch (secondBody.categoryBitMask) {
            case basketCategory:
                //NSLog(@"Ant on basket contact detected");
                [self basket:(SKSpriteNode*)secondBody.node   didCollideWithAnt:(Ant*)firstBody.node];
                break;
            case fireballCategory:
                //NSLog(@"Ant on fireball contact detected");
                [self projectile:(SKSpriteNode *) secondBody.node didCollideWithAnt: (Ant *) firstBody.node];
                break;
            case bugSprayCategory:
                // Add new ant poisoned method
                //NSLog(@"Ant on bugSpray contact detected");
                [self bugSpray:(SKSpriteNode *)secondBody.node didCollideWithAnt:(Ant*)firstBody.node];
                break;
            case sentryTrigger:
                //shoot fireballs at ant
                //NSLog(@"Ant on sentryTrigger contact detected");
                [self shootFireballsAt:(Ant*)firstBody.node fromSentry:(SKSpriteNode*)secondBody.node];
                break;
                
            case tap_Category:
                [self tapArea:(SKShapeNode*)secondBody.node didCollideWithAnt:(Ant*)firstBody.node];
                break;
                
            case tap_stun_Category:
                [self tapStunArea:(SKShapeNode*)secondBody.node didCollideWithAnt:(Ant*)firstBody.node];
                break;
            
            case explosion_category:
                [self explosion_didCollideWithAnt:(Ant*)firstBody.node];
                break;
                
            case zap_Category:
                NSLog(@"Zap contact with ant detected");
                [self zapArea:(ZapArea*)secondBody.node didCollideWithAnt:(Ant*)firstBody.node];
                break;
                
            default:
                break;
        }
    }
    
    
}


- (void)endGame
{
    //pause scene
    [self setPaused:YES];
    
    self.backgroundMusicPlayer=nil;
    //NSLog(@"endGame called in MyScene");
    
    BOOL success = FALSE;
    if (_score >= _oneStarScore) {
        success = TRUE;
    }
    
    
    //------------
    //This needs to be set up to show a new view controller rather than a new scene
    //------------
    if (success) {
        //let gameView know that the level is completed
        NSLog(@"level Completed!!!");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"levelComplete" object:nil];
        //[self levelComplete];
    }
    else{
        //let gameViewknow that level failed
        NSLog(@"Level Failed");
        self.userData.currentLives--;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"levelFailed" object:nil];
    }
    //Send out GameIsOver notification
    [[NSNotificationCenter defaultCenter]postNotificationName:@"levelComplete" object:nil];
}

//
//
//-(void)levelComplete{
//    NSLog(@"levelComplete method called");
//    
//    //[self reportScore];
//    
//    //load up levelProgress file
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LevelProgress.plist"]; //3
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath: path]) //4
//    {
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"LevelProgress" ofType:@"plist"]; //
//        [fileManager copyItemAtPath:bundle toPath:path error:&error]; //6
//    }
//    
//    NSMutableDictionary *levelProgress = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
//    
//    
//    //Get current level info
//    NSString *levelName = [NSString stringWithFormat:@"Level%d", _levelNumber];
//    NSLog(@"level number = %d", _levelNumber);
//    //load data from plist
//    NSString *level_path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Level%d.plist", _levelNumber]];
//    if (![fileManager fileExistsAtPath:level_path])
//    {
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
//        [fileManager copyItemAtPath:bundle toPath:level_path error:&error];
//    }
//    
//    NSMutableDictionary *levelInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:level_path];
//    
//    
//    //Record the number of stars earned for the current level
//    int oneStarScore = [[levelInfo objectForKey:@"OneStarScore"] intValue];
//    int twoStarScore = [[levelInfo objectForKey:@"TwoStarScore"] intValue];
//    int threeStarScore = [[levelInfo objectForKey:@"ThreeStarScore"] intValue];
//    
//    
//    //Determine number of stars
//    if (_currentScore >= threeStarScore) {
//        [levelProgress setObject:[NSNumber numberWithInt:3] forKey:[NSString stringWithFormat:@"Level%dStars", _levelNumber]];
//        NSLog(@"Earned Three Stars!!!");
//    }
//    else if (_currentScore >= twoStarScore){
//        [levelProgress setObject:[NSNumber numberWithInt:2] forKey:[NSString stringWithFormat:@"Level%dStars", _levelNumber]];
//        NSLog(@"Earned Two Stars!!!");
//    }
//    else if (_currentScore >= oneStarScore){
//        [levelProgress setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Level%dStars", _levelNumber]];
//        NSLog(@"Earned One Star!!!");
//    }
//    
//    // Unlock the next level and increment the lastLevel value
//    if (self.userData.lastLevel == _levelNumber) {
//        self.userData.lastLevel++;
//        
//        [levelProgress setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"Level%dUnlocked", self.userData.lastLevel]];
//    }
//    
//    [levelProgress writeToFile:path atomically:YES];
//    
//    //NSLog(@"levelProgress: %@", levelProgress);
//}




-(void)stopMusic {
    [self.backgroundMusicPlayer stop];
}

-(void)startMusic {
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}


#pragma combo methods


-(void)checkCombo
{
    //NSLog(@"checkCombo called");
    if (_combo <= 0) {
        [self startComboTimer];
        [self increaseCombo];
    }
    else {
        [self resetComboTimer];
        [self increaseCombo];
    }
}

-(void)startComboTimer
{
    //NSLog(@"startComboTimer called");
    _comboTimer = [NSTimer scheduledTimerWithTimeInterval:_comboTimeLimit target:self selector:@selector(resetCombo) userInfo:nil repeats:NO];
}

-(void)increaseCombo
{
    //NSLog(@"increaseCombo called");
    _combo++;
    if (_combo < _multiplierLimit2) {
        _scoreMultiplier = 1;
    }
    else if ((_combo >= _multiplierLimit2)&&(_combo < _multiplierLimit3)){
        _scoreMultiplier = 2;
    }
    else if ((_combo >= _multiplierLimit3)&&(_combo < _multiplierLimit4)){
        _scoreMultiplier = 3;
    }
    else if ((_combo >= _multiplierLimit4)&&(_combo < _multiplierLimit5)){
        _scoreMultiplier = 4;
    }
    else if (_combo >= _multiplierLimit5){
        _scoreMultiplier = 5;
    }
    
    _score = _score + _scoreMultiplier;
    [self resetComboTimer];
    
}


-(void)resetCombo
{
    //NSLog(@"resetCombo called");
    _combo = 0;
    _scoreMultiplier = 1;
    //_cashMultiplier = 0;
}

-(void)resetComboTimer
{
    //NSLog(@"resetComboTimer called");
    [_comboTimer invalidate];
    _comboTimer = nil;
    [self startComboTimer];
}


@end

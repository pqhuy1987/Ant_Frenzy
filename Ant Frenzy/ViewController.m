//
//  ViewController.m
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LevelSelectViewController.h"
#import "StoreViewController.h"



#define _leaderboardIdentifier @"AntsLeaderBoard1"

@interface ViewController ()

@property (nonatomic) LevelSelectViewController* levelSelectVC;
@property (nonatomic) StoreViewController* store;

-(void)authenticateLocalPlayer;


// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic) int currentLevel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self authenticateLocalPlayer];
    [self loadUserData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveUserData];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Recieved Memory Warning ");
    [self saveUserData];
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//really?

-(void)reportScore:(int)newScore {
    //NSLog(@"reportScore called");
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = newScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];

    
    //add the score to the user data
    [self.userData addToTotal:newScore];
    
    //NSLog(@" new totalScore = %d", _userData.totalScore);
    
    if (newScore > _userData.highScore) {
        _userData.highScore = newScore;
        //NSLog(@"New high Score: %d", _userData.highScore);
    }
    
    int newCash = floor(newScore/100);
    //NSLog(@"Cash made: %d", newCash);
    _userData.cash = _userData.cash + newCash;
    //NSLog(@"User Cash = %d", _userData.cash);
    
    
    [self saveUserData];
}



-(void)authenticateLocalPlayer{
    NSLog(@"authenticateLocalPlayer called");
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        //_leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //Game
    if([identifier isEqualToString:@"Game"]){
        //Play button pressed, will segue to game
        
        if (_userData.checkIfEnoughLives){
            NSLog(@"segue to 'Game'");
            return YES;
        }
        
        NSLog(@" Level Select canceled: not enough lives to play :( ");
        //[self performSegueWithIdentifier:@"SorryScreen" sender:self];
        return NO;
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    NSLog(@"segue identifier: %@", [segue identifier]);
    NSLog(@"segue destVC: %@", [segue destinationViewController]);
    
    NSLog(@"Original user: %@", _userData);
    
    
    
    //Game
    if([[segue identifier] isEqualToString:@"Game"]){
        //Play button pressed, will segue to game
        
        GameViewController *game = (GameViewController*)[segue destinationViewController];
        game.userData = _userData;
        game.level = _userData.lastLevel;
    }
    
    
    //Level Select
    else if([[segue identifier] isEqualToString:@"LevelSelect"]){
        LevelSelectViewController *levelSelect = (LevelSelectViewController*)[segue destinationViewController];
        levelSelect.userData = _userData;
        NSLog(@"segue to 'Level Select'");
    }
    
    
    //Store
    else if([[segue identifier] isEqualToString:@"Store"]){
        StoreViewController *store = (StoreViewController*)[segue destinationViewController];
        store.userData = _userData;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserDataFromStore) name:@"updateUserDataFromStore" object:nil];
        NSLog(@"segue to 'Store'");
    }
    
}




    
 

-(IBAction)openScores {
    [self showLeaderboardAndAchievements:YES];
}




-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}




-(void)removeChild:(UIViewController *) child {
    NSLog(@"%@ should be removed", child);
    [child didMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}




-(void)saveUserData
{
    //plist data
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"]; //
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //here add elements to data file and write data to file
    [data setObject:[NSNumber numberWithInt:_userData.highScore] forKey:@"userHighScore"];
    [data setObject:[NSNumber numberWithInt:_userData.totalScore] forKey:@"userTotalScore"];
    [data setObject:[NSNumber numberWithInt:_userData.lastLevel] forKey:@"lastLevel"];
    [data setObject:[NSNumber numberWithInt:_userData.cash] forKey:@"userCash"];
    
    //save all the stupid weapon data the hard way
    weapon *tempWeapon;
    //NSLog(@"size = %lu", _userData.weapons.count);
    for (int i=0; i < _userData.weapons.count; i++) {
        tempWeapon = _userData.weapons[i];
        NSString *tempKeyLevel = [NSString stringWithFormat:@"weapon%dlevel", i];
        NSString *tempKeyUnlocked = [NSString stringWithFormat:@"weapon%dunlocked", i];
        [data setObject:[NSNumber numberWithInt:tempWeapon.level] forKey:tempKeyLevel];
        [data setObject:[NSNumber numberWithBool:tempWeapon.unlocked] forKey:tempKeyUnlocked];
    }
    
    [data writeToFile: path atomically:YES];
    //[data release];
    NSLog(@"High Score of %d saved", _userData.highScore);
    NSLog(@"Total Score of %d saved", _userData.totalScore);
    

}

-(void)loadUserData
{
    _userData = [[User alloc] init];
    
    //plist data
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"]; //
        [fileManager copyItemAtPath:bundle toPath:path error:&error]; //6
    }
    
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //load from savedStock example int value
    int value;
    value = [[savedStock objectForKey:@"value"] intValue];
    
    _userData.highScore = [[savedStock objectForKey:@"userHighScore"] intValue];
    _userData.totalScore = [[savedStock objectForKey:@"userTotalScore"] intValue];
    _userData.lastLevel = [[savedStock objectForKey:@"lastLevel"] intValue];
    _userData.cash = [[savedStock objectForKey:@"userCash"] intValue];
    
    //User Lives Stuff
    _userData.currentLives = [[savedStock objectForKey:@"currentLives"] intValue];
    _userData.maxHearts = [[savedStock objectForKey:@"maxHearts"] intValue];
    _userData.MaxLives = [[savedStock objectForKey:@"maxLives"] intValue];
    _userData.regenDelay = [[savedStock objectForKey:@"regenDelay"] intValue];
    _userData.timeToResetLives = [[savedStock objectForKey:@"timeToResetLives"] intValue];
    _userData.pointRegenCount = [[savedStock objectForKey:@"pointRegenCount"] intValue];
    _userData.addPointsToRegenCount = [[savedStock objectForKey:@"addPointsToRegenCount"] boolValue];
    
    
    if (![_userData checkIfEnoughLives]) {
        [_userData checkIfRegenDate];
    }
    
    
    //weapon stuff
    //tap
    _userData.tap_hit_area_radius = [[savedStock objectForKey:@"tap_hit_area_radius"] intValue];
    _userData.tap_stun_area_radius = [[savedStock objectForKey:@"tap_stun_area_radius"] intValue];
    _userData.tap_damage = [[savedStock objectForKey:@"tap_damage"] intValue];
    _userData.tap_shoots_fireballs = [[savedStock objectForKey:@"tap_shoots_fireballs"] boolValue];
    
    //fireballs
    _userData.fireballs_shot_delay = [[savedStock objectForKey:@"fireballs_shot_delay"] intValue];
    _userData.fireballs_burst = [[savedStock objectForKey:@"fireballs_burst"] intValue];
    _userData.fireballs_shoot_in_burst = [[savedStock objectForKey:@"fireballs_shoot_in_burst"] boolValue];
    _userData.fireballs_shoot_in_spread = [[savedStock objectForKey:@"fireballs_shoot_in_spread"] boolValue];
    _userData.fireball_damage = [[savedStock objectForKey:@"fireball_damage"] intValue];
    
    //zapper
    _userData.zapper_damage = [[savedStock objectForKey:@"zapper_damage"] intValue];
    _userData.zapper_arcs = [[savedStock objectForKey:@"zapper_arcs"] boolValue];
    _userData.zapper_chain_length = [[savedStock objectForKey:@"zapper_chain_length"] intValue];
    _userData.zapper_arc_length = [[savedStock objectForKey:@"zapper_arc_length"] intValue];
    _userData.zapper_num_chains = [[savedStock objectForKey:@"zapper_num_chains"] intValue];
    
    //Bug Spray
    _userData.sprayRegenDelay = [[savedStock objectForKey:@"sprayRegenDelay"] boolValue];
    _userData.bugSprayFull = [[savedStock objectForKey:@"bugSprayFull"] intValue];
    _userData.bugSpray_area_radius = [[savedStock objectForKey:@"bugSpray_area_radius"] intValue];
    _userData.bugSpray_regen_rate = [[savedStock objectForKey:@"bugSpray_regen_rate"] intValue];
    
    NSLog(@"user.bugSprayFull = %d", _userData.bugSprayFull);
    
    //Sentry
    _userData.sentry_shot_delay = [[savedStock objectForKey:@"sentry_shot_delay"] intValue];
    _userData.sentry_area_radius = [[savedStock objectForKey:@"sentry_area_radius"] intValue];
    _userData.sentry_shoots_burst = [[savedStock objectForKey:@"sentry_shoots_burst"] boolValue];
    _userData.sentry_shoots_spread = [[savedStock objectForKey:@"sentry_shoots_spread"] boolValue];
    
    //target
    _userData.basketHealth = [[savedStock objectForKey:@"basketHealth"] intValue];
    _userData.target_has_shield = [[savedStock objectForKey:@"target_has_shield"] boolValue];
    _userData.target_shield_strength = [[savedStock objectForKey:@"target_shield_strength"] intValue];
    _userData.target_shield_delay = [[savedStock objectForKey:@"target_shield_delay"] intValue];
    _userData.target_shield_recharge_time = [[savedStock objectForKey:@"target_shield_recharge_time"] intValue];
    _userData.target_shield_regenerates = [[savedStock objectForKey:@"target_shield_regenerates"] boolValue];
    
    
    //load all the stupid weapon data the hard way
    weapon *tempWeapon;
    for (int i=1; i < [_userData.weapons count]; i++) {
        tempWeapon = _userData.weapons[i];
        NSString *tempKeyLevel = [NSString stringWithFormat:@"weapon%dlevel", i];
        NSString *tempKeyUnlocked = [NSString stringWithFormat:@"weapon%dunlocked", i];
        
        //check if weapon is Tap, if so, unlock automatically
        if (i == 0){
            tempWeapon.unlocked = YES;
        }
        else
            tempWeapon.unlocked = [[savedStock objectForKey:tempKeyUnlocked] boolValue];
        
        if (tempWeapon.unlocked){
            tempWeapon.level = [[savedStock objectForKey:tempKeyLevel] intValue];
            if ((i == 0) && ([[savedStock objectForKey:tempKeyLevel] intValue] == 0)) {
                tempWeapon.level = 1;
            }
        }
        else
            tempWeapon.level = 0;
        
        NSLog(@"Weapon: %@ loaded\n is unlocked: %i\n at level: %d", tempWeapon.name, tempWeapon.unlocked, tempWeapon.level);
    }
    
    NSLog(@"High Score of %d loaded", _userData.highScore);
    NSLog(@"Total Score of %d loaded", _userData.totalScore);
    NSLog(@"Last Level: %d loaded", _userData.lastLevel);
    NSLog(@"User Cash: %d loaded", _userData.cash);
}

-(void)updateUserDataFromStore
{
    NSLog(@"updateUserData called");
    _userData = _store.userData;
    _store.userData = _userData;
    [self saveUserData];
}


@end

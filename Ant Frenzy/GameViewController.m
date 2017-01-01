//
//  GameViewController.m
//  Ants
//
//  Created by Me on 2/8/14.
//  Copyright (c) 2014 Third Boot. All rights reserved.
//

#import "GameViewController.h"
#import "MyScene.h"
#import "LevelOverScene.h"




@interface GameViewController () 
@property (nonatomic) MyScene* scene;
@property (nonatomic) LevelOverScene* levelOverScene;
@property (nonatomic) BOOL musicPlaying;


@end

@implementation GameViewController 



-(void)viewDidLoad
{
    //Hide the game over labels
    gameOverLabel.hidden = TRUE;
    playAgainButton.hidden = TRUE;
    returnToMenuButton.hidden = TRUE;
    
    //Add self as observer for end of game notifications. Notifications let GameViewController know to prepare the game over screen and whether the player failed or completed the level
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:@"GameIsOver" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(levelComplete) name:@"levelComplete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(levelFailed) name:@"levelFailed" object:nil];
    
    
    //--------------------Weapon Setup-------------------------------------
    
    //Set self as observer for weapon changes
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchWeaponFromScroll:) name:@"weaponChange" object:nil];
    
    NSLog(@"User Weapons: %@", _userData.weapons);
    
    _weapons = [[NSMutableArray alloc] init];
    
    //load available weapons
    for (int i=0; i<_userData.weapons.count; i++) {
        weapon *tempWeapon = _userData.weapons[i];
        if (tempWeapon.unlocked) {
            [_weapons addObject:tempWeapon];
        }
    }
    NSLog(@"_weapons: %@", _weapons);
    
    //Page controller stuff
    self.weaponsPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeaponsPageViewController"];
    self.weaponsPageViewController.dataSource = self;
    
    //NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    WeaponsPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    
    
    NSArray *viewControllers = @[startingViewController];
    [self.weaponsPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //self.weaponsPageViewController.view.frame = CGRectMake(0 ,self.view.frame.size.height - 100, 100, 100);
    self.weaponsPageViewController.view.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 150, 200, 200);
    
    [self addChildViewController:_weaponsPageViewController];
    [self.view addSubview:_weaponsPageViewController.view];
    [self.weaponsPageViewController didMoveToParentViewController:self];
    
    //------------------End Weapons Setup---------------------------------------------
    
    
    
    
    NSLog(@"GameViewController Initialized");
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _musicPlaying = TRUE;
    
    // Configure view
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = NO;
        
        //Create the size of the scene
        CGSize sceneSize = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height + 150);
        
        
        // Create and configure the scene
        //self.scene = [MyScene sceneWithSize:skView.bounds.size];
        self.scene = [MyScene sceneWithSize:sceneSize];
        //self.scene = [MyScene sceneWithSize:CGSizeMake(200, 200)];
        
        
        //self.scene.scaleMode = SKSceneScaleModeAspectFit;
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //self.scene.blendMode = SKBlendModeAlpha;
        
        self.scene.userData = _userData;
        [self.scene loadUser];
        [self.scene loadLevel:_level];
        
        
        NSLog(@"GameViewController.User: %@", _userData);
        
        
        // Present the scene
        [skView presentScene:self.scene];
    }
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WeaponsPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WeaponsPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_weapons count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (WeaponsPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_weapons count] == 0) || (index >= [_weapons count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WeaponsPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeaponsPageContentViewController"];
    
    weapon *tempWeapon = _weapons[index];
    
    pageContentViewController.pageIndex = index;
    //pageContentViewController.weapon = self.userData.weapons[index];
    pageContentViewController.tag = tempWeapon.weaponMode;
    pageContentViewController.buttonText = tempWeapon.name;
    
    return pageContentViewController;
}

//------------------------------------------------------------------




//Show the game over screen
-(void)gameOver {
    NSLog(@"Notification recieved!");
    
    // Configure game over view
    //SKView * gameOverView = (SKView *)self.view;
    
    SKView *gameOverView = [[SKView alloc] initWithFrame:self.view.frame];
    [gameOverView setAlpha:0.3];
    
    self.view = gameOverView;
    if (!gameOverView.scene) {
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        //skView.showsPhysics = NO;
        
        //Create the size of the scene
        CGSize sceneSize = CGSizeMake(gameOverView.bounds.size.width-200, gameOverView.bounds.size.height -200);
        
        SKTransition *reveal = [SKTransition flipVerticalWithDuration:0.5];
        
        // Create and configure the scene
        //self.scene = [MyScene sceneWithSize:skView.bounds.size];
        self.levelOverScene = [LevelOverScene sceneWithSize:sceneSize];
        //self.scene = [MyScene sceneWithSize:CGSizeMake(200, 200)];
        
        
        self.levelOverScene = [[LevelOverScene alloc] initWithSize:sceneSize won:YES stars:1 score:120 cash:0];
        
        
        //self.scene.scaleMode = SKSceneScaleModeAspectFit;
        self.levelOverScene.scaleMode = SKSceneScaleModeAspectFill;
        
    
        // Present the scene
        //[gameOverView presentScene:self.levelOverScene];
        [gameOverView presentScene:self.levelOverScene transition:reveal];
        NSLog(@"Derp 1");
    }
    
    
    
    
    

    returnToMenuButton.hidden = FALSE;
    gameOverLabel.hidden = FALSE;
    playAgainButton.hidden = FALSE;
}





-(void)reportScore {
    //new GameCenter stuff
    _currentScore = _scene.currentScore;
    
    ViewController* parentView = (ViewController*)self.presentingViewController;
    [parentView reportScore:_currentScore];
    NSLog(@"Score of: %ld reported", (long)_currentScore);
}





-(void)levelComplete{
    NSLog(@"levelComplete method called");
    
    [self reportScore];
    
    
    
    //Pretty sure this can be made much simpler, add level progress as a part of the user object
    
    //load up levelProgress file
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LevelProgress.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"LevelProgress" ofType:@"plist"]; //
        [fileManager copyItemAtPath:bundle toPath:path error:&error]; //6
    }
    
    NSMutableDictionary *levelProgress = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    
    //Get current level info
    NSString *levelName = [NSString stringWithFormat:@"Level%d", _level];
    NSLog(@"level number = %d", _level);
    //load data from plist
    NSString *level_path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Level%d.plist", _level]];
    if (![fileManager fileExistsAtPath:level_path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:level_path error:&error];
    }
    
    NSMutableDictionary *levelInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:level_path];
    
    
    //Get the score required for each star
    int oneStarScore = [[levelInfo objectForKey:@"OneStarScore"] intValue];
    int twoStarScore = [[levelInfo objectForKey:@"TwoStarScore"] intValue];
    int threeStarScore = [[levelInfo objectForKey:@"ThreeStarScore"] intValue];
    
    
    //Create the level over view controller
    self.levelOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelOverViewController"];
    self.levelOverViewController.starsEarned = 0;
    
    
    //Determine number of stars
    if (_currentScore >= threeStarScore) {
        [levelProgress setObject:[NSNumber numberWithInt:3] forKey:[NSString stringWithFormat:@"Level%dStars", _level]];
        self.levelOverViewController.starsEarned = 3;
        NSLog(@"Earned Three Stars!!!");
    }
    else if (_currentScore >= twoStarScore){
        [levelProgress setObject:[NSNumber numberWithInt:2] forKey:[NSString stringWithFormat:@"Level%dStars", _level]];
        self.levelOverViewController.starsEarned = 2;
        NSLog(@"Earned Two Stars!!!");
    }
    else if (_currentScore >= oneStarScore){
        [levelProgress setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Level%dStars", _level]];
        self.levelOverViewController.starsEarned = 1;
        NSLog(@"Earned One Star!!!");
    }
    
    
    // Unlock the next level and increment the lastLevel value
    if (_userData.lastLevel == _level) {
        _userData.lastLevel++;
        
        [levelProgress setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"Level%dUnlocked", _userData.lastLevel]];
    }
    
    [levelProgress writeToFile:path atomically:YES];
    
    
    
    [self addChildViewController:self.levelOverViewController];
    [self.view addSubview:self.levelOverViewController.view];
    [self.weaponsPageViewController didMoveToParentViewController:self];
    //[self presentViewController:self.levelOverViewController animated:YES completion:NULL];
}



// Set up info for failed scene
-(void)levelFailed{
    NSLog(@"levelFailed method called");
    [self reportScore];
}



- (IBAction)returnToMenu {
    
    NSLog(@"GameViewController called switch method to Menu");
    
    [_scene removeAllChildren];
    [_scene stopMusic];
    [_scene removeFromParent];

    [self dismissViewControllerAnimated:YES completion:nil];
    //[self removeFromParentViewController];
}

-(IBAction)quit {
    NSLog(@"Quit Button pressed");
    [self reportScore];
    [self returnToMenu];
    
    //[self performSegueWithIdentifier:@"BackToLevelSelect" sender:self];
}

-(IBAction)playAgain {
    
    //[_scene removeAllChildren];
    //[_scene removeFromParent];
    
    // Configure view
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        NSLog(@"No skView.scene");
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        // Create and configure the scene
        self.scene = [MyScene sceneWithSize:skView.bounds.size];
        self.scene.scaleMode = SKSceneScaleModeAspectFit;
        
        
        // Present the scene
        [skView presentScene:self.scene];
        
        if(skView.scene)
            NSLog(@"New skView.scene created");
    }
    
    gameOverLabel.hidden = TRUE;
    playAgainButton.hidden = TRUE;
    returnToMenuButton.hidden = TRUE;
    
}



-(IBAction)switchWeapon:(id)sender {
    //Passes the tag of the button pressed to the Scene
    // the weapon mode will be set to the int value of the tag
    [_scene switch_weapon:(int)[sender tag]];
}




-(void)switchWeaponFromScroll:(NSNotification*)notification
{
    UIButton *tempButton = notification.object;
    
    [_scene switch_weapon:(int)tempButton.tag];
}




//There's a better way to do this for sure
-(void)switchWeapon0
{
    [_scene switch_weapon:0];
}

-(void)switchWeapon1
{
    [_scene switch_weapon:1];
}

-(void)switchWeapon2
{
    [_scene switch_weapon:2];
}

-(void)switchWeapon3
{
    [_scene switch_weapon:3];
}

-(void)switchWeapon4
{
    [_scene switch_weapon:4];
}

-(void)switchWeapon5
{
    [_scene switch_weapon:5];
}

-(IBAction)musicMute {
    if (_musicPlaying) {
        [_scene stopMusic];
        [musicMute setTitle:@"Music Off" forState:UIControlStateNormal];
        _musicPlaying = FALSE;
    }
    else {
        [_scene startMusic];
        [musicMute setTitle:@"Music On" forState:UIControlStateNormal];
        _musicPlaying = TRUE;
    }
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




- (void)didReceiveMemoryWarning
{
    NSLog(@"GameViewController recieved Memory Warning ");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"segue identifier: %@", [segue identifier]);
    NSLog(@"segue destVC: %@", [segue destinationViewController]);
    
    NSLog(@"Original user: %@", _userData);

    if ( object_getClassName([segue destinationViewController]) == ViewController) {
        ViewController *destinationView = (ViewController*)[segue destinationViewController];
        destinationView.userData = _userData;
    }
    
    if ( object_getClassName([segue destinationViewController]) == LevelSelectViewController) {
        LevelSelectViewController *destinationView = (LevelSelectViewController*)[segue destinationViewController];
        destinationView.userData = _userData;
    }
    
}*/


@end

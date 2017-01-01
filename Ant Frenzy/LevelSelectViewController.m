//
//  LevelSelectViewController.m
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "ViewController.h"
#import "Level.h"
#import "LevelSelectPageContentViewController.h"


@interface LevelSelectViewController ()
@property (nonatomic) ViewController *viewController;
@property (nonatomic) NSMutableArray *levels;
@end

@implementation LevelSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewController = (ViewController*)self.presentingViewController;
    NSLog(@"LevelSelectViewController loaded");
    _lastLevel = 50;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playLevel:) name:@"Playlevel" object:nil];
    
    [self loadLevelProgress];
    
    
    self.levelPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelSelectPageViewController"];
    self.levelPageViewController.dataSource = self;
    self.levelPageViewController.delegate = self;
    
    LevelSelectPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.levelPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    //Get appropriate sizes
    int pageWidth = self.view.frame.size.width - 50;
    
    // Change the size of page view controller
    //self.levelPageViewController.view.frame = CGRectMake(25, 200, self.view.frame.size.width-100, self.view.frame.size.height - 400);
    self.levelPageViewController.view.frame = CGRectMake(25, (self.view.frame.size.height/2 - pageWidth/2), pageWidth, pageWidth);
    
    [self addChildViewController:_levelPageViewController];
    [self.view addSubview:_levelPageViewController.view];
    [self.levelPageViewController didMoveToParentViewController:self];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self refreshPage];
}



#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index = ((LevelSelectPageContentViewController*) viewController).pageIndex;
    NSLog(@"viewController Before, Index: %lu", (unsigned long)index);
    
    
    if ((index == 0) || (index == NSNotFound)) {
        NSLog(@"No");
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((LevelSelectPageContentViewController*) viewController).pageIndex;
    NSLog(@"ViewController After, Index: %lu", (unsigned long)index);
    
    if (index == NSNotFound) {
        return nil;
    }
    if (index*5 >= [self.levels count]) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}



- (LevelSelectPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"VC at index: %lu", (unsigned long)index);
    
    if (index*5 >= [self.levels count]) {
        return nil;
    }
    if (([self.levels count] == 0) || (index >= [self.levels count])) {
        return nil;
    }
    
    
    // Get a view controller from the _levelPages array and pass suitable data.
    LevelSelectPageContentViewController *tempPage = _levelPages[index];
    
    
    tempPage.pageIndex = index;
    tempPage.userData = _userData;
    
    return tempPage;
}







-(void)loadLevelProgress
{
    NSLog(@"Load Level Progress called");
    _levels = [[NSMutableArray alloc] init];
    _levelPages = [[NSMutableArray alloc] init];
    
    //plist data
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
    //NSLog(@"levelProgress object: %@", levelProgress);
    
    for (int i = 1; i <= 50; i++) {
        Level *tempLevel = [[Level alloc] init];
        tempLevel.unlocked = [[levelProgress objectForKey:[NSString stringWithFormat:@"Level%dUnlocked", i]] boolValue];
        tempLevel.starsEarned = [[levelProgress objectForKey:[NSString stringWithFormat:@"Level%dStars", i]] intValue];
        NSLog(@"Level %d : Stars: %d, unlocked: %d \n", i, tempLevel.starsEarned, tempLevel.unlocked);
        tempLevel.levelNumber = i;
        
        //NSLog(@"tempLevel: %@", tempLevel);
        [_levels addObject:tempLevel];
    }
    
    for (int i=0; i< 10; i++) {
        LevelSelectPageContentViewController *temp_levelPageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelSelectPageContentViewController"];
        temp_levelPageContentViewController.level1 = _levels[(5*i)];
        temp_levelPageContentViewController.level2 = _levels[(5*i) + 1];
        temp_levelPageContentViewController.level3 = _levels[(5*i) + 2];
        temp_levelPageContentViewController.level4 = _levels[(5*i) + 3];
        temp_levelPageContentViewController.level5 = _levels[(5*i) + 4];
        
        [_levelPages addObject:temp_levelPageContentViewController];
    }
    
    //[self refreshPage];
    
}



-(IBAction)returnToMenu:(id)sender
{
    NSLog(@"StoreViewController called switch method to Menu");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}


-(void)playLevel:(id)sender
{
    if (_userData.checkIfEnoughLives)
        [self performSegueWithIdentifier: @"PlayGame" sender: self];
    else
        NSLog(@" Level Select canceled: not enough lives to play :( ");
        //[self performSegueWithIdentifier:@"SorryScreen" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSInteger level = [sender tag];
    NSLog(@"preparing for level: %li", (long)level);
    GameViewController *game = (GameViewController*)[segue destinationViewController];
    game.level = (int)level;
    game.userData = _userData;
}







/*
-(void)refreshPage
{
 
    NSLog(@"Refresh Page called");
    NSLog(@"_levels count: %lu", (unsigned long)_levels.count);
    
    Level* tempLevel;
    for (int i=1; i<=5; i++) {
        NSLog(@"i = %d", i);
        switch (i) {
            case 1:
                //NSLog(@"tempLevel: %d", (level1.tag - 1));
                tempLevel = _levels[level1.tag - 1];
                
                if (tempLevel.unlocked) {
                    [level1 setTitle:[NSString stringWithFormat:@"%ld", (long)level1.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 1 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [level1 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [level1 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [level1 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars"] forState:UIControlStateNormal];
                            break;
                        default:
                            [level1 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    level1.enabled = YES;
                }
                else{
                    [level1 setTitle:@"Locked" forState:UIControlStateNormal];
                    level1.enabled = NO;
                }
                break;
            case 2:
                tempLevel = _levels[level2.tag - 1];
                //NSLog(@"tempLevel: %d", (level2.tag - 1));
                if (tempLevel.unlocked) {
                    [level2 setTitle:[NSString stringWithFormat:@"%ld", (long)level2.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 2 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [level2 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [level2 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [level2 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [level2 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    level2.enabled = YES;
                }
                else{
                    [level2 setTitle:@"Locked" forState:UIControlStateNormal];
                    level2.enabled = NO;
                }
                break;
            case 3:
                tempLevel = _levels[level3.tag - 1];
                //NSLog(@"tempLevel: %d", (level3.tag - 1));
                if (tempLevel.unlocked) {
                    [level3 setTitle:[NSString stringWithFormat:@"%ld", (long)level3.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 3 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [level3 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [level3 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [level3 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [level3 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    level3.enabled = YES;
                }
                else{
                    [level3 setTitle:@"Locked" forState:UIControlStateNormal];
                    level3.enabled = NO;
                }
                break;
            case 4:
                tempLevel = _levels[level4.tag - 1];
                //NSLog(@"tempLevel: %d", (level4.tag - 1));
                if (tempLevel.unlocked) {
                    [level4 setTitle:[NSString stringWithFormat:@"%ld", (long)level4.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 4 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [level4 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [level4 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [level4 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [level4 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    level4.enabled = YES;
                }
                else{
                    [level4 setTitle:@"Locked" forState:UIControlStateNormal];
                    level4.enabled = NO;
                }
                break;
            case 5:
                tempLevel = _levels[level5.tag - 1];
                //NSLog(@"tempLevel: %d", (level5.tag - 1));
                if (tempLevel.unlocked) {
                    [level5 setTitle:[NSString stringWithFormat:@"%ld", (long)level5.tag] forState:UIControlStateNormal];
                    NSLog(@"Level 5 has %d stars", tempLevel.starsEarned);
                    switch (tempLevel.starsEarned) {
                        case 1:
                            [level5 setBackgroundImage:[UIImage imageNamed:@"LevelIconOneStar.png"] forState:UIControlStateNormal];
                            break;
                        case 2:
                            [level5 setBackgroundImage:[UIImage imageNamed:@"LevelIconTwoStars.png"] forState:UIControlStateNormal];
                            break;
                        case 3:
                            [level5 setBackgroundImage:[UIImage imageNamed:@"LevelIconThreeStars.png"] forState:UIControlStateNormal];
                            break;
                        default:
                            [level5 setBackgroundImage:[UIImage imageNamed:@"LevelIconNoStars.png"] forState:UIControlStateNormal];
                            break;
                    }
                    
                    level5.enabled = YES;
                }
                else{
                    [level5 setTitle:@"Locked" forState:UIControlStateNormal];
                    level5.enabled = NO;
                }
                break;
                
            default:
                break;
        }
        
    }
    
    
    // Hide or show next/previous buttons
    if (level5.tag == _lastLevel) {
        nextPage.hidden = TRUE;
    }
    else
        nextPage.hidden = FALSE;
    
    if (level1.tag == 1) {
        previousPage.hidden = TRUE;
    }
    else
        previousPage.hidden = FALSE;
    
    //NSLog(@"level1 tag = %d", level1.tag);
    //NSLog(@"level1 title = %@", level1.titleLabel.text);
    NSLog(@"Refresh page finished");
}
*/




-(void)reportScore:(int)newScore {
    //Relay the reportScore to the main view controller
    ViewController* parentView = (ViewController*)self.presentingViewController;
    [parentView reportScore:(newScore)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

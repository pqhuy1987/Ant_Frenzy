//
//  StoreViewController.m
//  Ant Frenzy
//
//  Created by Me on 2/15/15.
//  Copyright (c) 2015 Third Boot. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@property ViewController *mainViewController;

@end

@implementation StoreViewController
@synthesize _bannerView;



-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [_bannerView setHidden:NO];
    //NSLog(@"Showing");
}




-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [_bannerView setHidden:YES];
    //NSLog(@"Hidden");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"UserBoughtUpgrade" object:nil];
    
    //Page controller stuff-------------------------------------------------
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StorePageViewController"];
    self.pageViewController.dataSource = self;
    
    StorePageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    //int pageViewWidth = self.view.frame.size.width - 20;
    //int pageViewHeight = self.view.frame.size.height -175;
    
    int pageViewWidth = self.view.frame.size.width - 20;
    int pageViewHeight = self.view.frame.size.height - 2*(self.view.frame.size.height/10) -5;

    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(50, 150, pageViewWidth, pageViewHeight);
    self.pageViewController.view.frame = CGRectMake(10, 2*(self.view.frame.size.height/10), pageViewWidth, pageViewHeight);
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    //---------------------------------------------------------------------
}

-(void)refresh
{
    cashAvailable.text = [NSString stringWithFormat:@"%d",_userData.cash];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSLog(@"Called b4");
    NSUInteger index = ((StorePageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"Called After");
    NSUInteger index = ((StorePageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.userData.weapons count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (StorePageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.userData.weapons count] == 0) || (index >= [self.userData.weapons count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    StorePageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StorePageContentViewController"];
    
    
    pageContentViewController.pageIndex = index;
    pageContentViewController.weapon = self.userData.weapons[index];
    pageContentViewController.userData = self.userData;
    
    return pageContentViewController;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)returnToMenu
{
    NSLog(@"StoreViewController called switch method to Menu");
    
    //ViewController *parent = (ViewController*)[self parentViewController];
    //parent.userData = _userData;
    
    NSLog(@"bugSpray: %d", _userData.bugSprayFull);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
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

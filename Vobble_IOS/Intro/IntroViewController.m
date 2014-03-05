//
//  IntroViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "IntroViewController.h"
#define PAGE_CONTROL_COUNT 4
@interface IntroViewController ()
@property (nonatomic, weak) IBOutlet UIButton* backBtn;
@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.delegate	= self;
	_scrollView.dataSource	= self;
    _scrollView.userInteractionEnabled = YES;
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = PAGE_CONTROL_COUNT;
    
    if (_type == INTRO_FIRST) {
        [_backBtn setHidden:TRUE];
    }else{
        [_backBtn setHidden:FALSE];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
}
- (IBAction)backClick:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)setPageControl{
    _pageControl.currentPage = _scrollView.currentIndexPath.row % PAGE_CONTROL_COUNT;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 메인뷰의 스크롤을 고정시키기 위함
    if (scrollView == _scrollView) {
        [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    }
    if (scrollView.contentOffset.x > 320*(PAGE_CONTROL_COUNT-1)) {
        if (_type == INTRO_FIRST) {
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"IsViewIntro"];
            [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
        }else if (_type == INTRO_MENU){
            [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setPageControl];
}

#pragma mark PunchScrollView DataSources
- (NSInteger)numberOfSectionsInPunchScrollView:(PunchScrollView *)scrollView
{
	return 1;
}

- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
	return PAGE_CONTROL_COUNT;
}


- (UIView*)punchScrollView:(PunchScrollView*)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
	UIImageView *page = (UIImageView*)[scrollView pageForIndexPath:indexPath];
	if (page == nil)
	{
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"tu%02ld.png",indexPath.row+1]]];
        imgView.frame = [[UIScreen mainScreen] bounds];
        return imgView;
    }
	return page;
}

#pragma mark PunchScrollView Delegate
- (void)punchScrollView:(PunchScrollView*)scrollView pageChanged:(NSIndexPath*)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

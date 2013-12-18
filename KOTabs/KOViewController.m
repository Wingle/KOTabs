//
//  KOViewController.m
//  KOTabs
//
//  Created by Adam Horacek on 05.08.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOTabs
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOViewController.h"
#import "KOTabs.h"
#import "KOTabView.h"

@interface KOViewController ()

@property (nonatomic, strong) KOTabs *tabs;

@end

@implementation KOViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return NO;
    }
    return YES;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat yOffset = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20.f : 0;
	CGRect rect = CGRectMake(0, yOffset, self.view.bounds.size.height, self.view.bounds.size.width-yOffset);
	KOTabView *tabView1 = [[KOTabView alloc] initWithFrame:rect];
	[tabView1 setBackgroundColor:[UIColor purpleColor]];
	[tabView1 setIndex:0];
	[tabView1 setName:@"tabView1"];
    [tabView1.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
	
	KOTabView *tabView2 = [[KOTabView alloc] initWithFrame:rect];
	[tabView2 setBackgroundColor:[UIColor greenColor]];
	[tabView2 setIndex:1];
	[tabView2 setName:@"tabView2"];
    [tabView2.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
	
	KOTabView *tabView3 = [[KOTabView alloc] initWithFrame:rect];
	[tabView3 setBackgroundColor:[UIColor purpleColor]];
	[tabView3 setIndex:2];
	[tabView3 setName:@"tabView3"];
    [tabView3.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.verycd.com"]]];
	
	NSMutableArray *tabViews = [NSMutableArray arrayWithObjects:tabView1, tabView2, tabView3, nil];
	
	self.tabs = [[KOTabs alloc] initWithFrame:rect];
	[self.tabs setDelegate:(id<KOTabsDelegate>)self];
	
	[self.tabs setTabViews:tabViews];
	[self.tabs setActiveBarIndex:0];
	[self.tabs setActiveViewIndex:0];
	
	[self.view addSubview:self.tabs];
    
}

#pragma mark - KOTabbedViewDelegate

- (void)tabs:(KOTabs *)tabs didSwitchItem:(id)item
{
	
}

- (void)tabs:(KOTabs *)tabs didCloseItem:(id)item
{
	
}

@end

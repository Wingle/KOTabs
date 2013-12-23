//
//  KOTabbedView.m
//  Kodiak
//
//  Created by Adam Horacek on 26.02.12.
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

#import "KOTabs.h"
#import <QuartzCore/QuartzCore.h>
#import "KOTabButton.h"

#define KOCOLOR_TAB_TITLE [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_TAB_TITLE_SHADOW [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] /*#ffffff*/
#define KOCOLOR_TAB_TITLE_ACTIVE [UIColor colorWithRed:0.424 green:0.349 blue:0.239 alpha:1] /*#6c593d*/
#define KOCOLOR_TAB_TITLE_ACTIVE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.55] /*#ffffff*/
#define KOFONT_TAB_TITLE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
#define KOFONT_TAB_TITLE_ACTIVE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]

@implementation KOTabs

@synthesize tabbedBar, shadowView, tabbedView;
@synthesize leftCanc, rightCanc;
@synthesize tabViews, buttonViews;
@synthesize activeBarIndex, activeViewIndex;
@synthesize delegate;

#define OVERKILL 2048

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
				
		tabbedBar = [[UIScrollView alloc] initWithFrame:self.bounds];
		
		[tabbedBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"filetab-bg"]]];
		[tabbedBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[tabbedBar setClipsToBounds:YES];
		[tabbedBar setAlwaysBounceHorizontal:YES];
        [tabbedBar setShowsVerticalScrollIndicator:NO];
        [tabbedBar setShowsHorizontalScrollIndicator:NO];
		
        CGFloat tabbedBarWidth = 1024.f -100.f;
		CGRect rect = tabbedBar.frame;
		rect.size.height = 33;
        rect.size.width = tabbedBarWidth;
		tabbedBar.frame = rect;
		
		shadowView = [[UIView alloc] initWithFrame:rect];
		[shadowView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		
        rect = shadowView.bounds;
		UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:rect];
		shadowView.layer.masksToBounds = NO;
		shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
		shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		shadowView.layer.shadowOpacity = 0.5f;
		shadowView.layer.shadowRadius = 6.0f;
		shadowView.layer.shadowPath = shadowPath.CGPath;
		
		tabbedView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[tabbedView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
		
		rect = self.bounds;
		rect.size.height -= 33;
		rect.origin.y += 33;
		tabbedView.frame = rect;
		
		[tabbedView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        
        UIView *platFormView = [[UIView alloc] initWithFrame:CGRectMake(tabbedBarWidth, 0, 140.f, 33)];
        platFormView.backgroundColor = [UIColor clearColor];
        [self addSubview:platFormView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addButton.frame = CGRectMake(5.f, 0, 33.f, 33.f);
        [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:addButton];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        closeButton.frame = CGRectMake(addButton.frame.origin.x+addButton.frame.size.width+10.f, 0, 33.f, 33.f);
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:closeButton];
		
		[self addSubview:tabbedView];
		[self addSubview:shadowView];
		[self addSubview:tabbedBar];
		
		activeBarIndex = 0;
    }
    return self;
}

#pragma mark - KOTabbedView methods
- (NSMutableArray *)tabViews {
	return _tabViews;
}

- (void)setTabViews:(NSMutableArray *)_views {
	_tabViews = _views;
	
	self.buttonViews = [[NSMutableArray alloc] init];

	NSInteger index = 0;
	
	for (KOTabView *v in self.tabViews) {
		[v setFrame:tabbedView.bounds];
		[v setIndex:index];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
		CGSize size = [v.name sizeWithFont:[UIFont boldSystemFontOfSize:12]];
		CGFloat lastButtonViewMaxX = 0;	
		
		if ([buttonViews count])
			lastButtonViewMaxX = CGRectGetMaxX([[buttonViews lastObject] frame]);
		
		UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		if (index == 0)
			[buttonView setFrame:CGRectMake(lastButtonViewMaxX, 0, size.width + 45, 28)];
		else
			[buttonView setFrame:CGRectMake(lastButtonViewMaxX + 45, 0, size.width + 45, 28)];
		
		[tabbedBar addSubview:buttonView];
		[buttonViews addObject:buttonView];
		
		KOTabButton *closeButton = [KOTabButton buttonWithType:UIButtonTypeCustom];
		[closeButton setFrame:CGRectMake(0, 1, 28, 28)];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-on"] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateHighlighted];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateSelected];
		[closeButton setIndex:index];
		[closeButton addTarget:self action:@selector(closeButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
		[buttonView addSubview:closeButton];
        v.closeButton = closeButton;
		
		KOTabButton *titleButton = [KOTabButton buttonWithType:UIButtonTypeCustom];
		[titleButton setFrame:CGRectMake(23, 1, size.width + 16, 28)];
		[titleButton setIndex:index];
		
		[titleButton.titleLabel setFont:KOFONT_TAB_TITLE_ACTIVE];
		[titleButton setTitleColor:KOCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
		[titleButton setTitleShadowColor:KOCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
//		[titleButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        v.titleButton = titleButton;
		
		

		[titleButton setTitle:v.name forState:UIControlStateNormal];
        [titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleButton.titleLabel setTextAlignment:0];
		
		[titleButton addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
		[buttonView addSubview:titleButton];

		index++;
		
		size = tabbedBar.contentSize; //= 
		size.width = CGRectGetMaxX(buttonView.frame);
		tabbedBar.contentSize = size;
		
		
	}
	
	leftCanc = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"filetab-gradient-left"]stretchableImageWithLeftCapWidth:-44 topCapHeight:0]];
	
	CGRect rect = leftCanc.frame;
	rect.size.width = 45;
	rect.origin.x = -45;
	leftCanc.frame = rect;
	
	[tabbedBar insertSubview:leftCanc atIndex:0];
	
	rightCanc = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"filetab-gradient-right"] stretchableImageWithLeftCapWidth:44 topCapHeight:0]];

	rect = rightCanc.frame;
	rect.origin.x = 45;
	rightCanc.frame = rect;
	
	[rightCanc setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[tabbedBar insertSubview:rightCanc atIndex:0];
	
	
	
}

- (void)setActiveBarIndex:(NSInteger)_activeBarIndex {
	activeBarIndex = _activeBarIndex;
	UIView *buttonView = (UIView *)[buttonViews objectAtIndex:activeBarIndex];
	
	for (UIView *view in buttonViews) {
		UIButton *closeButton = [[view subviews] objectAtIndex:0];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-on"] forState:UIControlStateHighlighted];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"close-on"] forState:UIControlStateSelected];
		
		UIButton *titleButton = [[view subviews] objectAtIndex:1];
		[titleButton setTitleColor:KOCOLOR_TAB_TITLE forState:UIControlStateNormal];
		[titleButton setTitleShadowColor:KOCOLOR_TAB_TITLE_SHADOW forState:UIControlStateNormal];
	}
	
	UIButton *closeButton = [[buttonView subviews] objectAtIndex:0];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"close-on"] forState:UIControlStateNormal];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateHighlighted];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateSelected];
	
	if ([buttonViews count] == 1)
		[closeButton setHidden:YES];
	
	UIButton *titleButton = [[buttonView subviews] objectAtIndex:1];
	[titleButton setTitleColor:KOCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
	[titleButton setTitleShadowColor:KOCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
	
	
	CGRect rectLeftCanc = leftCanc.frame;
    rectLeftCanc.origin.x = -OVERKILL;
	rectLeftCanc.size.width = CGRectGetMinX(buttonView.frame) - rectLeftCanc.origin.x;
	
	CGRect rectRightCanc = rightCanc.frame;
    int rightX = tabbedBar.contentSize.width + OVERKILL;
    rectRightCanc.origin.x = CGRectGetMaxX(buttonView.frame);
	rectRightCanc.size.width = rightX - self.frame.size.width;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	leftCanc.frame = rectLeftCanc;
	rightCanc.frame = rectRightCanc;
	
	[UIView commitAnimations];
	
	
		
}

- (void)setActiveViewIndex:(NSInteger)_activeViewIndex {
	activeViewIndex = _activeViewIndex;
	
	[[self.tabViews objectAtIndex:activeViewIndex] setAlpha:1];
	[tabbedView addSubview:[self.tabViews objectAtIndex:activeViewIndex]];
    [[self.tabViews objectAtIndex:activeViewIndex] setFrame:tabbedView.bounds];
	
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.3];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	
////	[[[tabbedView subviews] objectAtIndex:0] setAlpha:0];
////	[[[tabbedView subviews] objectAtIndex:1] setAlpha:1];
//	
//	[UIView commitAnimations];
	
	[[[tabbedView subviews] objectAtIndex:0] removeFromSuperview];
	
}

#pragma mark - KOTabbedView actions

- (void)closeButtonAtIndex:(id)sender {
	
	if ([buttonViews count] == 1)
		return;
	
	KOTabButton *closeButton = sender;
	
	if (delegate && [delegate respondsToSelector:@selector(tabs:didCloseItem:)])
		[delegate tabs:self didCloseItem:nil];
	
	NSInteger newActiveBarIndex;
	
	if (activeBarIndex == closeButton.index) {
		if (closeButton.index == 0) {
			[self setActiveViewIndex:(closeButton.index + 1)];
			newActiveBarIndex = 0;
		} else {
			[self setActiveViewIndex:(closeButton.index - 1)];
			newActiveBarIndex = closeButton.index - 1;
		}
	} else if (activeBarIndex > closeButton.index) {
		
		newActiveBarIndex = activeBarIndex - 1;
		
	} else {
		newActiveBarIndex = activeBarIndex;
	}
	
	[self.buttonViews removeObjectAtIndex:closeButton.index];
	[self.tabViews removeObjectAtIndex:closeButton.index];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[[closeButton superview] setAlpha:0.0f];
	
	[UIView commitAnimations];
	
	[[closeButton superview] removeFromSuperview];
	
	CGRect rect = CGRectMake(0, 0, 0, 29);
	
	UIView *lastButtonView = nil;
	
	NSInteger i = 0;
	
	for (UIView *buttonView in buttonViews) {
		[(KOTabButton *)[[buttonView subviews] objectAtIndex:0] setIndex:i];
		[(KOTabButton *)[[buttonView subviews] objectAtIndex:1] setIndex:i];
		
		rect.size.width = buttonView.frame.size.width;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

		[buttonView setFrame:rect];
		
		[UIView commitAnimations];
		
		rect.origin.x = CGRectGetMaxX(rect) + 45;
		
		lastButtonView = buttonView;

		i++;
	}
	
	CGSize size = tabbedBar.contentSize;
	size.width = CGRectGetMaxX(lastButtonView.frame);
	tabbedBar.contentSize = size;
	
	[self setActiveBarIndex:newActiveBarIndex];
	
	if (delegate && [delegate respondsToSelector:@selector(tabs:didSwitchItem:)])
		[delegate tabs:self didSwitchItem:nil];
}

- (void)selectButtonAtIndex:(id)sender {
	if (activeBarIndex != [(KOTabButton *)sender index]) {
		[self setActiveBarIndex:[(KOTabButton *)sender index]];
		[self setActiveViewIndex:[(KOTabButton *)sender index]];
	}
	
	if (delegate && [delegate respondsToSelector:@selector(tabs:didSwitchItem:)])
		[delegate tabs:self didSwitchItem:nil];
}

- (KOTabView *)activeTabView {
	return [[self tabViews] objectAtIndex:activeBarIndex];
}

- (void)addTabView:(KOTabView *)tabView {
    [self.tabViews addObject:tabView];
    
    NSInteger index = [self.buttonViews count];
    [tabView setFrame:tabbedView.bounds];
    [tabView setIndex:index];
    [tabView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    CGSize size = [tabView.name sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    CGFloat lastButtonViewMaxX = 0;
    
    if ([self.buttonViews count])
        lastButtonViewMaxX = CGRectGetMaxX([[buttonViews lastObject] frame]);
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (index == 0)
        [buttonView setFrame:CGRectMake(lastButtonViewMaxX, 0, size.width + 45, 28)];
    else
        [buttonView setFrame:CGRectMake(lastButtonViewMaxX + 45, 0, size.width + 45, 28)];
    
    [self.tabbedBar addSubview:buttonView];
    [self.buttonViews addObject:buttonView];
    
    KOTabButton *closeButton = [KOTabButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 1, 28, 28)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close-on"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateHighlighted];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close-off"] forState:UIControlStateSelected];
    [closeButton setIndex:index];
    [closeButton addTarget:self action:@selector(closeButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:closeButton];
    tabView.closeButton = closeButton;
    
    KOTabButton *titleButton = [KOTabButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(23, 1, size.width + 16, 28)];
    [titleButton setIndex:index];
    
    [titleButton.titleLabel setFont:KOFONT_TAB_TITLE_ACTIVE];
    [titleButton setTitleColor:KOCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
    [titleButton setTitleShadowColor:KOCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
//    [titleButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [titleButton setTitle:tabView.name forState:UIControlStateNormal];
    [titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [titleButton addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:titleButton];
    tabView.titleButton = titleButton;
    
    size = tabbedBar.contentSize; //=
    size.width = CGRectGetMaxX(buttonView.frame);
    tabbedBar.contentSize = size;
    
    [self setActiveBarIndex:index];
    [self setActiveViewIndex:index];
    
}

- (NSUInteger)tabViewsCount {
    return [_tabViews count];
}

- (IBAction)add:(id)sender {
    if ([self tabViewsCount] >= 8) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:@"There are too much tabs, please close some."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    KOTabView *tabView3 = [[KOTabView alloc] initWithFrame:self.bounds];
	[tabView3 setBackgroundColor:[UIColor orangeColor]];
	[tabView3 setIndex:[self tabViewsCount]-1];
	[tabView3 setName:@"Home Page"];
    [tabView3.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    [self addTabView:tabView3];
}

- (IBAction)close:(id)sender {
    NSLog(@"Do something.");
}

@end

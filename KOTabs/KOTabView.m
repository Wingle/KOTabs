//
//  KOTabsView.m
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

#import "KOTabView.h"

@interface KOTabView ()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *forwardBtn;
@property (nonatomic, strong) UIButton *homepageBtn;
@property (nonatomic, strong) UIButton *bookmarkBtn;
@property (nonatomic, strong) UIButton *starBtn;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UIButton *stopOrReloadBtn;
@property (nonatomic, copy) NSURL *urlToLoad;


@end

@implementation KOTabView

@synthesize index;
@synthesize name;

#pragma mark - Init Methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = frame;
        rect.size.height = 33.f;
        UIView *platFormView = [[UIView alloc] initWithFrame:rect];
        [platFormView setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat xOffset = 10.f;
        CGFloat buttonWidth = 60.f;
        CGFloat buttonHeight = 33.f;
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(xOffset, 0, buttonWidth, buttonHeight);
        [self.backBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [self.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:self.backBtn];
        
        xOffset += buttonWidth;
        xOffset += 10.f;
        
        self.forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.forwardBtn.frame = CGRectMake(xOffset, 0, buttonWidth, buttonHeight);
        [self.forwardBtn setTitle:@"Forward" forState:UIControlStateNormal];
        [self.forwardBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.forwardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.forwardBtn addTarget:self action:@selector(forword:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:self.forwardBtn];
        
        xOffset += buttonWidth;
        xOffset += 10.f;
        
        self.homepageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.homepageBtn.frame = CGRectMake(xOffset, 0, buttonWidth, buttonHeight);
        [self.homepageBtn setTitle:@"Home" forState:UIControlStateNormal];
        [self.homepageBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.homepageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.homepageBtn addTarget:self action:@selector(homepage:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:self.homepageBtn];
        
        xOffset += buttonWidth;
        xOffset += 20.f;
        
        self.bookmarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bookmarkBtn.frame = CGRectMake(xOffset, 0, buttonWidth, buttonHeight);
        [self.bookmarkBtn setTitle:@"Bookmark" forState:UIControlStateNormal];
        [self.bookmarkBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.bookmarkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bookmarkBtn addTarget:self action:@selector(bookmark:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:self.bookmarkBtn];
        
        xOffset += buttonWidth;
        xOffset += 20.f;
        
        self.starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.starBtn.frame = CGRectMake(xOffset, 0, buttonWidth, buttonHeight);
        [self.starBtn setTitle:@"Star" forState:UIControlStateNormal];
        [self.starBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.starBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.starBtn addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
        [platFormView addSubview:self.starBtn];
        
        xOffset += buttonWidth;
        
        self.addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 33.f/2 - 28.f/2, 300.f, 28.f)];
        self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.addressTextField setFont:[UIFont systemFontOfSize:15.0]];
        self.addressTextField.placeholder = @"Input URL here...";
        self.addressTextField.keyboardType = UIKeyboardTypeURL;
        self.addressTextField.returnKeyType = UIReturnKeyGo;
        self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.addressTextField.delegate = self;
        
        self.stopOrReloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stopOrReloadBtn.bounds = CGRectMake(0, 0, 30.f, 30.f);
        self.stopOrReloadBtn.showsTouchWhenHighlighted = NO;
        [self.stopOrReloadBtn addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
        self.addressTextField.rightView = self.stopOrReloadBtn;
        self.addressTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
        [platFormView addSubview:self.addressTextField];
        
        [self addSubview:platFormView];
    
        
        rect.origin.y = 33.f;
        rect.size.height = 768.f - 33.f - 20.f - 33.f;      // diff tab bar(33.f) and status bar(20.f)
        _webView = [[UIWebView alloc] initWithFrame:rect];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self addSubview:_webView];
        
        [self updateLoadingStatus];
    }
    return self;
}

#pragma mark - IBAction Methods

- (IBAction)back:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)forword:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (IBAction)homepage:(id)sender {
    
}

- (IBAction)bookmark:(id)sender {
    
}

- (IBAction)star:(id)sender {
    
}

- (IBAction)reloadOrStop:(id)sender {
    
}

#pragma mark - Function Methods

- (void) updateLoadingStatus {
    if (self.webView.loading) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    // update status of back/forward buttons
    self.backBtn.enabled = [self.webView canGoBack];
    self.forwardBtn.enabled = [self.webView canGoForward];
}

- (void)setURL:(NSURL *)url {
    NSString *urlString = url.absoluteString;
    if ([urlString length]) {
        if (!url.scheme.length) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:urlString]];
        }
        self.urlToLoad = url;
    }
}

- (void)loadURL:(NSURL *)url {
    if (!self.webView) {
        [self setURL:url];
        return;
    }
    
    if (!url) {
        return;
    }
    
    self.addressTextField.text = url.absoluteString;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *) sender shouldStartLoadWithRequest:(NSURLRequest *) request navigationType:(UIWebViewNavigationType) navigationType {
    if ([request.URL.absoluteString isEqual:@"about:blank"]) {
        return NO;
    }

    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *) sender {
    [self updateLoadingStatus];
}

- (void) webViewDidFinishLoad:(UIWebView *) sender {
    // Disable the defaut actionSheet when doing a long press
    [sender stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    [sender stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
    [self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
}

- (void) webView:(UIWebView *)sender didFailLoadWithError:(NSError *) error {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
    [self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
}

#pragma mark - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    NSURL *url = [NSURL URLWithString:textField.text];
    
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:textField.text]];
    }
    
    [self loadURL:url];
    
    [self.addressTextField resignFirstResponder];
    
    return YES;
}

@end

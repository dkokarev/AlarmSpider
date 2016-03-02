
//
//  WebViewController.m
//  AlarmSpider
//
//  Created by danny on 02.03.16.
//  Copyright © 2016 danny. All rights reserved.
//

#import "WebViewController.h"
#import "Session.h"

static NSString * const BaseURL = @"http://alarmspider.com/casino/test/";
static NSInteger SecondsToRefreshBeforeEnd = 5;

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Session *session;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WebView";
    [self loadBaseURLWithLastPathComponent:@"index.php"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateSession {
    [self.webView stopLoading];
    [self loadBaseURLWithLastPathComponent:@"success.php?osType=ios&cmd=update"];
}

- (void)loadBaseURLWithLastPathComponent:(NSString *)component {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BaseURL stringByAppendingString:component]]]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self.timer invalidate];
    NSString *urlString = request.URL.absoluteString;
    if ([urlString isEqualToString:[BaseURL stringByAppendingString:@"success.php"]]) {
        [self loadBaseURLWithLastPathComponent:@"success.php?osType=ios"];
        return NO;
    } else if ([urlString isEqualToString:[BaseURL stringByAppendingString:@"success.php?cmd=update"]]) {
        [self loadBaseURLWithLastPathComponent:@"success.php?osType=ios&cmd=update"];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *urlString = webView.request.URL.absoluteString;
    if ([urlString isEqualToString:[BaseURL stringByAppendingString:@"success.php?osType=ios"]] ||
        [urlString isEqualToString:[BaseURL stringByAppendingString:@"success.php?osType=ios&cmd=update"]]) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:webView.request.URL];
        self.session = [[Session alloc] initWithCookies:cookies];
        if (!self.session) {
            return;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.session.timeToEnd - SecondsToRefreshBeforeEnd target:self selector:@selector(updateSession) userInfo:nil repeats:NO];
    }
}

@end

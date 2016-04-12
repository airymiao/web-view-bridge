//
//  ViewController.m
//  MeowBridge
//
//  Created by Air on 4/12/16.
//  Copyright © 2016 airymiao. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController ()

@property (copy, nonatomic) NSString *urlString;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _urlString = @"http://127.0.0.1:8081";
    
    [self render];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return @"WebView-Bridge";
}

- (void)render
{
    [self loadWebView];
    
    [self registerJavascriptBridge];
    
    [self configureNavigationItems];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    
    [_webView loadRequest:request];
}

- (void)configureNavigationItems
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(executeJavascriptCommand)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView)];
}

- (void)reloadWebView
{
    [_webView reload];
}

- (void)loadWebView
{
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.bounces = NO;
    
    [self.view addSubview:_webView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

#pragma mark - Web View Bridge Center

- (void)registerJavascriptBridge
{
    _javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [self bindJavascriptBridge];
}

- (void)executeJavascriptCommand
{
    [_javascriptBridge callHandler:@"demo-web" data:@{@"code":@"2000",@"type":@"alert",@"message":@{@"content":@"From iOS"}} responseCallback:^(id responseData) {
        NSLog(@"Response data from web:%@",responseData);
    }];
}

- (void)bindJavascriptBridge
{
    [_javascriptBridge registerHandler:@"demo-app" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Received data from web:%@",data);
        responseCallback(data);
        
        [self handleJavascriptBridgeCommand:data];
    }];
}

- (void)handleJavascriptBridgeCommand:(id)data
{
    NSDictionary *commandInfo = (NSDictionary *)data;
    
    if (!commandInfo) {
        return;
    }
    
    NSString *type = commandInfo[@"type"];
    
    if ([type isEqualToString:@"alert"]) {
        [self executeAlert:commandInfo[@"message"]];
    }
}

- (void)executeAlert:(NSDictionary *)message
{
    if (!message) {
        return;
    }
    
    NSString *content = message[@"content"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:content message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

@end

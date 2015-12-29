//
//  WebViewStyleViewController.m
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import "WebViewStyleViewController.h"
#import "SysUtils.h"
#import "AppUtils.h"
@interface WebViewStyleViewController (){
    
    
}

@end

@implementation WebViewStyleViewController

@synthesize menuURL				= _menuURL;

#pragma mark-
#pragma mark Application lifecycle methods
#pragma mark-

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = TRUE;

    [AppUtils settingRightButton:self action:@selector(leftButtonClicked:) normalImageCode:@"web_close.png" highlightImageCode:@"web_close.png"];
    [AppUtils settingLeftButton:self action:@selector(rightButtonClicked:) normalImageCode:@"web_back.png" highlightImageCode:@"web_back.png"];
    
    _web = [[UIWebView alloc] init];
    _web.frame		= CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    _web.backgroundColor		= [UIColor lightGrayColor];
    _web.scalesPageToFit		= YES;
    _web.dataDetectorTypes		= UIDataDetectorTypeLink;
    _web.delegate				= self;
    _web.scrollView.bounces     = NO;
    [self.view addSubview:_web];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_menuURL]];
    [_web loadRequest:req];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark-
#pragma mark Webview Delegate methods
#pragma mark-
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType {
    if ([SysUtils isNull:aRequest] == YES || [SysUtils isNull:[aRequest URL]] == YES)
        return NO;
    
    NSString *URLString = [[aRequest URL] absoluteString];
    NSString *decoded = [URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if([decoded isEqualToString:_menuURL]){
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }else{
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
 
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [AppUtils closeWaitingSplash];

    if([SysUtils isNull: [webView stringByEvaluatingJavaScriptFromString:@"document.title"]] ==YES){
        self.title=_menuURL;
    }else{
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];  //--Take HTML Tittle
    }

    self.view.userInteractionEnabled = YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [AppUtils showWaitingSplash];
}

#pragma mark -
#pragma mark - navigationBar Button Event
#pragma mark -
- (void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)rightButtonClicked:(UIButton *)sender {
    if([_web canGoBack]){
        [_web goBack];
    }
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

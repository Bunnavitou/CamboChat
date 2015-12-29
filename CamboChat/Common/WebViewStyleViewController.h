//
//  WebViewStyleViewController.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewStyleViewController : UIViewController<UIWebViewDelegate>{
    
    UIWebView*		_web;
    NSString*		_menuURL;
    
}
@property (nonatomic, copy) NSString* menuURL;

@end

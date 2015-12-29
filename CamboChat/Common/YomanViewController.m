//
//  YomanViewController.m
//  JobTesting
//
//  Created by Yoman on 6/30/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import "YomanViewController.h"

@interface YomanViewController (){
    
    NSString *strTranCode;
}

@end

@implementation YomanViewController

@synthesize waitingSplash = _waitingSplash;

static const NSInteger kTagWaitingSplashView					= 5001;


#pragma mark - LifeCycle Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.barTintColor = RGB(255,255,255);
    self.navigationController.navigationBar.translucent = NO;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWaitingSplash:)  name:kShowWaitingViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWaitingSplash:) name:kCloaseWaitingViewNotification object:nil];
  
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)sendTransaction:(NSDictionary *)requestDictionary{
    [[SercurityConnection sharedSecurityConnection] setDelegate:self];
    
    NSMutableDictionary *headDic = [[NSMutableDictionary alloc]init];
    [headDic setObject:requestDictionary forKey:@"REQ_DATA"];
    
    if(![[SercurityConnection sharedSecurityConnection] willConnect:KServerURL query:headDic  method:TRANS_METHOD_POST]){
        [SysUtils showMessage:@"The process of communication. Please try again later."];
        return;
    }
}
-(void)returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    NSDictionary *transResponse	= nil;
    
    if(errorCode==200){
        transResponse = [[returnResult JSONValue] valueForKey:@"RES_DATA"];
    
        NSLog(@"%@",returnResult);
//
//        NSLog(@"%@",[[returnResult JSONValue] valueForKey:@"RES_DATA"]);
        [self returnTransaction:transResponse success:YES];
    }else{
        [self returnTransaction:transResponse success:NO];
    }
}

-(void)returnTransaction:(NSDictionary *)responseDictionary success:(BOOL)success{
   
    
    
    
}
#pragma mark - Tittle -

-(void)yoSetTittle:(NSString *)strTittle{
    
    UIView *logoView                = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 35.0f)];
    logoView.backgroundColor        = [UIColor clearColor];
    
    UILabel *naviNewLabel           = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 2.0f, 200.0f, 35.0f)];
    naviNewLabel.backgroundColor    = [UIColor clearColor];
    naviNewLabel.font               = [UIFont systemFontOfSize:22.0f];
    naviNewLabel.textAlignment      = NSTextAlignmentCenter;
    naviNewLabel.textColor          = RGB(255, 255, 255);
    naviNewLabel.text               = strTittle;
    [logoView addSubview:naviNewLabel];
    
    
    //    UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 121.0f, 35.0f)];
    //    imageView.image             = [UIImage imageNamed:@"top_logo.png"];
    //    imageView.backgroundColor   = [UIColor clearColor];
    //    [logoView addSubview:imageView];
    
    
    self.navigationItem.titleView = logoView;
    
}

#pragma mark - Notificaiton Method -
- (void)showWaitingSplash:(NSNotification *)note    {
    if ([SysUtils isNull:_waitingSplash] == YES) {
        _waitingSplash		= [[WaitingSplashView alloc] init];
        _waitingSplash.tag	= kTagWaitingSplashView;
    }
    
    [self.view addSubview:_waitingSplash];
    [_waitingSplash show];
    
    self.view.userInteractionEnabled = NO;
    
}
- (void)closeWaitingSplash:(NSNotification *)note   {
    if ([SysUtils isNull:_waitingSplash] == YES)
        return;
    
    [_waitingSplash close];
    
    UIView *viewCurrentSplash = [self.view viewWithTag:kTagWaitingSplashView];
    if ([SysUtils isNull:viewCurrentSplash] == NO)
        [viewCurrentSplash removeFromSuperview];
    
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Get Height and Width -
- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}

- (CGFloat)measureTextWidth:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.width;
    
}

@end

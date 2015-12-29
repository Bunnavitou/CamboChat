//
//  SercurityConnection.m
//  JobTesting
//
//  Created by Yoman on 6/29/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import "SercurityConnection.h"
#import "URLUtils.h"
#import "SingleTonManager.h"

@interface SecurityHandler:NSObject <SecurityConnectionDelegate>{
    id					delegate;
    SecurityMethod		_method;
    NSURLConnection*    _connection;
    NSMutableData  *    _receivedData;
    
    NSInteger			_statusCode;
    NSString*           _URL;
    
}
//=====Property Decleration
@property (nonatomic)			SecurityMethod		method;
@property (nonatomic, retain)	id					delegate;
@property (retain, nonatomic)   NSURLConnection     *connection;
@property (retain, nonatomic)   NSMutableData       *receivedData;
@property (retain, nonatomic)   NSString            *URL;


//=====Private Method Decleration
- (void)sendTransaction:(NSDictionary *)query;

@end

@implementation SecurityHandler

//=====Synthesize Decleration
@synthesize delegate;
@synthesize method				= _method;
@synthesize connection          = _connection;
@synthesize receivedData        = _receivedData;
@synthesize URL                 = _URL;

- (id)init  {
    if (self = [super init]) {
        _method				= TRANS_METHOD_POST;
        _statusCode         = -1;
    }
    return self;
}
- (void)sendTransaction:(NSDictionary *)query{
    [self.connection cancel];

    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;

    NSString* webStringURL = [_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
   
    NSMutableURLRequest *request;
    
    switch (_method) {
        case TRANS_METHOD_POST:{
            request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSString *myRequestString = [query JSONRepresentation];
            NSData *requestBodyData = [myRequestString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody: requestBodyData ];
            NSLog(@"----> %@",[query JSONRepresentation]);
            break;
        }
        case TRANS_METHOD_GET:{
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,query]]];
            [request setHTTPMethod:@"GET"];
            break;
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    [connection start];
}

#pragma mark -
#pragma mark - URLConnectionDelegate implementation -
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data                   {
    [self.receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error               {
    NSLog(@"%@" , [error userInfo]);
    
    [SysUtils showMessage:[NSString stringWithFormat:@"%@\n[%ld]",[error localizedDescription],(long)[error code]]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate returnResult:@"" errorCode:-1004 errorMessage:[NSString stringWithFormat:@"Have Error During Processing.[%ld]", (long)[error code]]];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response    {
    _statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        _statusCode   = ((NSHTTPURLResponse *)response).statusCode;
    }
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSLog(@"response[%@] _statusCode[%ld]", [response description], (long)_statusCode);
    //    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    //    NSLog(@"Headers Only : %@",headers);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection                                 {
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(_statusCode == 200){  // 200 ==> Content OK
        
        [delegate returnResult:htmlSTR errorCode:200 errorMessage:@""];
        
    }else{
        [delegate returnResult:@"" errorCode:000 errorMessage:[NSString stringWithFormat:@"Have Error During Processing.[%ld]", (long)_statusCode]];
    }
}

@end

@implementation SercurityConnection

@synthesize handler;

static SercurityConnection			*securityMgr		= nil;

+ (SercurityConnection *)sharedSecurityConnection   {
    if (securityMgr == nil) {
        securityMgr				= [[SercurityConnection alloc] init];
    }
    return securityMgr;
}

- (id)initWithCoder:(NSCoder *)decoder  {
    if (self = [super initWithCoder:decoder]) {
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame       {
    if ((self = [super initWithFrame:frame])) {
        handler = [[SecurityHandler alloc] init];
        super.delegate = handler;
    }
    return self;
}
- (void)setDelegate:(id)aDelegate       {
    if (handler) {
        [super setDelegate:handler];
        handler.delegate = aDelegate;
    }
}
- (id)delegate                          {
    return [handler delegate];
}


#pragma mark - 
#pragma mark - Method Task Process -
- (BOOL)willConnect:(NSString *) url query:(NSDictionary *) query method:(NSInteger) method{
    handler.URL			= url;
    handler.method		= method;
    [handler sendTransaction:query];
    return YES;
}

@end

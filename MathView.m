//
//  MathView.m
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import "MathView.h"
@interface MathView ()<WKNavigationDelegate>
{
    NSDate *date;
}
@property (nonatomic,strong)MathWebView * webView;
@property (nonatomic,copy)void(^callBack)(CGRect frame,NSInteger index);
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)MathRenderEngineType type;
@end
@implementation MathView
- (instancetype)initWithRenderCompleted:(void (^)(CGRect, NSInteger))callBack
                               withHTML:(NSString *)code
                   MathRenderEngineType:(MathRenderEngineType)type
                                  Index:(NSInteger)index{
                        if (self       = [super init]) {
                            self.frame = CGRectZero;
                         self.callBack = callBack;
                            self.index = index;
                            _webView   = [[MathWebView alloc]initWithHTML:code
                                                     MathRenderEngineType:type];
                            self.type  = type;
                        if (self.type == MathRenderEngineTypeMathMLCode) {
                        _webView.ratio = 1.0;
                            }else{
                        _webView.ratio = self.ratio;
                            }
                        
           _webView.navigationDelegate = self;
                       [self addSubview:_webView];
                        }
                        return self;
}
/**
 init

 @param callBack 回调,并返回当前frame以及当前位置index
 @param code Latex code
 @param index 当前位置index
 @return instance
 */
//- (instancetype)initWithRenderCompleted:(void (^)(CGRect,NSInteger))callBack withCode:(NSString *)code Index:(NSInteger)index{
//    if (self = [super init]) {
//        self.frame = CGRectZero;
//        self.callBack = callBack;
//        self.index = index;
//        _webView = [[MathWebView alloc]initWithLaTexCode:code];
//        _webView.ratio = self.ratio;
//        _webView.navigationDelegate = self;
//        [self addSubview:_webView];
//    }
//    return self;
//}
#pragma marks - webviewDelegate
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    date = [NSDate date];
    NSLog(@"开始加载");
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WebKitDiskImageCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //这个方法也可以计算出webView滚动视图滚动的高度
    WS(weakSelf);
    if (self.type == MathRenderEngineTypeMathMLCode) {
        [webView evaluateJavaScript:@"document.body.scrollWidth" completionHandler:^(id _Nullable result,NSError * _Nullable error){
            CGFloat newwidth = [result floatValue] * 1.05 * (weakSelf.ratio);
            [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error){
                CGFloat newHeight = [result floatValue] * (weakSelf.ratio);
                NSLog(@"scrollHeight高度：%.2f",newHeight);
                NSLog(@"scrollWidth宽度：%.2f",newwidth);
                [weakSelf resetWebViewFrameWithHeight:newHeight];
                [weakSelf resetWebViewFrameWithWidth:newwidth];
                weakSelf.callBack(weakSelf.frame,weakSelf.index);
            }];
        }];
    }else{
        [webView evaluateJavaScript:@"document.getElementById(\"mykatex\").offsetWidth" completionHandler:^(id _Nullable result,NSError * _Nullable error){
            CGFloat newwidth = [result floatValue] * 1.05 * (weakSelf.ratio);
            [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error){
                CGFloat newHeight = [result floatValue] * (weakSelf.ratio);
                NSLog(@"scrollHeight高度：%.2f",newHeight);
                NSLog(@"scrollWidth宽度：%.2f",newwidth);
                [weakSelf resetWebViewFrameWithHeight:newHeight];
                [weakSelf resetWebViewFrameWithWidth:newwidth];
                weakSelf.callBack(weakSelf.frame,weakSelf.index);
            }];
        }];
    }
    
    double dateTime = [[NSDate date] timeIntervalSinceDate:date];
    NSLog(@"cost time = %f",dateTime);
}

/**
 重置webview,self高

 @param newheight newheight
 */
- (void)resetWebViewFrameWithHeight:(CGFloat)newheight{
    WS(weakSelf);
    CGRect rect = weakSelf.webView.frame;
    CGRect rect_s = weakSelf.frame;
    rect.size.height = newheight;
    rect_s.size.height = newheight;
    weakSelf.webView.frame = rect;
    weakSelf.frame = rect_s;
}

/**
 重置webview,self宽

 @param newwidth newwidth
 */
- (void)resetWebViewFrameWithWidth:(CGFloat)newwidth{
    WS(weakSelf);
    CGRect rect = weakSelf.webView.frame;
    CGRect rect_s = weakSelf.frame;
    rect.size.width = newwidth;
    rect_s.size.width = newwidth;
    weakSelf.webView.frame = rect;
    weakSelf.frame = rect_s;
}
- (void)dealloc{
    NSLog(@"MathView");
}
@end

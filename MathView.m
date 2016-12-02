//
//  MathView.m
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import "MathView.h"
@interface MathView ()<WKNavigationDelegate>
@property (nonatomic,strong)MathWebView * webView;
@property (nonatomic,copy)void(^callBack)(CGRect frame,NSInteger index);
@property (nonatomic,assign)NSInteger index;
@end
@implementation MathView

/**
 init

 @param callBack 回调,并返回当前frame以及当前位置index
 @param code Latex code
 @param index 当前位置index
 @return instance
 */
- (instancetype)initWithRenderCompleted:(void (^)(CGRect,NSInteger))callBack withCode:(NSString *)code Index:(NSInteger)index{
    if (self = [super init]) {
        self.frame = CGRectZero;
        self.callBack = callBack;
        self.index = index;
        _webView = [[MathWebView alloc]initWithLaTexCode:code];
        _webView.ratio = self.ratio;
        _webView.navigationDelegate = self;
        [self addSubview:_webView];
        self.clipsToBounds = 0;
    }
    return self;
}
#pragma marks - webviewDelegate
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    //这个方法也可以计算出webView滚动视图滚动的高度
    [webView evaluateJavaScript:@"document.getElementById(\"mykatex\").offsetWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat newwidth = [result floatValue] * 1.05 * (self.ratio);
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            CGFloat newHeight = [result floatValue] * (self.ratio);
            NSLog(@"scrollHeight高度：%.2f",newHeight);
            NSLog(@"scrollWidth宽度：%.2f",newwidth);
            [self resetWebViewFrameWithHeight:newHeight];
            [self resetWebViewFrameWithWidth:newwidth];
            self.callBack(self.frame,self.index);
        }];
    }];
}

/**
 重置webview,self高

 @param newheight newheight
 */
- (void)resetWebViewFrameWithHeight:(CGFloat)newheight{
    CGRect rect = _webView.frame;
    CGRect rect_s = self.frame;
    rect.size.height = newheight;
    rect_s.size.height = newheight;
    _webView.frame = rect;
    self.frame = rect_s;
}

/**
 重置webview,self宽

 @param newwidth newwidth
 */
- (void)resetWebViewFrameWithWidth:(CGFloat)newwidth{
    CGRect rect = _webView.frame;
    CGRect rect_s = self.frame;
    rect.size.width = newwidth;
    rect_s.size.width = newwidth;
    _webView.frame = rect;
    self.frame = rect_s;
}
@end

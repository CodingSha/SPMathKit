//
//  MathWebView.m
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import "MathWebView.h"

@implementation MathWebView
- (instancetype)initWithHTML:(NSString *)code MathRenderEngineType:(MathRenderEngineType)type{
    WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc]init];
    // 自适应屏幕宽度js
    NSString *jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=%f, maximum-scale=%f, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);",self.ratio,self.ratio];
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                     forMainFrameOnly:NO];
    // 添加自适应屏幕宽度js调用的方法
    [configer.userContentController addUserScript:wkUserScript];
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configer]) {
        self.type = type;
        [self configerSelf];
        NSString *htmlStr = [self getHTMLString:code];
        [self loadHTMLString:htmlStr baseURL:nil];
    }
    return self;
}
/**
 init

 @param code Latex code
 @return instance
 */
- (instancetype)initWithLaTexCode:(NSString *)code{
    WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc]init];
    // 自适应屏幕宽度js
    NSString *jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=%f, maximum-scale=%f, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);",self.ratio,self.ratio];
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                     forMainFrameOnly:NO];
    // 添加自适应屏幕宽度js调用的方法
    [configer.userContentController addUserScript:wkUserScript];
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configer]) {
        [self configerSelf];
        NSString *htmlStr = [self getHTMLString:code];
        [self loadHTMLString:htmlStr baseURL:nil];
    }
    return self;
}

/**
    配置webview
 */
- (void)configerSelf{
    self.scrollView.bounces = 0;
    self.scrollView.showsVerticalScrollIndicator = 0;
    self.scrollView.showsHorizontalScrollIndicator = 0;
    self.scrollView.scrollEnabled = 0;
}

/**
 修复HTML实际数据

 @param code Latex code
 @return HTML
 */
-(NSString *)getHTMLString:(NSString *)code{
    if (self.type == MathRenderEngineTypeLatexCode) {
        NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SPLatex"
                                                                                            ofType:@"html"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSString *rep = [NSString stringWithFormat:@"render(\"%@\"",code];
        html = [html stringByReplacingOccurrencesOfString:@"render(\"\"" withString:rep];
        html = [html stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        NSLog(@"HTML String is : %@",html);
        return html;
    }
    return code;
}
- (void)dealloc{
    NSLog(@"MathWebView")
}
@end

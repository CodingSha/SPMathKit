//
//  MathWebView.h
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface MathWebView :WKWebView

/**
    scale
 */
@property (nonatomic,assign)CGFloat ratio;

/**
 init func with Latex code

 @param code Latex code
 @return instance
 */
- (instancetype)initWithLaTexCode:(NSString *)code;
@end

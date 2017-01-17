//
//  MathWebView.h
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSInteger,MathRenderEngineType) {
    MathRenderEngineTypeLatexCode = 0,//latex渲染
    MathRenderEngineTypeMathMLCode//MathML渲染
};
@interface MathWebView :WKWebView

/**
    scale
 */
@property (nonatomic,assign)CGFloat ratio;
@property (nonatomic,assign)MathRenderEngineType type;

/**
 init

 @param code HTMLString
 @param type RenderEngineType,include two type.
        tpye MathRenderEngineTypeLatexCode is Latex code
        type MathRenderEngineTypeMathMLCode is MathML code
 @return WKWebview instancetype
 */
- (instancetype)initWithHTML:(NSString *)code
        MathRenderEngineType:(MathRenderEngineType)type;
@end

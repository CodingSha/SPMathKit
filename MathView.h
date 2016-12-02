//
//  MathView.h
//  test
//
//  Created by zkhz on 2016/11/29.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathWebView.h"
@interface MathView : UIView

/**
 scale
 */
@property (nonatomic,assign)CGFloat ratio;

/**
 init func

 @param callBack self
 @param code LaTex Code String
 @return view instance
 */
- (instancetype)initWithRenderCompleted:(void(^)(CGRect frame,NSInteger index))callBack withCode:(NSString *)code Index:(NSInteger)index;
@end

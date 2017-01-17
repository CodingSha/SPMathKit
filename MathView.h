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
 init

 @param callBack self.Frame , element's index
 @param code HTMLString
 @param type MathRenderEngineType
 @param index element's index
 @return MathView instancetype
 */
- (instancetype)initWithRenderCompleted:(void(^)(CGRect frame,NSInteger index))callBack
                               withHTML:(NSString *)code
                   MathRenderEngineType:(MathRenderEngineType)type
                                  Index:(NSInteger)index;
@end

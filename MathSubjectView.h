//
//  MathSubjectView.h
//  test
//
//  Created by zkhz on 2016/12/1.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathSubjectView : UIView

/**
    字体
 */
@property (nonatomic,strong)UIFont *font;

/**
    数据源字符串
 */
@property (nonatomic,copy)NSString *testStr;
@end

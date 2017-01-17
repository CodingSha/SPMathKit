//
//  MathModel.h
//  test
//
//  Created by zkhz on 2016/12/1.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathView.h"
@interface MathModel : NSObject

/**
    mathView
 */
@property (nonatomic,strong)MathView *mathView;

/**
    mathview's frame
 */
@property (nonatomic,assign)CGRect rect;
@end

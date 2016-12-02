//
//  MathSubjectView.m
//  test
//
//  Created by zkhz on 2016/12/1.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import "MathSubjectView.h"
#import "MathView.h"
#import "YYText.h"
#import "UIView+YYAdd.h"
#import "UIImageView+WebCache.h"
#import "MathModel.h"
@interface MathSubjectView ()
@property (nonatomic,strong)YYLabel *label;
@property (nonatomic,assign)NSUInteger renderCount;
@end
@implementation MathSubjectView

/**
 lazy loading

 @return instance
 */
- (YYLabel *)label{
    if (!_label) {
        _label = [YYLabel new];
        _label.userInteractionEnabled = YES;
        _label.numberOfLines = 0;
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _label;
}

/**
 override

 @param frame frame
 @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect rect_s = self.frame;
        rect_s.size.height = 0;
        self.frame = rect_s;
        [self addSubview:self.label];
        self.renderCount = 0;
    }
    return self;
}

/**
 处理数据源并进行渲染

 @param arr 数据源
 */
- (void)typesetMathWithArray:(NSArray *)arr{
    NSMutableArray *arrNew = [NSMutableArray arrayWithArray:arr];
    for (NSInteger i = 0; i < arr.count; i ++) {
        NSString *str = arr[i];
        if ([str hasPrefix:@"math#"]) {
            NSArray *arr_t = [str componentsSeparatedByString:@"#"];
            __block MathView *math = [[MathView alloc]initWithRenderCompleted:^(CGRect frame,NSInteger index) {
                MathModel *model = [[MathModel alloc]init];
                model.mathView = math;
                model.rect = frame;
                [arrNew replaceObjectAtIndex:index withObject:model];
                self.renderCount ++;
                [self typesetWithOriArr:arr andMultiArr:arrNew];
            } withCode:arr_t[1] Index:i];
            math.ratio = 0.6;
            [self addSubview:math];
        }else if([str hasPrefix:@"image#"]){
             NSArray *arr_m = [str componentsSeparatedByString:@"#"];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:arr_m[1]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(0, 0, image.size.width/3, image.size.height/3);
                NSUInteger imageIndex = [arr indexOfObject:[NSString stringWithFormat:@"image#%@",imageURL.absoluteString]];
                [arrNew replaceObjectAtIndex:imageIndex withObject:imageView];
                self.renderCount ++;
                [self typesetWithOriArr:arr andMultiArr:arrNew];
            }];
        }else{
            [arrNew replaceObjectAtIndex:i withObject:str];
            self.renderCount ++;
        }
    }
}

/**
 解析固定协议下的数据字符串为数组

 @param str 符合协议的数据字符串
 @return 数据源数组
 */
- (NSArray *)parserString:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    NSLog(@"%@",arr);
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
    for (NSInteger i = 0; i < newArr.count; i ++) {
        if ([newArr[i] hasPrefix:@"/math#"]||[newArr[i] hasPrefix:@"/image#"]) {
            NSString *newStr = [newArr[i] stringByReplacingOccurrencesOfString:@"/math#" withString:@""];
            NSString *newStr1 = [newStr stringByReplacingOccurrencesOfString:@"/image#" withString:@""];
            [newArr replaceObjectAtIndex:i withObject:newStr1];
        }
    }
    NSLog(@"%@",newArr);
    return newArr;
}

/**
 渲染操作

 @param arr 需要渲染的元数组
 @param arrNew 经过数据处理的可变元数组(渲染对象)
 */
- (void)typesetWithOriArr:(NSArray *)arr andMultiArr:(NSMutableArray *)arrNew{
    if (self.renderCount == arr.count) {
        NSMutableAttributedString *text = [NSMutableAttributedString new];

        for (id obj in arrNew) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *atStr = (NSString *)obj;
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:atStr]];
            }else if ([obj isKindOfClass:[MathModel class]]){
                MathModel *model = (MathModel *)obj;
                MathView *mathView = model.mathView;
                CGRect rect = model.rect;
                [mathView sizeToFit];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:mathView contentMode:0 attachmentSize:rect.size alignToFont:_font alignment:1];
                [text appendAttributedString:attachText];
            }else if ([obj isKindOfClass:[UIImageView class]]){
                UIImageView *imageView = (UIImageView *)obj;
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:0 attachmentSize:imageView.size alignToFont:_font alignment:1];
                [text appendAttributedString:attachText];
            }
        }
        self.label.attributedText = text;
        CGSize size = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
        text.yy_font = _font;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
        self.label.size = layout.textBoundingSize;
        self.label.textLayout = layout;
        CGRect rect_s = self.frame;
        rect_s.size.height = self.label.height;
        self.frame = rect_s;
    }
}

/**
 数据源字符串setter

 @param testStr 数据源字符串
 */
- (void)setTestStr:(NSString *)testStr{
    _testStr = testStr;
    NSArray *arr = [self parserString:self.testStr];
    [self typesetMathWithArray:arr];
}
@end

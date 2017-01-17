//
//  MathSubjectView.m
//  test
//
//  Created by zkhz on 2016/12/1.
//  Copyright © 2016年 zkhz. All rights reserved.
//

#import "MathSubjectView.h"
#import "YYText.h"
#import "UIView+YYAdd.h"
#import "MathModel.h"
@interface MathSubjectView ()
@property (nonatomic,strong)YYLabel *label;
@property (nonatomic,assign)NSUInteger renderCount;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,copy)void(^callBack)(CGFloat height,NSIndexPath *indexPath);
@end
@implementation MathSubjectView

/**
 lazy loading

 @return instance
 */
- (YYLabel *)label{
    if (!_label) {
        WS(weakSelf);
        _label = [[YYLabel alloc]init];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor whiteColor];
        _label.displaysAsynchronously = YES;
        _label.ignoreCommonProperties = YES;
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.frame = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height);
    }
    return _label;
}

/**
 override

 @param frame frame
 @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame withIndexPath:(NSIndexPath *)indexPath MathRenderEngineType:(MathRenderEngineType)type callBack:(void (^)(CGFloat, NSIndexPath *))callBack{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.indexPath = indexPath;
        self.callBack = callBack;
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
    WS(weakSelf);
    NSMutableArray *arrNew = [NSMutableArray arrayWithArray:arr];
    for (NSInteger i = 0; i < arr.count; i ++) {
        NSString *str = arr[i];
        if ([str hasPrefix:@"math#"]) {
            NSArray *arr_t = [str componentsSeparatedByString:@"#"];
            NSData *data = [[NSData alloc]initWithBase64EncodedString:arr_t[1] options:0];
            NSString *reStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (!data) {
                reStr = arr_t[1];
            }
            MathModel *model = [[MathModel alloc]init];
            MathView *math = [[MathView alloc]initWithRenderCompleted:^(CGRect frame, NSInteger index) {
                                                    MathModel *Model = model;
                                                          Model.rect = frame;
                                         [arrNew replaceObjectAtIndex:index
                                                           withObject:Model];
                                                             weakSelf.renderCount ++;
                                          [weakSelf typesetWithOriArr:arr
                                                          andMultiArr:arrNew];
            }
                                                             withHTML:reStr
                                                 MathRenderEngineType:self.type
                                                                Index:i];
            model.mathView = math;
            math.ratio = 1.0;
            [self addSubview:math];
        }else if([str hasPrefix:@"image#"]){
             NSArray *arr_m = [str componentsSeparatedByString:@"#"];
            NSArray *urls = [arr_m[1] componentsSeparatedByString:@";"];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urls[0]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSUInteger imageIndex = [arr indexOfObject:[NSString stringWithFormat:@"image#%@;%@",imageURL.absoluteString,urls[1]]];
                if (image) {
                    [arrNew replaceObjectAtIndex:imageIndex withObject:image];
                }else{
                    [arrNew replaceObjectAtIndex:imageIndex withObject:@""];
                }
                weakSelf.renderCount ++;
                [weakSelf typesetWithOriArr:arr andMultiArr:arrNew];
            }];
        }else{
            [arrNew replaceObjectAtIndex:i withObject:str];
            self.renderCount ++;
            [self typesetWithOriArr:arr andMultiArr:arrNew];
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //生成属性字符串
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
                }else if ([obj isKindOfClass:[UIImage class]]){
                    UIImage *image = (UIImage *)obj;
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:0 attachmentSize:image.size alignToFont:_font alignment:1];
                    [text appendAttributedString:attachText];
                }
            }
            text.yy_font = _font;
            text.yy_color = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            //创建文本容器
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(self.width, CGFLOAT_MAX);
            container.maximumNumberOfRows = 0;
            //生成排版结果
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.size = layout.textBoundingSize;
                self.label.textLayout = layout;
                self.callBack(self.label.height + 2,self.indexPath);
            });
        });
    }
}

/**
 数据源字符串setter

 @param testStr 数据源字符串
 */
- (void)setTestStr:(NSString *)testStr{
    WS(weakSelf);
    _testStr = testStr;
    NSArray *arr = [weakSelf parserString:weakSelf.testStr];
    [weakSelf typesetMathWithArray:arr];
}

@end

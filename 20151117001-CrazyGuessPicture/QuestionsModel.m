//
//  QuestionsModel.m
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/19.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "QuestionsModel.h"

@implementation QuestionsModel
/**
 *  通过字典初始化该实体类（对象方法）
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

/**
 *  通过字典初始化该实体类（类方法）
 */
+ (instancetype)questionsWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

/**
 *  获取对象列表数据（对象方法）
 */
- (NSArray *)questionArray {
    NSArray *questions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
    
    NSMutableArray *questionArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in questions) {
        [questionArray addObject:[QuestionsModel questionsWithDictionary:dictionary]];
    }
    
    return questionArray;
}

/**
 *  获取对象列表数据（类方法）
 */
+ (NSArray *)questionArray {
    return [[self alloc] questionArray];
}

/**
 *  复写options的setter方法，在这里对备选答案数组进行乱序
 */
- (void)setOptions:(NSArray *)options {
    // 使用数组的排序方法做乱序
    _options = [options sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        // 用2位数生成一个随机数
        int random = arc4random_uniform(2);
        
        // 判断随机数是否为0
        if (random) {
            return [obj1 compare:obj2 options:0];
        } else {
            return [obj2 compare:obj1 options:0];
        }
    }];
}

/**
 *  复写并创建图片试图
 */
- (UIImage *)iconImage {
    if (nil == _iconImage) {
        _iconImage = [UIImage imageNamed:self.icon];
    }
    
    return _iconImage;
}

/**
 *  实现属性类的description方法，打印属性
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {answer:%@, icon:%@, title:%@, options:%@}", self.class, self, self.answer, self.icon, self.title, self.options];
}

@end

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
 *  实现属性类的description方法，打印属性
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {answer:%@, icon:%@, title:%@, options:%@}", self.class, self, self.answer, self.icon, self.title, self.options];
}

@end

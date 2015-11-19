//
//  QuestionsModel.m
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/19.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "QuestionsModel.h"

@implementation QuestionsModel

- (instancetype)initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

+ (instancetype)questionsWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (NSArray *)questionArray {
    NSString *questionPath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    NSArray *questions = [NSArray arrayWithContentsOfFile:questionPath];
    
    NSMutableArray *questionArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in questions) {
        [questionArray addObject:[self initWithDictionary:dictionary]];
    }
    
    return questionArray;
}

+ (NSArray *)questionArray {
    return [[QuestionsModel alloc] questionArray];
}


@end

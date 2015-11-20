//
//  QuestionsModel.h
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/19.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionsModel : NSObject

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *options;

/**
 *  通过字典初始化该实体类（对象方法）
 */
- (instancetype)initWithDictionary:(NSDictionary *) dictionary;

/**
 *  通过字典初始化该实体类（类方法）
 */
+ (instancetype)questionsWithDictionary:(NSDictionary *)dictionary;

/**
 *  获取对象列表数据（对象方法）
 */
- (NSArray *)questionArray;

/**
 *  获取对象列表数据（类方法）
 */
+ (NSArray *)questionArray;

@end

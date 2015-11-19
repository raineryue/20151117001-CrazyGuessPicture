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

- (instancetype)initWithDictionary:(NSDictionary *) dictionary;

+ (instancetype)questionsWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)questionArray;
+ (NSArray *)questionArray;

@end

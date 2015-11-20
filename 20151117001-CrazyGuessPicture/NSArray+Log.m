//
//  NSArray+Log.m
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/20.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

/**
 *  实现NSArray的描述方法，用来打印元素
 */
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *descriptionString = [NSMutableString stringWithString:@"(\n"];
    
    for (id obj in self) {
        [descriptionString appendFormat:@"\t%@,\n", obj];
    }
    
    [descriptionString appendString:@")\n"];
    
    return descriptionString;
}

@end

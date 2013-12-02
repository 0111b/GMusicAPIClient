//
//  GMMappingItem.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMMappingItem.h"

@implementation GMMappingItem
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    NSString *newKey = key;
    if ([key isEqualToString:@"id"]) {
        newKey = @"itemID";
    }
    [super setValue:value forKey:newKey];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //    GMLog(@"invalidKey :%@",key);
}
@end

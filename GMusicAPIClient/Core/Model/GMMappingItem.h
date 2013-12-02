//
//  GMMappingItem.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMMappingItem : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *itemID;
@end

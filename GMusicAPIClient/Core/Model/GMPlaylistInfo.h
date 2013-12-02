//
//  GMPlaylistInfo.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMMappingItem.h"
/*
 {
 accessControlled = 0;
 creationTimestamp = 1370415500047900;
 deleted = 0;
 id = "dce772cc-42a3-4908-80c5-125a983129d3";
 kind = "sj#playlist";
 lastModifiedTimestamp = 1370705546117936;
 name = "Female vocal";
 ownerName = "Alexandr Goncharov";
 ownerProfilePhotoUrl = "http://lh5.googleusercontent.com/-4_l5FZyIlQI/AAAAAAAAAAI/AAAAAAAAF3Q/6o768iuxRbA/photo.jpg";
 recentTimestamp = 1370705545893000;
 shareToken = "AMaBXykXL--ALIratXX4OuEwEGq1eZa5--fbmS9RgW0VFabGwDv-8_XOwIoCjfyBe9j9ZX3pGIEu7csrCCsB75UbOBLuKa6ebA==";
 type = "USER_GENERATED";
 }
 */

@interface GMPlaylistInfo : GMMappingItem

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *kind;

@end

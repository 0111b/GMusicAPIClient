//
//  GMLog.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/1/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#ifndef GMusicAPIClient_GMLog_h
#define GMusicAPIClient_GMLog_h

#define GMLog(fmt, ...) NSLog((@"%d:%s " fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)

#endif

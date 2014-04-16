//
//  GVUbiquitousObserver.h
//
//  Created by admin on 14.03.14.
//  Copyright (c) 2014 Goncharov Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GVUbiquitousObserverUpdateFromICloudComplete;

@interface GVUbiquitousObserver : NSObject <NSCopying>

@property (nonatomic, strong, readonly) NSUbiquitousKeyValueStore *iCloudStore;

+ (instancetype)shared;

- (BOOL)synchronized;
- (BOOL)reset;

@end

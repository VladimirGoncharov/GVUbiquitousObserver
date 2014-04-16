//
//  GVUbiquitousObserver.m
//
//  Created by admin on 14.03.14.
//  Copyright (c) 2014 Goncharov Vladimir. All rights reserved.
//

#import "GVUbiquitousObserver.h"

NSString *const GVUbiquitousObserverUpdateFromICloudComplete    = @"__GVUbiquitousObserverUpdateFromICloudComplete__";

static GVUbiquitousObserver *ubiquitousObserver                 = nil;

@implementation GVUbiquitousObserver

@synthesize iCloudStore = _iCloudStore;

+ (instancetype)shared
{
    if (!ubiquitousObserver)
    {
        ubiquitousObserver          = [self new];
    }
    return ubiquitousObserver;
}

- (id)init
{
    static dispatch_once_t onceTokenUbiquitousObserver;
    dispatch_once(&onceTokenUbiquitousObserver, ^{
        if (NSClassFromString(@"NSUbiquitousKeyValueStore"))
        {
            ubiquitousObserver            = [super init];
            if (ubiquitousObserver)
            {
                [[NSNotificationCenter defaultCenter] addObserver:ubiquitousObserver
                                                         selector:@selector(ubiquitousKeyValueStoreDidChange:)
                                                             name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                           object:self.iCloudStore];
                [self.iCloudStore synchronize];
            }
        }
        else
        {
#if DEBUG
            NSLog(@"%s - [error]iCloud not availavle", __func__);
#endif
        }
    });
    
    return ubiquitousObserver;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self shared];
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:ubiquitousObserver];
}

#pragma mark - accessory

- (NSUbiquitousKeyValueStore *)iCloudStore
{
    if (!_iCloudStore)
    {
        if (NSClassFromString(@"NSUbiquitousKeyValueStore"))
        {
            _iCloudStore  = [NSUbiquitousKeyValueStore defaultStore];
        }
        else
        {
#if DEBUG
            NSLog(@"iCloud not available");
#endif
        }
    }
    return _iCloudStore;
}

#pragma mark - update data from iCloud

- (void)ubiquitousKeyValueStoreDidChange:(NSNotification *)notif
{
//    получаем ключи и пишем код
//    пример
//    NSArray *changedKeys                = [[notif userInfo] objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
//    for (NSString *key in changedKeys)
//    {
//        if ([key isEqualToString:@"key"])
//        {
//            //тут пишем код
//        }
//        else if ([key isEqualToString:@"key2"])
//        {
//            //тут пишем код
//        }
//    }
    
    //все ok. уведомляем
    [[NSNotificationCenter defaultCenter] postNotificationName:FSUbiquitousObserverUpdateFromICloudComplete
                                                        object:notif];
}

#pragma mark - update data in iCloud

- (BOOL)synchronized
{
//    сохраняем данные в icloud
//    пример
//    [self.iCloudStore setString:@"string"
//                         forKey:@"key"];
//    [self.iCloudStore setDouble:1.0f
//                         forKey:@"key2"];
    
    //синхронизируемся
    return [self.iCloudStore synchronize];
}

- (BOOL)reset
{
//    удаляем и сбрасываем данные
//    пример
//    [self.iCloudStore setString:@""
//                         forKey:@"key"];
//    [self.iCloudStore setDouble:0.0f
//                         forKey:@"key2"];
    
    //синхронизируемся
    return [self.iCloudStore synchronize];
}

@end

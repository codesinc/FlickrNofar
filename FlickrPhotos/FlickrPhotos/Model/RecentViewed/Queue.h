// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Limited first-in-first-out queue.
@interface Queue<ObjectType> : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes queue with \c capacity.
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

/// Adds the given \c object to this instance. When the number of elements exceeds the given capacity,
/// the first inserted object is deleted.
- (void)addObject:(ObjectType)object;

/// Number of elements in this instance.
@property (readonly, nonatomic) NSUInteger count;

/// Returns elements in this instance, \c objects are ordered in reversed order they were inserted.
@property (strong, nonatomic) NSArray<ObjectType> * objects;

@end

NS_ASSUME_NONNULL_END

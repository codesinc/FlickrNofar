// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol to be implemented by objects representing a place.
@protocol Place <NSObject>

/// Country name.
@property (readonly, nonatomic) NSString *country;

/// City name.
@property (readonly, nonatomic) NSString *city;

/// Region name.
@property (readonly, nonatomic) NSString *region;

@end

NS_ASSUME_NONNULL_END

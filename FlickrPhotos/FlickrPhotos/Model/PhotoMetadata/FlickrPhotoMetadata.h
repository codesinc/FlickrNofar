// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Immutable object that represents Flickr photo metadata.
@interface FlickrPhotoMetadata : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with the given \c url.
- (instancetype)initWithUrl:(NSURL *)url NS_DESIGNATED_INITIALIZER;

/// URL of the image represented by this object.
@property (strong, readonly, nonatomic) NSURL *url;

@end

NS_ASSUME_NONNULL_END

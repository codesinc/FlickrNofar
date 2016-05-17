// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPhotoMetadata;

/// Class responsible for saving and loading Flickr photos metadata.
@interface FlickrPhotoMetadataSaver : NSObject

/// Persistently stores the given \c metadata.
+ (void)saveMetadata:(NSArray<FlickrPhotoMetadata *> *)metadata;

/// Retrieves the currently stored metadata from the persistent storage.
+ (NSArray<FlickrPhotoMetadata *> *)storedMetadata;

@end

NS_ASSUME_NONNULL_END

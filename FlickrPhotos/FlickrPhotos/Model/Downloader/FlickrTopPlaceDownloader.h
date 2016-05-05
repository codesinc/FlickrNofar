// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPlacePhotoMetadata;

/// Completion block that executes in the end of the top places list download.
typedef void(^TopPlacesCompletionBlock)(NSArray<FlickrPlacePhotoMetadata *> *);

/// Immutable object that represents a Flickr top places downloader.
@interface FlickrTopPlaceDownloader : NSObject

/// Retrieves content of top places. Upon completion, the given \c completion block
/// is called.
- (void)fetchPlaces:(TopPlacesCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END

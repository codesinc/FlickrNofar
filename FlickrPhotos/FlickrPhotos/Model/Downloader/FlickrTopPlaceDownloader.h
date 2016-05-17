// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPlaceMetadata;

/// Mapping of countries to corresponding ordered collections of Flickr place metadata.
typedef NSDictionary<NSString *, NSArray<FlickrPlaceMetadata *> *> FlickrPlaceMetadataDictionary;

/// Mutable mapping of countries to corresponding ordered collections of Flickr place metadata.
typedef NSMutableDictionary<NSString *,
                            NSMutableArray<FlickrPlaceMetadata *> *> MutableFlickrPlaceMetadataDictionary;

/// Completion block that executes in the end of the top places list download.
/// Keys in dictionary represent country name and the values represent places.
typedef void(^TopPlacesCompletionBlock)(FlickrPlaceMetadataDictionary *);

/// Immutable object that represents a Flickr top places downloader.
@interface FlickrTopPlaceDownloader : NSObject

/// Retrieves content of top places. Upon completion, the given \c completion block
/// is called.
- (void)fetchPlaces:(TopPlacesCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END

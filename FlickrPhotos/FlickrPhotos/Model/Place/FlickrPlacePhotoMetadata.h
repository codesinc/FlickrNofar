// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@class FlickrPhotoMetadata;

/// Immutable object that represents a Flickr place metadata.
@interface FlickrPlacePhotoMetadata : NSObject <Place>

- (instancetype)init NS_UNAVAILABLE;

///Initializes with a given \c country, \c city, \c region and \c photos.
- (instancetype)initWithPlaceID:(id)placeId
                        country:(NSString *)country
                           city:(NSString *)city
                         region:(NSString *)region NS_DESIGNATED_INITIALIZER;

/// Flickr place ID.
@property (strong, readonly, nonatomic) id placeId;

@end

NS_ASSUME_NONNULL_END

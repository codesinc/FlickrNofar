// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

/// Immutable object that represents a Flickr place.
@interface FlickrPlaceMetadata : NSObject<Place>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with the given \c country, \c city and \c region.
- (instancetype)initWithPlaceID:(id)placeId
                        country:(NSString *)country
                           city:(NSString *)city
                         region:(NSString *)region NS_DESIGNATED_INITIALIZER;

/// Flickr place ID represented by this object.
@property (strong, readonly, nonatomic) id placeId;

@end

NS_ASSUME_NONNULL_END

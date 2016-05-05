// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPlacePhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPlacePhotoMetadata ()

/// Country name.
@property (strong, readwrite, nonatomic) NSString *country;

/// City name.
@property (strong, readwrite, nonatomic) NSString *city;

/// Region name.
@property (strong, readwrite, nonatomic) NSString *region;

@end

@implementation FlickrPlacePhotoMetadata

- (instancetype)initWithPlaceID:(id)placeId
                        country:(NSString *)country
                           city:(NSString *)city
                         region:(NSString *)region {
  if (self = [super init]) {
    _placeId = placeId;
    _country = country;
    _city = city;
    _region = region;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END

// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPlaceMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPlaceMetadata()

/// Country name.
@property (strong, readwrite, nonatomic) NSString *country;

/// City name.
@property (strong, readwrite, nonatomic) NSString *city;

/// Region name.
@property (strong, readwrite, nonatomic) NSString *region;

@end

@implementation FlickrPlaceMetadata

- (instancetype)initWithPlaceID:(id)placeId
                        country:(NSString *)country
                           city:(NSString *)city
                         region:(NSString *)region {
  assert(placeId != nil);
  assert(country != nil);
  assert(city != nil);
  assert(region != nil);
  if (self = [super init]) {
    _placeId = placeId;
    _country = country;
    _city = city;
    _region = region;
  }
  return self;
}

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (BOOL)isEqual:(FlickrPlaceMetadata *)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[FlickrPlaceMetadata class]]) {
    return NO;
  }
  FlickrPlaceMetadata *other = (FlickrPlaceMetadata *)object;
  return [self.country isEqualToString:other.country] &&
          [self.city isEqualToString:other.city] &&
          [self.region isEqualToString:other.region] &&
          [self.placeId isEqual:other.placeId];
}

- (NSUInteger)hash {
  return self.country.hash ^ self.city.hash ^ self.region.hash;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %p, placeId: %@, country: %@, city: %@, region: %@>",
      [self class], self, self.placeId, self.country, self.city, self.region];
}

@end

NS_ASSUME_NONNULL_END

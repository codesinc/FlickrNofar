// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrTopPlaceDownloader.h"

#import "FlickrFetcher.h"
#import "FlickrMetadataDownloader.h"
#import "FlickrPlaceMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrTopPlaceDownloader()

/// Downloader of Flickr top places from a given URL.
@property (strong, nonatomic) FlickrMetadataDownloader *downloader;

@end

@implementation FlickrTopPlaceDownloader

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.downloader = [[FlickrMetadataDownloader alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Public API
#pragma mark -

- (void)fetchPlaces:(TopPlacesCompletionBlock)completion {
  CompletionBlock extractTopPlacesData = ^(NSDictionary *data) {
    NSArray *places = [data valueForKeyPath:FLICKR_RESULTS_PLACES];
    if (!places.count) {
      NSLog(@"No top places available.");
      return;
    }
    
    MutableFlickrPlaceMetadataDictionary *topPlaces =
        [[NSMutableDictionary alloc] initWithCapacity:places.count];
    for (NSDictionary *place in places) {
      NSString *details = [place valueForKeyPath:FLICKR_PLACE_NAME];
      FlickrPlaceMetadata *placeMetadata =
          [[FlickrPlaceMetadata alloc] initWithPlaceID:[place valueForKeyPath:FLICKR_PLACE_ID]
                                               country:[self countryFromPlaceInformation:details]
                                                  city:[self cityFromPlaceInformation:details]
                                                region:[self regionFromPlaceInformation:details]];
      NSMutableArray<FlickrPlaceMetadata *> *arrayForKey = [topPlaces objectForKey:placeMetadata.country];
      if (!arrayForKey) {
        arrayForKey = [[NSMutableArray alloc] init];
        [arrayForKey addObject:placeMetadata];
        [topPlaces setObject:arrayForKey forKey:placeMetadata.country];
      } else {
        [arrayForKey addObject:placeMetadata];
        [topPlaces setObject:arrayForKey forKey:placeMetadata.country];
      }
    }
    completion([FlickrTopPlaceDownloader deepCopy:topPlaces]);
  };
  
  [self.downloader retrieveFromURL:[FlickrFetcher URLforTopPlaces]
                 callingCompletion:extractTopPlacesData];
}

+ (FlickrPlaceMetadataDictionary *)deepCopy:(MutableFlickrPlaceMetadataDictionary *)places {
  NSMutableDictionary<NSString *, NSArray<FlickrPlaceMetadata *> *> *mapping =
      [[NSMutableDictionary alloc] initWithCapacity:places.count];
  for (NSString *country in places.allKeys) {
    mapping[country] = [places[country] copy];
  }
  return [mapping copy];
}

- (NSString *)cityFromPlaceInformation:(NSString *)placeInformation {
  NSArray *details = [placeInformation componentsSeparatedByString:@","] ;
  return [details.firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)countryFromPlaceInformation:(NSString *)placeInformation {
  NSArray *details = [placeInformation componentsSeparatedByString:@","];
  return [details.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)regionFromPlaceInformation:(NSString *)placeInformation {
  NSArray *details = [placeInformation componentsSeparatedByString:@","];
  return [details[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

NS_ASSUME_NONNULL_END

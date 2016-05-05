// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrTopPlaceDownloader.h"

#import "FlickrFetcher.h"
#import "FlickrMetadataDownloader.h"
#import "FlickrPlacePhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrTopPlaceDownloader()

/// Downloader of Flickr top places from a given URL.
@property (strong, nonatomic) FlickrMetadataDownloader *downloader;

@end

@implementation FlickrTopPlaceDownloader

- (instancetype)init {
  if (self = [super init]) {
    self.downloader =[[FlickrMetadataDownloader alloc] init];
  }
  return self;
}

- (void)fetchPlaces:(TopPlacesCompletionBlock)completion {
  CompletionBlock extractTopPlacesData = ^(NSDictionary *data) {
    NSArray *places = [data valueForKeyPath:FLICKR_RESULTS_PLACES];
    if (!places.count) {
      NSLog(@"No top places available");
      return;
    }
    
     NSMutableArray<FlickrPlacePhotoMetadata *> *downloadedPlaces =
        [NSMutableArray<FlickrPlacePhotoMetadata *> arrayWithCapacity:places.count];
    for (NSDictionary *place in places) {
      FlickrPlacePhotoMetadata *placeMetadata =
          [[FlickrPlacePhotoMetadata alloc] initWithPlaceID:[place valueForKeyPath:FLICKR_PLACE_ID]
                                                country:@"" city:@"" region:@""];
      [downloadedPlaces addObject:placeMetadata];
    }
    completion([downloadedPlaces copy]);
  };
  
  NSURL *topPlacesURL = [FlickrFetcher URLforTopPlaces];
  [self.downloader retrieveFromURL:topPlacesURL callingCompletion:extractTopPlacesData];
}

@end

NS_ASSUME_NONNULL_END

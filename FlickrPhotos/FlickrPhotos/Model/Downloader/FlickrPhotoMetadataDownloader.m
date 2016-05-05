// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoMetadataDownloader.h"

#import "FlickrFetcher.h"
#import "FlickrMetadataDownloader.h"
#import "FlickrPhotoMetadata.h"
#import "FlickrPlacePhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoMetadataDownloader()

/// Downloader of photos metadata from URL of a given place.
@property (strong, nonatomic) FlickrMetadataDownloader *downloader;

@end

@implementation FlickrPhotoMetadataDownloader

- (instancetype)init {
  if (self = [super init]) {
    self.downloader = [[FlickrMetadataDownloader alloc] init];
  }
  return self;
}

- (void)fetchPhotoMetadataFromPlaceMetadata:(FlickrPlacePhotoMetadata *)metadata
                   maxNumberOfPhotoMetadata:(int)maxNumberOfPhotoMetadata
                                 completion:(PhotoMetadataCompletionBlock)completion {
  assert(maxNumberOfPhotoMetadata > 0);
  CompletionBlock extractPhotoMetadata = ^(NSDictionary *data) {
    NSArray<NSDictionary *> *photos = [data valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    if (!photos.count) {
      NSLog(@"No photos available for this place");
      return;
    }
    
    NSMutableArray<FlickrPhotoMetadata *> *photosMetadata =
    [[NSMutableArray<FlickrPhotoMetadata *> alloc] initWithCapacity:photos.count];
    for (NSDictionary *metadata in photos) {
      NSURL *photoURL =
          [FlickrFetcher URLforPhoto:metadata format:FlickrPhotoFormatLarge];
      [photosMetadata addObject:[[FlickrPhotoMetadata alloc] initWithUrl:photoURL]];
    }
    completion([photosMetadata copy]);
  };
  
  NSURL *photoMetadataURL = [FlickrFetcher URLforPhotosInPlace:metadata.placeId
                                                    maxResults:maxNumberOfPhotoMetadata];
  [self.downloader retrieveFromURL:photoMetadataURL callingCompletion:extractPhotoMetadata];
}

@end

NS_ASSUME_NONNULL_END

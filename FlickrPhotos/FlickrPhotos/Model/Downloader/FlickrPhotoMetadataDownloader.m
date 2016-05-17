// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoMetadataDownloader.h"

#import "FlickrFetcher.h"
#import "FlickrMetadataDownloader.h"
#import "FlickrPhotoMetadata.h"
#import "FlickrPlaceMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotoMetadataDownloader()

/// Downloader of photos metadata from URL of a given place.
@property (strong, nonatomic) FlickrMetadataDownloader *downloader;

@end

@implementation FlickrPhotoMetadataDownloader

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.downloader = [[FlickrMetadataDownloader alloc] init];
  }
  return self;
}

- (void)fetchPhotoMetadataFromPlaceMetadata:(FlickrPlaceMetadata *)metadata
                   maxNumberOfPhotoMetadata:(int)maxNumberOfPhotoMetadata
                                 completion:(PhotoMetadataCompletionBlock)completion {
  assert(maxNumberOfPhotoMetadata > 0);
  CompletionBlock extractPhotoMetadata = ^(NSDictionary *data) {
    NSArray<NSDictionary *> *photoMetadata = [data valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    if (!photoMetadata.count) {
      NSLog(@"No photos available for this place.");
      return;
    }
    NSMutableArray<FlickrPhotoMetadata *> *flickrMetadata =
        [[NSMutableArray alloc] initWithCapacity:photoMetadata.count];
    for (NSDictionary *data in photoMetadata) {
      FlickrPhotoMetadata *photo =
          [[FlickrPhotoMetadata alloc] initWithUrl:[FlickrFetcher URLforPhoto:data
                                            format:FlickrPhotoFormatLarge]
                                             title:[data valueForKeyPath:FLICKR_PHOTO_TITLE]
                                       description:[data valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]];
      [flickrMetadata addObject:photo];
    }
    completion([flickrMetadata copy]);
  };
  
  NSURL *photoMetadataURL = [FlickrFetcher URLforPhotosInPlace:metadata.placeId
                                                    maxResults:maxNumberOfPhotoMetadata];
  [self.downloader retrieveFromURL:photoMetadataURL callingCompletion:extractPhotoMetadata];
}

@end

NS_ASSUME_NONNULL_END

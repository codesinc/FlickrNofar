// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrMetadataDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrMetadataDownloader

- (void)retrieveFromURL:(NSURL *)url callingCompletion:(CompletionBlock)completion {
  dispatch_queue_t fetchQueue = dispatch_queue_create("Flickr fetcher", NULL);
  dispatch_async(fetchQueue, ^{
    NSDictionary *data = [self flickrDataFromURL:url];
    if (data) {
      completion([data copy]);
    }
  });
}

- (NSDictionary *)flickrDataFromURL:(NSURL *)url {
  NSData *json = [NSData dataWithContentsOfURL:url];
  NSError *error;
  NSDictionary *flickrData = [NSJSONSerialization JSONObjectWithData:json
                                                             options:0
                                                               error:&error];
  if (!flickrData) {
    NSLog(@"Error fetching data from URL %@: %@\n", url, [error localizedDescription]);
  }
  return flickrData;
}

@end

NS_ASSUME_NONNULL_END

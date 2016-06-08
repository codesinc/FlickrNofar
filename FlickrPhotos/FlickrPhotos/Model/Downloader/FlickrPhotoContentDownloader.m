// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoContentDownloader.h"

#import <UIKit/UIKit.h>

#import "FlickrMetadataDownloader.h"
#import "FlickrPhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPhotoContentDownloader

- (void)fetchImageFromMetaData:(FlickrPhotoMetadata *)metadata
                    completion:(PhotoCompletionBlock)completion {
  NSURLRequest *request = [NSURLRequest requestWithURL:metadata.url];
  NSURLSessionConfiguration *configuration =
      [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSString *errorMessage = @"Error while trying to download data from url %@: %@";
  NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                  completionHandler:^(NSURL * _Nullable path,
                                                                      NSURLResponse *response,
                                                                      NSError * _Nullable error) {
                                                    if (!error) {
                                                      if ([request.URL isEqual:metadata.url]) {
                                                        NSData *data =
                                                            [NSData dataWithContentsOfURL:path];
                                                        completion([UIImage imageWithData:data]);
                                                      }
                                                    }
                                                    else {
                                                      NSLog(errorMessage, request.URL, error);
                                                    }
                                                  }];
  [task resume];
}

@end

NS_ASSUME_NONNULL_END

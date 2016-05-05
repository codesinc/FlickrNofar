// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPhotoMetadata

- (instancetype)initWithUrl:(NSURL *)url {
  if (self = [super init]) {
    _url = url;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END

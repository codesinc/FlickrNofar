// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPhotoMetadata;

/// View controller that updates its image view with a given image content dwonloaded from Flickr.
@interface ImageViewController : UIViewController

/// Metadata of image depicted by this instance.
@property (strong, nonatomic) FlickrPhotoMetadata *photoMetadata;

@end

NS_ASSUME_NONNULL_END

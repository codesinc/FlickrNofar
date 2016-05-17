// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPhotoMetadata;

@class UIImage;

/// Completion block that executes in the end of the image content download.
typedef void(^PhotoCompletionBlock)(UIImage *);

/// Immutable object that represents a Flickr photo content downloader.
@interface FlickrPhotoContentDownloader : NSObject

/// Retrieves the photo content from the given \c metadata.
/// Upon completion, the given \c completion block is called.
- (void)fetchImageFromMetaData:(FlickrPhotoMetadata *)metadata
                    completion:(PhotoCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END

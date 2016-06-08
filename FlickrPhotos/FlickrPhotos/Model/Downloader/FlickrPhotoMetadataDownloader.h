// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPlaceMetadata;

@class FlickrPhotoMetadata;

/// Completion block that executes in the end of the image metadata download.
typedef void(^PhotoMetadataCompletionBlock)(NSArray<FlickrPhotoMetadata *> *);

/// Immutable object that represents a Flickr photo metadata downloader.
@interface FlickrPhotoMetadataDownloader : NSObject

/// Retrieves \c NSDictionary photos content of a given place \c metadata.
/// \c maxNumberOfPhotoMetadata limits the number of retrieved photo metadata.
/// Upon completion, the given \c completion is called.
- (void)fetchPhotoMetadataFromPlaceMetadata:(FlickrPlaceMetadata *)metadata
                   maxNumberOfPhotoMetadata:(int)maxNumberOfPhotoMetadata
                                 completion:(PhotoMetadataCompletionBlock)completion;


@end

NS_ASSUME_NONNULL_END

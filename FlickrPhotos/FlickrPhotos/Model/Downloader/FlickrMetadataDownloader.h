// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Completion block that executes in the end of the download.
/// \c NSDictionary is Flickr retrieved format.
typedef void(^CompletionBlock)(NSDictionary *);

/// Immutable object that represents Flickr data downloader with a given URL.
@interface FlickrMetadataDownloader : NSObject

/// Retrieves \c NSDictionary content from the given url. Upon completion, the given
/// \c completionBlock is called.
- (void)retrieveFromURL:(NSURL *)url callingCompletion:(CompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END

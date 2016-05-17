// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPhotoMetadata;

/// Class responsible for updating \c UITableView data with \c photosMetadata content.
/// Class implements \c UITableViewDataSource delegate.
@interface PhotosDataSource : NSObject <UITableViewDataSource>

/// Flickr photos metadata that are depicted by \c UITableView.
@property (strong, nonatomic) NSArray<FlickrPhotoMetadata *> *photosMetadata;

@end

NS_ASSUME_NONNULL_END

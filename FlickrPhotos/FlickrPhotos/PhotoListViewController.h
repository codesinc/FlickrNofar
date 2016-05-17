// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPlaceMetadata;

/// View controller that updates \c UITableView to be Flickr photos of a given place.
/// It asynchronously downloads photo metadata from Flickr and presents it as \c UITableView.
/// When user drags view downward it re-downloads photo metadata from Flickr and updates \c UITableView.
/// When it disappears, it stores recent viewed photos metadata queue.
/// When a certain photo is picked, image view controller is loaded and
/// the last viewed photo metadata is added to the recent metadata queue (see previous line).
@interface PhotoListViewController : UITableViewController

/// Current place whose photos are depicted by this instance.
@property (strong, nonatomic) FlickrPlaceMetadata *place;

@end

NS_ASSUME_NONNULL_END

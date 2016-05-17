// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlickrPlaceMetadata;

/// View controller that updates its table view to be Flickr top places.
@interface PlaceListViewController : UITableViewController <UISplitViewControllerDelegate>

/// Flickr top places depicted by this instance. Once set, Table view data is reconstructed.
@property (strong, nonatomic) NSDictionary<NSString *, NSArray<FlickrPlaceMetadata *> *> *places;

@end

NS_ASSUME_NONNULL_END

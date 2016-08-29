// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// View controller that updates its \c UITableView to be Flickr recent viewed photos.
/// When it appears, it samples user defaults to update \c UITableView with recent viewed photos.
/// When a certain photo is picked, image view controller is loaded with the chosen image metadata.
@interface RecentViewedViewController : UITableViewController <UISplitViewControllerDelegate>
@end

NS_ASSUME_NONNULL_END

// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "RecentViewedViewController.h"

#import "FlickrPhotoMetaDataSaver.h"
#import "FlickrPhotoMetadata.h"
#import "ImageViewController.h"
#import "PhotosDataSource.h"
#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentViewedViewController()

/// Flickr photos depicted by this instance.
@property (strong, nonatomic) NSArray<FlickrPhotoMetadata *> *photosMetadata;

/// \c UITableViewDataSource of \c UITableView.
@property (strong, nonatomic) PhotosDataSource *datasource;

@end

@implementation RecentViewedViewController

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
  self.splitViewController.delegate = self;
  self.datasource = [[PhotosDataSource alloc] init];
  self.tableView.dataSource = self.datasource;
}

- (void)viewDidAppear:(BOOL)animated {
  NSArray<FlickrPhotoMetadata *> *recentViewed = [FlickrPhotoMetadataSaver storedMetadata];
  self.datasource.photosMetadata = recentViewed;
  self.photosMetadata = recentViewed;
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *detail;
  ImageViewController *imageViewController;
  if (self.splitViewController.collapsed) {
    detail = [[UINavigationController alloc] init];
    imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showPhoto"];
    [detail setViewControllers:@[imageViewController] animated: NO];
  } else {
    id viewController = self.splitViewController.viewControllers[1];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      detail = (UINavigationController *)viewController;
      imageViewController = [detail.viewControllers firstObject];
    } else {
      imageViewController = viewController;
      detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    }
  }
  [self prepareImageViewController:imageViewController toDisplayPhoto:self.photosMetadata[indexPath.row]];
  [self.splitViewController showDetailViewController:detail sender:self];
}

#pragma mark -
#pragma mark Navigation
#pragma mark -

- (void)prepareImageViewController:(ImageViewController *)viewController
                    toDisplayPhoto:(FlickrPhotoMetadata *)photo {
  viewController.photoMetadata = photo;
  viewController.title = photo.title;
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate
#pragma mark -

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
  return YES;
}

@end

NS_ASSUME_NONNULL_END

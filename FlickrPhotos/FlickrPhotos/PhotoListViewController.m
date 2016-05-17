// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "PhotoListViewController.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoMetaDataSaver.h"
#import "FlickrPhotoMetadata.h"
#import "FlickrPhotoMetadataDownloader.h"
#import "ImageViewController.h"
#import "PhotosDataSource.h"
#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoListViewController()

/// Ordered collection of metadata of Flickr photos depicted by this instance.
@property (strong, nonatomic) NSArray<FlickrPhotoMetadata *> *photosMetadata;

/// \c UITableViewDataSource of \c UITableView.
@property (strong, nonatomic) PhotosDataSource *datasource;

/// Recent viewed photos metadata.
@property (nonatomic) Queue<FlickrPhotoMetadata *> *recentMetadataQueue;

@end

@implementation PhotoListViewController

#pragma mark -
#pragma mark UIViewController
#pragma mark -

/// Maximum number of metadata of recently viewed photos stored by this instance.
static const NSUInteger kNumberOfRecentPhotosMetadata = 20;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(placePhotos)
                forControlEvents:UIControlEventValueChanged];
  self.datasource = [[PhotosDataSource alloc] init];
  self.tableView.dataSource = self.datasource;
  [self loadRecentMetadataToQueue];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [FlickrPhotoMetadataSaver saveMetadata:[self.recentMetadataQueue objects]];
}

- (void)loadRecentMetadataToQueue {
  _recentMetadataQueue = [[Queue alloc] initWithCapacity:kNumberOfRecentPhotosMetadata];
  NSArray<FlickrPhotoMetadata *> *storedMetadata = [FlickrPhotoMetadataSaver storedMetadata];
  for (FlickrPhotoMetadata *metadata in [storedMetadata reverseObjectEnumerator]) {
    [_recentMetadataQueue addObject:metadata];
  }
}

/// Maximum number of photo metadata objects to be fetched per fetch call.
static const NSUInteger kNumberOfDownloadedPhotosMetadata = 50;

- (void)placePhotos {
  [self.refreshControl beginRefreshing];
  PhotoMetadataCompletionBlock onMetadataComplete = ^(NSArray<FlickrPhotoMetadata *> *photosMetadata) {
      dispatch_async(dispatch_get_main_queue(), ^{
      self.photosMetadata = photosMetadata;
      [self.refreshControl endRefreshing];
    });
  };
  
  FlickrPhotoMetadataDownloader *downloader = [[FlickrPhotoMetadataDownloader alloc] init];
  [downloader fetchPhotoMetadataFromPlaceMetadata:self.place
                         maxNumberOfPhotoMetadata:kNumberOfDownloadedPhotosMetadata
                                       completion:onMetadataComplete];
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *detailVC;
  ImageViewController *imageViewController;
  // On the iPhone (compact) the split view controller is collapsed,
  // therefore we need to create the navigation controller and its image view controller.
  if (self.splitViewController.collapsed) {
    detailVC = [[UINavigationController alloc] init];
    imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showPhoto"];
    [detailVC setViewControllers:@[imageViewController] animated: NO];
  } else {
    // If the split view controller shows the detail view already there is no need to create.
    id viewController = self.splitViewController.viewControllers[1];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      detailVC = (UINavigationController *)viewController;
      imageViewController = [detailVC.viewControllers firstObject];
    } else {
      imageViewController = viewController;
      detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    }
  }
  
  [self prepareImageViewController:imageViewController toDisplayPhoto:self.photosMetadata[indexPath.row]];
  // Ask the split view controller to show the detail view.
  // The controller knows on iPhone and iPad how to show the detail.
  [self.splitViewController showDetailViewController:detailVC sender:self];
}

#pragma mark -
#pragma mark Navigation
#pragma mark -

/// Prepares the given ImageViewController to show the given photo.
- (void)prepareImageViewController:(ImageViewController *)viewController
                    toDisplayPhoto:(FlickrPhotoMetadata *)photo {
  viewController.photoMetadata = photo;
  viewController.title = photo.title;
  // Update recent photos queue.
  [self.recentMetadataQueue addObject:photo];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setPhotosMetadata:(NSMutableArray<FlickrPhotoMetadata *> *)photosMetadata {
  _photosMetadata = photosMetadata;
  self.datasource.photosMetadata = photosMetadata;
  [self.tableView reloadData];
}

- (void)setPlace:(FlickrPlaceMetadata *)place {
  _place = place;
  [self placePhotos];
}

@end

NS_ASSUME_NONNULL_END

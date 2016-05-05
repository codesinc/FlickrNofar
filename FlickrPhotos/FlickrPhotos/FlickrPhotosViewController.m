// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotosViewController.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoContentDownloader.h"
#import "FlickrPhotoMetadata.h"
#import "FlickrPhotoMetadataDownloader.h"
#import "FlickrTopPlaceDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhotosViewController() <UIScrollViewDelegate>

/// View depicting the downloaded image.
@property (strong, nonatomic) UIImageView *imageView;

/// Scroll view used to pan the displayed image.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/// View for indicating wait activity during image downloading.
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

/// Image depicted by this instance.
@property (strong, nonatomic, nullable) UIImage *image;

@end

@implementation FlickrPhotosViewController

#pragma mark -
#pragma mark UIViewController
#pragma mark -

/// Maximum zoom scale of scroll view.
static const CGFloat kMaxZoomScale = 2.0;

/// Minimum zoom scale of scroll view.
static const CGFloat kMinZoomScale = 0.2;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self downloadTopPlaces];
  [self configureScrollView];
}

- (void)configureScrollView {
  [self.scrollView addSubview:self.imageView];
  
  self.scrollView.minimumZoomScale = kMinZoomScale;
  self.scrollView.maximumZoomScale = kMaxZoomScale;
  self.scrollView.delegate = self;
  self.scrollView.clipsToBounds = YES;
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
#pragma mark -

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

#pragma mark -
#pragma mark Networking
#pragma mark -

- (void)downloadTopPlaces {
  [self.spinner startAnimating];
  
  TopPlacesCompletionBlock onComplete = ^(NSArray<FlickrPlacePhotoMetadata *> *places) {
    [self placePhotos:places[0]];
  };
  
  FlickrTopPlaceDownloader *downloader = [[FlickrTopPlaceDownloader alloc] init];
  [downloader fetchPlaces:onComplete];
}

- (void)placePhotos:(FlickrPlacePhotoMetadata *)topPlace {
  PhotoMetadataCompletionBlock onMetadataComplete = ^(NSArray<FlickrPhotoMetadata *> *photos) {
    [self imageContent:photos[0]];
  };
  
  FlickrPhotoMetadataDownloader *downloader = [[FlickrPhotoMetadataDownloader alloc] init];
  [downloader fetchPhotoMetadataFromPlaceMetadata:topPlace
                         maxNumberOfPhotoMetadata:1
                                       completion:onMetadataComplete];
}

- (void)imageContent:(FlickrPhotoMetadata *)photo {
  // During downloading clear image.
  self.image = nil;
  
  PhotoCompletionBlock onComplete = ^(UIImage *image) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.image = image;
    });
  };
  
  [[[FlickrPhotoContentDownloader alloc] init] fetchPhotoContent:photo completion:onComplete];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] init];
  }
  return _imageView;
}

- (nullable UIImage *)image {
  return self.imageView.image;
}

- (void)setImage:(nullable UIImage *)image {
  if (image) {
    [self.spinner stopAnimating];
    self.imageView.image = image;
    
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  } else {
    [self downloadTopPlaces];
  }
}

@end

NS_ASSUME_NONNULL_END

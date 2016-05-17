// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "ImageViewController.h"

#import "FlickrPhotoContentDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController() <UIScrollViewDelegate>

// View depicting the downloaded image.
@property (strong, nonatomic) UIImageView *imageView;

// Scroll view used to pan the displayed image.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// View for indicating wait activity during image downloading.
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Image depicted by this instance.
@property (strong, nonatomic, nullable) UIImage *image;

@end

@implementation ImageViewController

#pragma mark -
#pragma mark - UIViewController
#pragma mark -

// Maximum zoom scale of scroll view.
static const CGFloat kMaxZoomScale = 2.0;

// Minimum zoom scale of scroll view.
static const CGFloat kMinZoomScale = 0.2;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureScrollView];
  [self.spinner startAnimating];
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

- (void)imageContent:(FlickrPhotoMetadata *)metadata {
 // During downloading clear image.
  self.image = nil;
  
  PhotoCompletionBlock onComplete = ^(UIImage *image) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.spinner stopAnimating];
      self.image = image;
    });
  };
  
  FlickrPhotoContentDownloader *downloader = [[FlickrPhotoContentDownloader alloc] init];
  [downloader fetchImageFromMetaData:metadata completion:onComplete];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setPhotoMetadata:(FlickrPhotoMetadata *)photoMetadata {
  _photoMetadata = photoMetadata;
  [self imageContent:_photoMetadata];
}

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
  self.imageView.image = image;
  if (!image) {
    [self.spinner startAnimating];
    return;
  }
  self.scrollView.zoomScale = 1.0;
  self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

@end

NS_ASSUME_NONNULL_END

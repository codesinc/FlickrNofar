// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "PhotosDataSource.h"

#import "FlickrPhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PhotosDataSource

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

/// No photos message.
static NSString * const kNoPhotosMessage = @"No photos";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger numOfSections = 0;
  if (self.photosMetadata.count) {
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    numOfSections = 1;
    tableView.backgroundView = nil;
  } else {
    UILabel *noDataLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,
                                                  tableView.bounds.size.height)];
    noDataLabel.text = kNoPhotosMessage;
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    tableView.backgroundView = noDataLabel;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.photosMetadata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"photoCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  cell = !cell ? [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
      reuseIdentifier:cellIdentifier] : cell;
  FlickrPhotoMetadata *photo = [self.photosMetadata objectAtIndex:indexPath.row];
  cell.textLabel.text = photo.title;
  cell.detailTextLabel.text = photo.photoDescription;
  return cell;
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setPhotosMetadata:(NSMutableArray<FlickrPhotoMetadata *> *)photosMetadata {
  _photosMetadata = photosMetadata;
}
@end

NS_ASSUME_NONNULL_END

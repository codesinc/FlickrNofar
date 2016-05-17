// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoMetadataSaver.h"

#import "FlickrPhotoMetadata.h"
#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPhotoMetadataSaver

/// Key of recent photos in user defaults.
static NSString * const kFlickrPhotoMetadataSaverKey = @"photosMetadata";

+ (void)saveMetadata:(NSArray<FlickrPhotoMetadata *> *)metadata {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[FlickrPhotoMetadataSaver serializedRepresentationFromMetadata:metadata]
               forKey:kFlickrPhotoMetadataSaverKey];
  [defaults synchronize];
}

+ (NSArray<FlickrPhotoMetadata *> *)storedMetadata {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  return [FlickrPhotoMetadataSaver deserializedRepresentation:
          [defaults objectForKey:kFlickrPhotoMetadataSaverKey]];
}

+ (NSArray<NSDictionary *> *)serializedRepresentationFromMetadata:
    (NSArray<FlickrPhotoMetadata *> *)metadatas {
  NSMutableArray<NSDictionary *> *serialized =
      [[NSMutableArray alloc] initWithCapacity:metadatas.count];
  for (FlickrPhotoMetadata *metadata in metadatas) {
    [serialized addObject:[metadata serializedRepresentation]];
  }
  return [serialized copy];
}

+ (NSArray<FlickrPhotoMetadata *> *)deserializedRepresentation:(NSArray<NSDictionary *> *)serialized {
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:serialized.count];
  for (NSDictionary *metadata in serialized) {
    FlickrPhotoMetadata * photoMetadata = [[FlickrPhotoMetadata alloc] initWithDictionary:metadata];
    [photos addObject:photoMetadata];
  }
  return [photos copy];
}

@end

NS_ASSUME_NONNULL_END

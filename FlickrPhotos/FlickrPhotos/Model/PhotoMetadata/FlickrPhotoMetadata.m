// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "FlickrPhotoMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPhotoMetadata

- (instancetype)initWithUrl:(NSURL *)url
                      title:(NSString *)title
                description:(NSString *)description {
  assert(url != nil);
  assert(title != nil);
  assert(description != nil);
  if (self = [super init]) {
    _url = url;
    _title = title;
    if (_title.length == 0) {
      _title = description.length > 0 ? description : @"Unknown";
    }
    _photoDescription = description;
  }
  return self;
}

/// URL key in encoded \c NSDictionary form.
static NSString * const kUrl = @"url";

/// Title key in encoded \c NSDictionary form.
static NSString * const kTitle = @"title";

/// Photo description key in encoded \c NSDictionary form.
static NSString * const kPhotoDescription = @"photoDescription";


- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSString *>*)dictionary {
  if (self = [super init]) {
    _url = [NSURL URLWithString:[dictionary objectForKey:kUrl]];
    _title = [dictionary objectForKey:kTitle];
    _photoDescription = [dictionary objectForKey:kPhotoDescription];
  }
  return self;
}

- (NSDictionary *)serializedRepresentation {
  return @{
           kUrl: self.url.absoluteString,
           kTitle: self.title,
           kPhotoDescription: self.photoDescription
  };
}

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (BOOL)isEqual:(FlickrPhotoMetadata *)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[FlickrPhotoMetadata class]]) {
    return NO;
  }
  return [self.title isEqualToString:object.title] &&
      [self.photoDescription isEqualToString:object.photoDescription] &&
      [self.url isEqual:object.url];
}

- (NSUInteger)hash {
  return self.title.hash ^ self.photoDescription.hash ^ self.url.hash;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %p, url: %@, title: %@, description: %@>",
      [self class], self, [self.url absoluteString], self.title, self.photoDescription];
}

@end

NS_ASSUME_NONNULL_END

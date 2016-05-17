// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Immutable object that represents Flickr photo metadata.
@interface FlickrPhotoMetadata : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with a given \c url, \c title and \c description.
- (instancetype)initWithUrl:(NSURL *)url
                      title:(NSString *)title
                description:(NSString *)description NS_DESIGNATED_INITIALIZER;

/// Initializes with the given \c dictionary. The given \c dictionary must be a valid serialized
/// representation of an object of this class. For example, it might have been created using
/// the \c serializedRepresentation method.
- (instancetype)initWithDictionary:(NSDictionary<NSString *,NSArray *>*)dictionary NS_DESIGNATED_INITIALIZER;

/// Returns a serialized version of the instance.
- (NSDictionary *)serializedRepresentation;

/// URL of the image represented by this object.
@property (strong, readonly, nonatomic) NSURL *url;

/// Title of the image represented by this object.
@property (strong, readonly, nonatomic) NSString *title;

/// Description of an image represented by this object.
@property (strong, readonly, nonatomic) NSString *photoDescription;

@end

NS_ASSUME_NONNULL_END

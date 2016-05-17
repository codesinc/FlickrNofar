// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "Queue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Queue()

/// Internally used collection holding objects of this instance.
@property (strong, nonatomic) NSMutableArray *elements;

// Capacity of queue.
@property (nonatomic) NSUInteger capacity;

@end

@implementation Queue

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithCapacity:(NSUInteger)capacity {
  if (self = [super init]) {
    self.elements = [NSMutableArray arrayWithCapacity:capacity];
    _capacity = capacity;
  }
  return self;
}

#pragma mark -
#pragma mark Dataset operations
#pragma mark -

- (NSUInteger)count {
  return self.elements.count;
}

- (void)addObject:(id)object {
  assert(object);
  assert(self.count <= self.capacity);
  NSUInteger index = [self.elements indexOfObject:object];
  if (index != NSNotFound) {
    [self.elements removeObjectAtIndex:index];
  } else if (self.count == self.capacity) {
    [self.elements removeLastObject];
  }
  [self.elements insertObject:object atIndex:0];
}

- (NSArray *)objects {
  return [self.elements copy];
}

@end

NS_ASSUME_NONNULL_END

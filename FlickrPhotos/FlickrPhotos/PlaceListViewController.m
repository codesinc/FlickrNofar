// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by codesinc.

#import "PlaceListViewController.h"

#import "FlickrPlaceMetadata.h"
#import "FlickrTopPlaceDownloader.h"
#import "ImageViewController.h"
#import "PhotoListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceListViewController()

/// Table view section titles.
@property (strong, nonatomic) NSArray<NSString *> *sectionTitles;

@end

@implementation PlaceListViewController

#pragma mark -
#pragma mark UIViewController
#pragma mark - 

- (void)viewDidLoad {
  [super viewDidLoad];
  [self downloadTopPlaces];

  [self.refreshControl addTarget:self
                          action:@selector(downloadTopPlaces)
                forControlEvents:UIControlEventValueChanged];
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
  self.splitViewController.delegate = self;
}

- (void)downloadTopPlaces {
  TopPlacesCompletionBlock onComplete = ^(NSDictionary<NSString *,
                                          NSArray<FlickrPlaceMetadata *> *> *places) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.sectionTitles =
          [[places allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
      self.places = places;
      [self.refreshControl endRefreshing];
    });
  };
  
  [self.refreshControl beginRefreshing];
  FlickrTopPlaceDownloader *downloader = [[FlickrTopPlaceDownloader alloc] init];
  [downloader fetchPlaces:onComplete];
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sectionTitles.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
  return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSString *sectionTitle = [self.sectionTitles objectAtIndex:section];
  NSArray *sectionPlaces = [self.places objectForKey:sectionTitle];
  return sectionPlaces.count;
}

/// Table view cell identfifier.
static NSString * const kCellIdentfifier = @"placeCell";

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentfifier] ?:
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                             reuseIdentifier:kCellIdentfifier];
  
  FlickrPlaceMetadata *place = [self place:indexPath.section atRow:indexPath.row];
  cell.textLabel.text = place.city;
  cell.detailTextLabel.text = place.region;
  return cell;
}

- (FlickrPlaceMetadata *)place:(NSInteger)section atRow:(NSInteger)row {
  NSString *sectionTitle = [self.sectionTitles objectAtIndex:section];
  NSArray<FlickrPlaceMetadata *> *sectionPlaces = [self.places objectForKey:sectionTitle];
  return [sectionPlaces objectAtIndex:row];
}

#pragma mark -
#pragma mark Navigation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(_Nullable id)sender {
  if (![sender isKindOfClass:[UITableViewCell class]]) {
    return;
  }
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  if (!indexPath) {
    return;
  }
  if (([segue.identifier isEqualToString:@"place photos"]) &&
      ([segue.destinationViewController isKindOfClass:[PhotoListViewController class]])) {
    PhotoListViewController *destination = segue.destinationViewController;
    FlickrPlaceMetadata *chosenPlace =
    [self place:indexPath.section atRow:indexPath.row];
    destination.place = chosenPlace;
    destination.title = [NSString stringWithFormat:@"Photos from %@", chosenPlace.city];
  }
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate
#pragma mark -

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
    ontoPrimaryViewController:(UIViewController *)primaryViewController {
  return YES;
}

- (nullable UIViewController *)splitViewController:(UISplitViewController *)splitViewController
    separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {
  if ([self.navigationController.visibleViewController
      isKindOfClass:[PhotoListViewController class]]) {
    return [[ImageViewController alloc] init];
  } else if ([self.navigationController.visibleViewController
        isKindOfClass:[ImageViewController class]]) {
    return nil;
  }
  return [self.storyboard instantiateViewControllerWithIdentifier:@"showPhoto"];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setPlaces:(NSDictionary *)places {
  _places = places;
  [self.tableView reloadData];
}

@end

NS_ASSUME_NONNULL_END

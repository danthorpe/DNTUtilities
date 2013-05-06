//
//  DNTCoreDataStack.m
//  DNTUtilities
//
//  Created by Daniel Thorpe on 06/05/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import "DNTCoreDataStack.h"

// Exception names
NSString * const DNTCoreDataStack_FailedToMigrateExceptionName = @"Failed to migrate store";
NSString * const DNTCoreDataStack_FailedToCreatePersistentStoreExceptionName = @"Failed to create persistent store";
NSString * const DNTCoreDataStack_FailedToInitialisePersistentStoreExceptionName = @"Failed to initialise persistent store";

@interface DNTCoreDataStack ( /* Private */ )

@property (strong, nonatomic) NSURL *urlForManagedObjectModel;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation DNTCoreDataStack

+ (BOOL)saveContext:(NSManagedObjectContext *)moc andParents:(BOOL)saveParents withError:(NSError **)error {

	// Nothing to save
	if (![moc hasChanges]) return YES;

	// Save the context
	if (![moc save:error])  {
		if (*error) {
			NSLog(@"Failed to save to data store: %@", [*error localizedDescription]);
			NSArray *detailedErrors = [[*error userInfo] objectForKey:NSDetailedErrorsKey];
			if (detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			} else {
				NSLog(@"  %@", [*error userInfo]);
			}
		}
		return NO;
	}

    // Check whether or not to save the parent context
    if ( saveParents && moc.parentContext ) {
        return [DNTCoreDataStack saveContext:moc.parentContext andParents:saveParents withError:error];
    }

	return YES;
}

// Save a context
+ (BOOL)saveContext:(NSManagedObjectContext *)moc {
    return [DNTCoreDataStack saveContext:moc andParents:NO withError:nil];
}

- (id)initWithDataSource:(id <DNTCoreDataStackDataSource>)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

#pragma mark - NSManagedObjectModel

/**
 * @abstract Lazily creates the managed object model for the application
 * by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) return _managedObjectModel;

    // Assert that we have a dataSource
    NSAssert(self.dataSource, @"This class requires a data source");

    // Get the url to the model from the dataSource
    NSURL *url = [self.dataSource urlForManagedObjectModelForCoreDataStack:self];
    // Create the model
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    NSAssert(model, @"Don't have a NSManagedObjectModel");
	self.managedObjectModel = [self willUseManagedObjectModel:model];

	return _managedObjectModel;
}

#pragma mark - NSPersistentStoreCoordinator

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;

    // Assert that we have a dataSource
    NSAssert(self.dataSource, @"This class requires a data source");

	// Get the managed object model
    NSManagedObjectModel *mom = self.managedObjectModel;
    if ( !mom || ([[mom entities] count] == 0) ) {
        NSAssert(NO, @"Managed object model is nil");
        return nil;
    }

	// Make sure that the directories exist for where we're going to save the store
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *appSupportDirectory = [self applicationSupportDirectory];
	NSAssert(appSupportDirectory != nil, (@"Application support directory hasn't been specified"));
	if ( ![fileManager fileExistsAtPath:appSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:appSupportDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
			NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", appSupportDirectory, [error userInfo]]));
			return nil;
		}
	}

	// Persistent store migration Options, enable spotlight and migration
	NSMutableDictionary *storeOptions = [NSMutableDictionary dictionary];
	[storeOptions setObject:@YES forKey:NSMigratePersistentStoresAutomaticallyOption];
	[storeOptions setObject:@YES forKey:NSInferMappingModelAutomaticallyOption];

	// Create the persistent store coordinator
	self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

	// Create the url to the store
    NSString *storeName = [self.dataSource storeNameForCoreDataStack:self];
    NSString *storeType = [self.dataSource storeTypeForCoreDataStack:self];
    NSString *filepathToStore = [appSupportDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.store", storeName]];
	NSURL *url = [NSURL fileURLWithPath:filepathToStore];

    // Tell the delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(coreDataStack:willCreatePersistentStoreAtPath:)]) {
        [self.delegate coreDataStack:self willCreatePersistentStoreAtPath:filepathToStore];
    }

    // Add the persistent store to the coordinator
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:url options:storeOptions error:&error];

    if (!persistentStore){
		[NSException raise:DNTCoreDataStack_FailedToCreatePersistentStoreExceptionName
                    format:@"Unable to create persistent store"];
        return nil;
    }

    return _persistentStoreCoordinator;
}

/**
 * @abstract Creates an NSManagedObjectContext.
 *
 * @discussion
 * Returns the managed object context for the application (which is already
 * bound to the persistent store coordinator for the application.)
 */
- (NSManagedObjectContext *)managedObjectContext {

	// NSManagedObjectContext is not thread-safe, therefore, here we can
	// determine if this is the main thread, in which return the default
	// context. If not the main thread, then return a new MOC

    NSManagedObjectContext *moc = nil;

	BOOL isMainThread = [NSThread isMainThread];

	// Check if this isn't the main thread
	if (!isMainThread) {
        moc = [self blankManagedObjectContext];
	} else {
        if ( !_moc ) {
            _moc = [self blankManagedObjectContext];
        }
        moc = _moc;
    }

	// return it with retain count of 1 (so we hold onto it)
	return moc;
}

#pragma mark - Private Methods

- (NSManagedObjectContext *)blankManagedObjectContext {
    
	// Get the persistent store coordinator
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
		[NSException raise:DNTCoreDataStack_FailedToInitialisePersistentStoreExceptionName
                    format:@"Failed to initialize the store"];
        return nil;
    }

	// Create a managed object context
    NSManagedObjectContext *aContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];

    // Set the persistent coordinator
	[aContext setPersistentStoreCoordinator:coordinator];

	// Call our helper method
	[self didAddStoreCoordinator:coordinator toContext:aContext];

	// return the context we've just created, and autorelease it
	return aContext;
}

#pragma mark - Methods for subclassing

// Virtual methods which can be over-ridden by the subclass
- (void)didAddStoreCoordinator:(NSPersistentStoreCoordinator *)storeCoordinator toContext:(NSManagedObjectContext *)aContext {
    // We don't actually do anything
}

// Default implementation returns the argument (no-change)
- (NSManagedObjectModel *)willUseManagedObjectModel:(NSManagedObjectModel *)model {
	return model;
}

- (NSString *)applicationSupportDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

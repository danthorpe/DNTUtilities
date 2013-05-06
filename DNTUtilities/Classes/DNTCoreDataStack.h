//
//  DNTCoreDataStack.h
//  DNTUtilities
//
//  Created by Daniel Thorpe on 06/05/2013.
//  Copyright (c) 2013 Daniel Thorpe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Exception names
extern NSString * const DNTCoreDataStack_FailedToMigrateExceptionName;
extern NSString * const DNTCoreDataStack_FailedToCreatePersistentStoreExceptionName;
extern NSString * const DNTCoreDataStack_FailedToInitialisePersistentStoreExceptionName;

@class DNTCoreDataStack;

@protocol DNTCoreDataStackDataSource;
@protocol DNTCoreDataStackDelegate;

@interface DNTCoreDataStack : NSObject

// Core Data store properties, these must be set before the
// stack is generated.
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeType;

// The Core Data stack
@property (strong, nonatomic, readonly) NSURL *urlForManagedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Delegate
@property (weak, nonatomic) id <DNTCoreDataStackDelegate> delegate;

// DataSource
@property (weak, nonatomic) id <DNTCoreDataStackDataSource> dataSource;

// Save a context
+ (BOOL)saveContext:(NSManagedObjectContext *)moc andParents:(BOOL)saveParents withError:(NSError **)anError;

// Save a context
+ (BOOL)saveContext:(NSManagedObjectContext *)moc;

// Designated initializer
- (id)initWithDataSource:(id<DNTCoreDataStackDataSource>)dataSource;

// Will create a new managed object context, but without any notifications
// so that the calling library can set up it's own notifications
- (NSManagedObjectContext *)managedObjectContext;

// Virtual methods which can be over-ridden by the subclass
// Default implementation does nothing
- (void)didAddStoreCoordinator:(NSPersistentStoreCoordinator *)storeCoordinator toContext:(NSManagedObjectContext *)aContext;

// Default implementation returns the argument (no-change)
- (NSManagedObjectModel *)willUseManagedObjectModel:(NSManagedObjectModel *)model;

@end

@protocol DNTCoreDataStackDataSource <NSObject>

- (NSString *)storeNameForCoreDataStack:(DNTCoreDataStack *)cds;
- (NSString *)storeTypeForCoreDataStack:(DNTCoreDataStack *)cds;
- (NSURL *)urlForManagedObjectModelForCoreDataStack:(DNTCoreDataStack *)cds;

@optional
- (BOOL)coreDataStackShouldLookForDefaultStore:(DNTCoreDataStack *)cds;

@end

@protocol DNTCoreDataStackDelegate <NSObject>

@optional
- (void)coreDataStack:(DNTCoreDataStack *)stack willCreatePersistentStoreAtPath:(NSString *)storePath;

@optional
- (void)coreDataStack:(DNTCoreDataStack *)stack willSaveManagedObjectContext:(NSNotification *)aNotificationNote;

@optional
- (void)coreDataStack:(DNTCoreDataStack *)stack didSaveManagedObjectContext:(NSNotification *)aNotificationNote;

@end

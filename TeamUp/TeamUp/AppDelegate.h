//
//  AppDelegate.h
//  TeamUp
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Firebase/Firebase.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) UIAlertAction *defaultAction;
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *currentGroupUid;
@property (strong, nonatomic) NSString *currentClassUid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) Firebase *users;
@property (strong, nonatomic) Firebase *users_ref;
@property (strong, nonatomic) NSDictionary *currentGroupDictionary;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) loadData;

@end
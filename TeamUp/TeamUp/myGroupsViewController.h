//
//  myGroupsViewController.h
//  TeamUp
//
//  Created by Jiasheng Zhu on 2/24/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef myGroupsViewController_h
#define myGroupsViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface myGroupsViewController : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;
- (NSString *) getNameFromGroupUid:(NSString*) group_uid;
@end

#endif /* myGroupsViewController_h */

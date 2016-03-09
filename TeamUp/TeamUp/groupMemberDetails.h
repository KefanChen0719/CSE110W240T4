//
//  Header.h
//  TeamUp
//
//  Created by Suli Huang on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef groupMemberDetails_h
#define groupMemberDetails_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TeamUp-Swift.h"
@interface groupMemberDetails : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end
#endif 

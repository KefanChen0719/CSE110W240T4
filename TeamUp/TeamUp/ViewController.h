//
//  ViewController.h
//  TeamUp
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "AppDelegate.h"

//Firebase *firebase;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *constructionLabel;
@property (weak, nonatomic) IBOutlet UITextField *memberNameText;
@property (weak, nonatomic) IBOutlet UITextField *memberMajorText;
@property (weak, nonatomic) IBOutlet UIView *memberUpdate;
@property (weak, nonatomic) IBOutlet UITextField *memberYearText;
@property (weak, nonatomic) IBOutlet UIButton *changePassword;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *courseUpdate;

@property (weak, nonatomic) IBOutlet UITextField *addProfText;
@property (weak, nonatomic) IBOutlet UIButton *notFound;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITextField *addCourseText;
@property (weak, nonatomic) IBOutlet UITextField *addTermText;
@property (weak, nonatomic) IBOutlet UITextField *addSectionText;
@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UITextField *changeOldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changeNewPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changeComfirmPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UITextField *addGroupNameText;
@property (weak, nonatomic) IBOutlet UITextField *addMaxPeopleText;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isPrivateSwitch;
@property (weak, nonatomic) IBOutlet UIButton *createGroup;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;

- (IBAction)signOut:(id)sender;
- (IBAction)memberInfoEditor:(id)sender;
- (IBAction)searchClasses:(id)sender;
- (IBAction)newClass:(id)sender;
- (IBAction)keyboardExit:(id)sender;
- (IBAction)updateNewPassword:(id)sender;
- (IBAction)createGroup:(id)sender;
@end


//
//  ViewController.h
//  TeamUp
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *enterEmailText;
@property (weak, nonatomic) IBOutlet UITextField *enterPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *memberNameText;
@property (weak, nonatomic) IBOutlet UITextField *memberMajorText;
@property (weak, nonatomic) IBOutlet UITextField *memberYearText;
@property (weak, nonatomic) IBOutlet UITextField *addProfText;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITextField *addCourseText;
@property (weak, nonatomic) IBOutlet UITextField *addTermText;
@property (weak, nonatomic) IBOutlet UITextField *addSectionText;
@property (weak, nonatomic) IBOutlet UITextField *changeOldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changeNewPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changeComfirmPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *addGroupNameText;
@property (weak, nonatomic) IBOutlet UITextField *addMaxPeopleText;
@property (weak, nonatomic) IBOutlet UISwitch *isPrivateSwitch;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)signUp:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)memberInfoEditor:(id)sender;
- (IBAction)searchClasses:(id)sender;
- (IBAction)newClass:(id)sender;
- (IBAction)keyboardExit:(id)sender;
- (IBAction)updateNewPassword:(id)sender;
- (IBAction)createGroup:(id)sender;
@end


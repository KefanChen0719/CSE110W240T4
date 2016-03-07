//
//  ViewController.m
//  TeamUp
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "ViewController.h"
#import "ForgetPasswordViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import <Firebase/Firebase.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize memberMajorText,memberNameText,memberYearText, searchText, tableView, addCourseText, addProfText, addTermText, addSectionText, changeOldPasswordText, changeNewPasswordText, changeComfirmPasswordText, addGroupNameText, addMaxPeopleText, isPrivateSwitch, appDelegate, viewcontroller;

Firebase *class_ref;
Firebase *class;
Firebase *group_ref;
Firebase *group;
NSString *email;
NSString *year;
NSString *major;
NSDictionary *classes;
NSArray<NSString*> *allClassNames;
NSMutableDictionary *result;
NSArray<NSString*> *yearArray;






- (void)viewDidLoad {
  [super viewDidLoad];
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    //all initialization goes here
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    class_ref = [appDelegate.firebase childByAppendingPath:@"classes"];
    result = [[NSMutableDictionary alloc]initWithCapacity:20];
    [class_ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self.tableView reloadData];
        classes = snapshot.value;
        allClassNames = classes.allKeys;
    }];
    
    //initialization ends here
    //not run-time initialization
    memberNameText.text = (appDelegate.name == nil)? @"" : appDelegate.name;
    memberMajorText.text = (major == nil)? @"" : major;
    memberYearText.text = (year == nil)? @"" : year;
    //end "not run-time initialization"
    
    [self searchCourseLayout];
    [self addCourseLayout];
    [self allGroupsLayout];
    [self createGroupLayout];
    [self memberDetailsLayout];
    [self changePasswordLayout];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, 5, 200, 150)];
    picker.delegate = self;
    picker.dataSource = self;
    
    memberYearText.inputView = picker;
    yearArray  = [[NSArray alloc] initWithObjects:@"Freshman",@"Sophomore",@"Junior",@"Senior", nil];
    
    

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender{
    [appDelegate.firebase unauth];
    
    NSString *signOut  = @"True";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:signOut forKey:@"signOut"];
    
    [defaults synchronize];
    
    NSLog(@"user should be signed out");
    email = @"";
    appDelegate.uid = @"";
    appDelegate.name = @"";
    year = @"";
    major = @"";
    
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    
}

- (IBAction)keyboardExit:(id)sender{} //dismiss keyboard

- (IBAction)memberInfoEditor:(id)sender{
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *groups = snapshot.value;
        appDelegate.name = memberNameText.text;
        year = memberYearText.text;
        major = memberMajorText.text;
        NSDictionary *user_info = @{@"name" : @"Jiasheng Zhu",
                                    @"email" : appDelegate.email,
                                    @"major" : major,
                                    @"year" : year,
                                    @"groups" : groups
                                    };
        NSDictionary *new_user = @{appDelegate.uid : user_info};
        [appDelegate.users_ref updateChildValues:new_user];
    }];
}

- (IBAction)updateNewPassword:(id)sender {
    if(![changeNewPasswordText.text isEqualToString:changeComfirmPasswordText.text]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Different passwords." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:appDelegate.defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [appDelegate.firebase changePasswordForUser:email fromOld:changeOldPasswordText.text
    toNew:changeNewPasswordText.text withCompletionBlock:^(NSError *error) {
        if (error) {
            NSString *errorMessage = [error localizedDescription];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:appDelegate.defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Successfully change your password." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:appDelegate.defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)searchClasses:(id)sender{
    [result removeAllObjects];
    NSString *toSearch = searchText.text;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    toSearch = [[toSearch componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    NSString *index = @"";
    int number = 0;
    if (toSearch.length > 0) {
        class = [class_ref childByAppendingPath:toSearch];
        for(int i = 0; i < allClassNames.count; ++i){
            if([allClassNames[i] containsString:toSearch] || [toSearch containsString:allClassNames[i]]){
                index = @"";
                index = [index stringByAppendingFormat:@"%d", number++];
                [result setValue:allClassNames[i] forKey:index];
                NSLog(@"result writtten with key:%@ and value: %@", index, allClassNames[i]);
                [self.tableView reloadData];
            }
        }
    }
    NSLog(@"updated result has: %lu", (unsigned long)result.count);
    [self.tableView reloadData];
}

- (IBAction)newClass:(id)sender{
    if([addCourseText.text isEqualToString:@""]||[addProfText.text isEqualToString:@""]||[addTermText.text isEqualToString:@""]||[addSectionText.text isEqualToString:@""])
        return;
    NSDictionary *new_class_info = @{@"name":addCourseText.text,
                                @"prof" :addProfText.text,
                                @"term" :addTermText.text,
                                @"section" : addSectionText.text,
                                @"group" : @""
                                };
    NSString *newClassName = addCourseText.text;
    newClassName = [newClassName stringByAppendingFormat:@"%@%@", addTermText.text, addSectionText.text ];
    NSDictionary *new_class = @{newClassName : new_class_info};
    [class_ref updateChildValues:new_class];
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"searchClassViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (IBAction)createGroup:(id)sender{
    if([addGroupNameText.text isEqualToString:@""] || [addMaxPeopleText.text isEqualToString:@""])
        return;
    NSString *groupuid = [appDelegate.firebase.authData.uid stringByAppendingString:addGroupNameText.text];
    NSString *groupName = addGroupNameText.text;
    NSString *groupNum = addMaxPeopleText.text;
    NSString *isPrivate = isPrivateSwitch.isOn? @"private" : @"public";
    NSArray<NSString *> *teamMember = [NSArray arrayWithObjects: appDelegate.firebase.authData.uid, nil];
    NSDictionary *new_group_info = @{@"name" : groupName,
                                     @"teammember" : teamMember,
                                     @"leader" : appDelegate.firebase.authData.uid,
                                     @"groupinfo" : @"New group!",
                                     @"maxnumber" : groupNum,
                                     @"isprivate" : isPrivate,
                                     @"password" : @"password"};
    NSDictionary *new_group = @{groupuid : new_group_info};
    [class updateChildValues:new_group];
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
        if(snapshot.childrenCount!=0)
            [groups addEntriesFromDictionary:snapshot.value];
        [groups setObject:appDelegate.currentClassUid forKey:groupuid];
        [curr_user updateChildValues:groups];
    }];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Yeah!"
                                                                   message:@"created" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:appDelegate.defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    //NSLog(@"result has %lu", (unsigned long)result.count);
    return result.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Class";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
    }
    NSString *number = @"";
    number = [number stringByAppendingFormat:@"%ld",(long)index.row ];
    NSLog(@"result read with key:%@ and value: %@", number, result[number]);
    cell.textLabel.text = [[classes valueForKey:result[number]] valueForKey:@"name"];
    cell.detailTextLabel.text = [[classes valueForKey:result[number]] valueForKey:@"term"];
    return cell;
}

- (void) tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    if(cell!=nil){
        NSString *number = @"";
        number = [number stringByAppendingFormat:@"%ld",(long)indexPath.row ];
        NSString *classuid = result[number];
        class = [[class_ref childByAppendingPath:classuid] childByAppendingPath:@"group"];
        NSLog(@"%@", classuid);
        appDelegate.currentClassUid = classuid;
        viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"ClassGroupsViewController"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
    }
}

- (void)searchCourseLayout {
    UIView *view = self.notFound.superview;
    CGRect view_frame = view.frame;
    CGRect notFound_frame = self.notFound.frame;
    notFound_frame.origin.x = view_frame.size.width - notFound_frame.size.width - 10;
    self.notFound.frame = notFound_frame;
    CGRect table_frame = self.tableView.frame;
    table_frame.size.width = view_frame.size.width;
    self.tableView.frame = table_frame;
}

- (void)addCourseLayout {
    UIView *view = self.courseUpdate.superview;
    CGRect view_frame = view.frame;
    CGRect update_frame = self.courseUpdate.frame;
    update_frame.origin.x = view_frame.size.width - update_frame.size.width - 15;
    self.courseUpdate.frame = update_frame;
}

- (void)allGroupsLayout {
    UIView *view = self.courseView.superview;
    CGRect view_frame = view.frame;
    CGRect topView_frame = self.courseView.frame;
    topView_frame.size.width = view_frame.size.width;
    self.courseView.frame = topView_frame;
    CGRect topLabel_frame = self.courseLabel.frame;
    topLabel_frame.origin.x = view_frame.size.width / 4;
    topLabel_frame.size.width = view_frame.size.width / 2;
    self.courseLabel.frame = topLabel_frame;
    CGRect add_frame = self.addButton.frame;
    add_frame.origin.x = view_frame.size.width - add_frame.size.width - 10;
    self.addButton.frame = add_frame;
}

- (void)createGroupLayout {
    UIView *view = self.addGroupNameText.superview;
    CGRect view_frame = view.frame;
    CGRect name_frame = self.addGroupNameText.frame;
    name_frame.origin.x = view_frame.size.width / 4;
    name_frame.size.width = view_frame.size.width / 2;
    self.addGroupNameText.frame = name_frame;
    CGRect number_frame = self.addMaxPeopleText.frame;
    number_frame.origin.x = view_frame.size.width / 4;
    number_frame.size.width = view_frame.size.width / 2;
    self.addMaxPeopleText.frame = number_frame;
    CGRect label_frame = self.privateLabel.frame;
    label_frame.origin.x = number_frame.origin.x;
    self.privateLabel.frame = label_frame;
    CGRect switch_frame = self.isPrivateSwitch.frame;
    switch_frame.origin.x = number_frame.origin.x + number_frame.size.width - switch_frame.size.width;
    self.isPrivateSwitch.frame = switch_frame;
    CGRect create_frame = self.createGroup.frame;
    create_frame.origin.x = view_frame.size.width / 4;
    create_frame.size.width = view_frame.size.width / 2;
    self.createGroup.frame = create_frame;
}

- (void)memberDetailsLayout {
    UIView *view = self.constructionLabel.superview;
    CGRect view_frame = view.frame;
    CGRect topView_frame = self.topView.frame;
    topView_frame.size.width = view_frame.size.width;
    self.topView.frame = topView_frame;
    CGRect update_frame = self.memberUpdate.frame;
    update_frame.origin.x = view_frame.size.width - update_frame.size.width - 10;
    self.memberUpdate.frame = update_frame;
    CGRect label_frame = self.constructionLabel.frame;
    label_frame.origin.x = view_frame.size.width / 4;
    label_frame.size.width = view_frame.size.width / 2;
    label_frame.origin.y = view_frame.size.height / 5;
    self.constructionLabel.frame = label_frame;
    CGRect nameText_frame = self.memberNameText.frame;
    nameText_frame.origin.x = view_frame.size.width / 2;
    self.memberNameText.frame = nameText_frame;
    CGRect majorText_frame = self.memberMajorText.frame;
    majorText_frame.origin.x = view_frame.size.width / 2;
    self.memberMajorText.frame = majorText_frame;
    CGRect yearText_frame = self.memberYearText.frame;
    yearText_frame.origin.x = view_frame.size.width / 2;
    self.memberYearText.frame = yearText_frame;
    CGRect changePassword_frame = self.changePassword.frame;
    changePassword_frame.origin.x = view_frame.size.width / 4;
    changePassword_frame.size.width = view_frame.size.width / 2;
    self.changePassword.frame = changePassword_frame;
}

- (void)changePasswordLayout {
    UIView *view = self.changeOldPasswordText.superview;
    CGRect view_frame = view.frame;
    CGRect changeOldPasswordText_frame = self.changeOldPasswordText.frame;
    changeOldPasswordText_frame.origin.x = view_frame.size.width / 4;
    changeOldPasswordText_frame.origin.y = view_frame.size.height / 4;
    changeOldPasswordText_frame.size.width = view_frame.size.width / 4 * 3;
    self.changeOldPasswordText.frame = changeOldPasswordText_frame;
    CGRect changeNewPasswordText_frame = self.changeNewPasswordText.frame;
    changeNewPasswordText_frame.origin.x = view_frame.size.width / 4;
    changeNewPasswordText_frame.size.width = view_frame.size.width / 4 * 3;
    changeNewPasswordText_frame.origin.y = changeOldPasswordText_frame.origin.y + changeOldPasswordText_frame.size.height + 20;
    self.changeNewPasswordText.frame = changeNewPasswordText_frame;
    CGRect changeConfirmPasswordText_frame = self.changeComfirmPasswordText.frame;
    changeConfirmPasswordText_frame.origin.x = view_frame.size.width / 4;
    changeConfirmPasswordText_frame.size.width = view_frame.size.width / 4 * 3;
    changeConfirmPasswordText_frame.origin.y = changeNewPasswordText_frame.origin.y + changeNewPasswordText_frame.size.height + 10;
    self.changeComfirmPasswordText.frame = changeConfirmPasswordText_frame;
    CGRect updateButton_frame = self.updateButton.frame;
    updateButton_frame.origin.x = view_frame.size.width / 3;
    updateButton_frame.size.width = view_frame.size.width / 3;
    updateButton_frame.origin.y = changeConfirmPasswordText_frame.origin.y + 100;
    self.updateButton.frame = updateButton_frame;
    CGRect doneButton_frame = self.doneButton.frame;
    doneButton_frame.origin.x = view_frame.size.width / 3;
    doneButton_frame.size.width = view_frame.size.width / 3;
    doneButton_frame.origin.y = updateButton_frame.origin.y + 50;
    self.doneButton.frame = doneButton_frame;
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return yearArray.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return yearArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    memberYearText.text = yearArray[row];
    
}


- (IBAction)scanAction:(id)sender
{
    //appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
            //appDelegate.uid = resultAsString;
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Reader not supported by the current device" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:appDelegate.defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (![result isEqualToString:@"ERROR"]) {
            appDelegate.currentClassUid = [[result componentsSeparatedByString:@";"] objectAtIndex:0];
            appDelegate.currentGroupUid = [[result componentsSeparatedByString:@";"] objectAtIndex:1];
            NSLog(@"%@ : %@", appDelegate.currentClassUid, appDelegate.currentGroupUid);
            Firebase *check = [appDelegate.firebase childByAppendingPath:@"classes"];
            check = [check childByAppendingPath:appDelegate.currentClassUid];
            [check observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                if(snapshot.childrenCount==0){
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There is error with the QRCode" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:appDelegate.defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    NSDictionary *double_check = snapshot.value[@"group"];
                    if (double_check[appDelegate.currentGroupUid]) {
                        appDelegate.currentGroupDictionary = double_check[appDelegate.currentGroupUid];
                        viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddGroup"];
                        [self presentViewController:viewcontroller animated:YES completion:nil];
                    }
                }
            }];
        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There is error with the QRCode" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:appDelegate.defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end









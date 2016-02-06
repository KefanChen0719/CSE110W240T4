//
//  ViewController.m
//  TeamUp
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize emailText, passwordText, enterEmailText, enterPasswordText, confirmPasswordText, groupNameText, maxPeopleText, resetPasswordText, memberMajorText,memberNameText,memberYearText, searchText, tableView, addCourseText, addProfText, addTermText, addSectionText, changeOldPasswordText, changeNewPasswordText, changeComfirmPasswordText;

Firebase *firebase;
Firebase *users_ref;
Firebase *users;
Firebase *class_ref;
Firebase *class;
Firebase *group_ref;
Firebase *group;
//UILabel *info;
//UIButton *closeInfo;
UIStoryboard *mainstoryboard;
UIViewController *viewcontroller;
NSString *email;
NSString *uid; //store the valid cahracters of an email address (underscore _ , letters and numbers only)
NSString *name;
UIAlertAction* defaultAction;
NSString *year;
NSString *major;
NSDictionary *classes;
NSArray<NSString*> *allClassNames;
NSMutableDictionary *result;

- (void)viewDidLoad {
  [super viewDidLoad];
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    self.emailText.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordText setSecureTextEntry:YES];
    self.enterEmailText.borderStyle = UITextBorderStyleRoundedRect;
    self.enterPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.enterPasswordText setSecureTextEntry:YES];
    self.confirmPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.confirmPasswordText setSecureTextEntry:YES];
    self.groupNameText.borderStyle = UITextBorderStyleRoundedRect;
    self.maxPeopleText.borderStyle = UITextBorderStyleRoundedRect;
    
    //all initialization goes here
    
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]; //initialize the default alertview action
    mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    firebase = [[Firebase alloc] initWithUrl:@"https://resplendent-inferno-8485.firebaseio.com"];
    users_ref = [firebase childByAppendingPath:@"users"];
    class_ref = [firebase childByAppendingPath:@"classes"];
    result = [[NSMutableDictionary alloc]initWithCapacity:20];
    [class_ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self.tableView reloadData];
        classes = snapshot.value;
        allClassNames = classes.allKeys;
    }];
//    info = [[UILabel alloc] initWithFrame:CGRectMake(37, 166, 301, 280)];
//    info.text = @"AAAA";
//    info.backgroundColor = [UIColor colorWithRed:230/255 green:230/255 blue:230/255 alpha:0.15];
    // initialze the closeinfo button
//    closeInfo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    
    //initialization ends here
    //not run-time initialization
    memberNameText.text = (name == nil)? @"" : name;
    memberMajorText.text = (major == nil)? @"" : major;
    memberYearText.text = (year == nil)? @"" : year;
    //end "not run-time initialization"

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//- (IBAction)showGroupInfo:(id)sender {
//    [self.view addSubview:closeInfo];
//    [self.view addSubview:info];
//    [closeInfo addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)btnClicked {
//    [info removeFromSuperview];
//    [closeInfo removeFromSuperview];
//}

- (IBAction)signIn:(id)sender{
    //test approach
//    emailText.text = @"test@ucsd.edu";
//    passwordText.text = @"test";
    [firebase authUser:emailText.text password:passwordText.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        NSString *errorMessage = [error localizedDescription];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        email = emailText.text;
        uid = authData.uid;
        [self loadData];
        users = [users_ref childByAppendingPath:uid];
        [users observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            name = snapshot.value[@"name"];
            year = snapshot.value[@"year"];
            major = snapshot.value[@"major"];
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
        viewcontroller = [mainstoryboard instantiateViewControllerWithIdentifier:@"myGroupsViewController"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
        NSLog(@"user should have signed in");
    }
    }];
}

- (IBAction)signUp:(id)sender{
    NSString * domain = [enterEmailText.text substringFromIndex:MAX((int)[enterEmailText.text length]-8, 0)];    
    if (![domain isEqualToString:@"ucsd.edu"]) {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must use a ucsd email!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if(![enterPasswordText.text isEqualToString:confirmPasswordText.text]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Different passwords" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        enterPasswordText.text = @"";
        confirmPasswordText.text = @"";
        return;
    }
    else{
    [firebase createUser:enterEmailText.text password:enterPasswordText.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    if (error) {
        NSString *errorMessage = [error localizedDescription];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        email = enterEmailText.text;
        uid = result[@"uid"];
        [self loadData];
        name = @"new user";
        major = @"undecided";
        year = @"0";
        NSDictionary *user_info = @{
                                    @"name" : name,
                                    @"email" : email,
                                    @"major" : major,
                                    @"year" : year
                                    };
        NSDictionary *new_user = @{uid : user_info};
        [users_ref updateChildValues:new_user];
        NSLog(@"user should have signed up");
        viewcontroller = [mainstoryboard instantiateViewControllerWithIdentifier:@"memberDetailsViewController"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
    }
    }];
    }
}

- (IBAction)signOut:(id)sender{
    [firebase unauth];
    NSLog(@"user should be signed out");
    email = @"";
    uid = @"";
    name = @"";
    year = @"";
    major = @"";
}

- (IBAction)keyboardExit:(id)sender{} //dismiss keyboard


- (void) loadData{
    if(uid!=nil){
        users = [users_ref childByAppendingPath:uid];
        [users observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if(!snapshot.exists){
                NSLog(@"user info not found");
                return;
            }else{
            name = snapshot.value[@"name"];
            //do something
            }
        }];
    }
}

- (IBAction)resetPassword:(id)sender{
    [firebase resetPasswordForUser:resetPasswordText.text withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error when resetting password");
            [resetPasswordText setText:@"error occured"];
        } else {
            NSLog(@"succeed sending resetting password");
            [resetPasswordText setText:@"sent"];
        }
    }];
}

- (IBAction)memberInfoEditor:(id)sender{
    name = memberNameText.text;
    year = memberYearText.text;
    major = memberMajorText.text;
    NSDictionary *user_info = @{@"name" : name,
                                @"email" : email,
                                @"major" : major,
                                @"year" : year
                                };
    NSDictionary *new_user = @{uid : user_info};
    [users_ref updateChildValues:new_user];
}

- (IBAction)updateNewPassword:(id)sender {
    if(![changeNewPasswordText.text isEqualToString:changeComfirmPasswordText.text]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Different passwords." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [firebase changePasswordForUser:email fromOld:changeOldPasswordText.text
    toNew:changeNewPasswordText.text withCompletionBlock:^(NSError *error) {
        if (error) {
            NSString *errorMessage = [error localizedDescription];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Successfully change your password." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:defaultAction];
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
    viewcontroller = [mainstoryboard instantiateViewControllerWithIdentifier:@"searchClassViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
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

-(void) tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    if(cell!=nil){
        NSLog(@"cell is not null!");
        viewcontroller = [mainstoryboard instantiateViewControllerWithIdentifier:@"allGroupsForClassViewController"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
    }
}
@end
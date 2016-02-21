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
    appDelegate.name = memberNameText.text;
    year = memberYearText.text;
    major = memberMajorText.text;
    NSDictionary *user_info = @{@"name" : appDelegate.name,
                                @"email" : email,
                                @"major" : major,
                                @"year" : year
                                };
    NSDictionary *new_user = @{appDelegate.uid : user_info};
    [appDelegate.users_ref updateChildValues:new_user];
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

-(void) tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    if(cell!=nil){
        NSString *number = @"";
        number = [number stringByAppendingFormat:@"%ld",(long)indexPath.row ];
        NSString *classuid = result[number];
        class = [[class_ref childByAppendingPath:classuid] childByAppendingPath:@"group"];
        NSLog(@"%@", classuid);
        viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"allGroupsForClassViewController"];
        [self presentViewController:viewcontroller animated:YES completion:nil];
    }
}
@end
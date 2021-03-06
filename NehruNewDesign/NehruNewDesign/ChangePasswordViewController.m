//
//  ChangePasswordViewController.m
//  nehru
//
//  Created by Raj on 08/01/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize mTxtNewPassword,mTxtConfrmPassword,mTxtEmailID;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)mClickedChangePassword:(id)sender {
    if([mTxtConfrmPassword.text isEqualToString:@""]||[mTxtEmailID.text isEqualToString:@""]||[mTxtNewPassword.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please enter the required fields" message:@"Enter required Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        btnChangePassword.userInteractionEnabled=NO;
    PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"NehruUser"];
    [validLoginQuery whereKey:@"emailId" equalTo:mTxtEmailID.text];
    [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(objects.count==0)
            {
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Email address incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [alertview show];
            }
            else if(objects.count==1){
                PFObject *AppUser=[objects objectAtIndex:0];
                NSLog(@"App User %@",AppUser);
                [AppUser setObject:mTxtNewPassword.text forKey:@"userPassword"];
                [AppUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        if(succeeded){
                            self.view.userInteractionEnabled=NO;
                            NSLog(@"Password successfully changed");
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password successfully changed" message:@"Password successfully changed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alert.tag=345591;
                            [alert show];
                            
                            [self ResignKeys];
                        }
                        else{
                            //NSLog(@"Sorry we were not able to sign up");
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Not able to change the password" message:@"Not able to change the password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else{
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Username or Password incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [alertview show];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
}

-(void)ResignKeys
{
    [mTxtNewPassword resignFirstResponder];
    [mTxtConfrmPassword resignFirstResponder];
    [mTxtEmailID resignFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100867) {
        
        if(buttonIndex ==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if(alertView.tag==345591)
    {
        if(buttonIndex ==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            btnChangePassword.userInteractionEnabled=YES;
            // Get views. controllerIndex is passed in as the controller we want to go to.
            if (iOSDeviceScreenSize.height == 480)
            {
                
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    ViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"listingView"];
                
                    //        lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:lvc animated:YES];
                
            }
            else if(iOSDeviceScreenSize.height==568)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iphone4" bundle: nil];
                ViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"listingView"];
                    //        lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:lvc animated:YES];
                }
            }
    }
     [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)ClickedBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

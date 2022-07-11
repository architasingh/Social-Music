//
//  ViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import "LoginViewController.h"
# import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; 
    [self.view addGestureRecognizer:gestureRecognizer];
}


- (IBAction)didTapSignup:(id)sender {
    // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
                    [self alert];
                }
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
        }];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
                    [self alert];
                }
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
        }];
}

- (void) alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields Alert"
                                message:@"You have submitted one or more empty fields. Please enter at least 1 character for username/password and try again."
                                preferredStyle:(UIAlertControllerStyleAlert)];
   
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                    }];
    
    [alert addAction:cancelAction];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

@end

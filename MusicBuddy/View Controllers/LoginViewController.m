//
//  ViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

# import "LoginViewController.h"
# import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)didTapLogin:(id)sender;
- (IBAction)didTapSignup:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.tintColor = [UIColor colorWithRed:0.004 green:0.098 blue:0.212 alpha:1.000];
    self.signupButton.tintColor = [UIColor colorWithRed:0.004 green:0.098 blue:0.212 alpha:1.000];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; 
    [self.view addGestureRecognizer:gestureRecognizer];
}

// Sign up a new user
- (IBAction)didTapSignup:(id)sender {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
    
        NSURL *url = [NSURL URLWithString:@"https://openclipart.org/image/800px/247319"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *defaultImage = [UIImage imageWithData:data];
        newUser[@"profilePicture"] = [PFFileObject fileObjectWithName:@"image.png" data:UIImagePNGRepresentation(defaultImage)];
    
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
                    [self loginAlert];
                }
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"signupSegue" sender:self];
            }
        }];
}

// Log in an existing user
- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
                    [self loginAlert];
                }
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            }
        }];
}

// Send alert if user inputs empty username/password fields
- (void)loginAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields Alert"
                                message:@"You have submitted one or more empty fields. Please enter at least 1 character for username/password and try again."
                                preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

// Dismiss keyboard
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

@end

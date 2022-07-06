//
//  ViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)didTapLogin:(id)sender;
- (IBAction)didTapSignup:(id)sender;

@end


//
//  SongsViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "MessagesViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "NSDate+DateTools.h"

@interface MessagesViewController () <UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *chatMessage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorChat;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicatorChat startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadMessages) userInfo:nil repeats:true];

    self.chatTableView.dataSource = self;
    self.chatTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
       [self.chatTableView insertSubview:refreshControl atIndex:0];
    
    self.chatMessage.delegate = self;
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    self.chatTableView.dataSource = self;

    [self.chatTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)loadMessages {
    [self.activityIndicatorChat stopAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            self.messages = (NSMutableArray*)messages;
            [self.chatTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapSend:(id)sender {
    if ([self.chatMessage.text isEqual:@""]) {
        [self emptyMessageAlert];
        return;
    }
    PFObject *chatMessageObject = [PFObject objectWithClassName:@"Message"];
    
    chatMessageObject[@"text"] = self.chatMessage.text;
    chatMessageObject[@"user"] = PFUser.currentUser;
    
    [chatMessageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was saved!");
                self.chatMessage.text = @"";
                chatMessageObject[@"date"] = chatMessageObject.createdAt;
                [chatMessageObject saveInBackground];
                [self.messages addObject:chatMessageObject[@"date"]];
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
            }
        }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chatLabel.text = self.messages[indexPath.row][@"text"];
    cell.bubbleView.layer.cornerRadius = 16;
    cell.bubbleView.clipsToBounds = true;
    
    PFUser *user = self.messages[indexPath.row][@"user"];
    
    if (user != nil) {
        cell.usernameLabel.text = [@"@" stringByAppendingString: user.username];
        cell.profileImage.file = user[@"profilePicture"];
        cell.profileImage.layer.cornerRadius = 30;
        cell.profileImage.layer.masksToBounds = YES;
        
        NSDate *dateForm = self.messages[indexPath.row][@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        
        NSDate *date = dateForm; // your NSDate object
        NSString *dateString = [dateFormatter stringFromDate:date];
        cell.dateLabel.text = dateString;
        
        [cell.profileImage loadInBackground];
        
    } else {
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    float newVerticalPosition = -keyboardSize.height;

    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveFrameToVerticalPosition:0.0f forDuration:0.3f];
}

- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;

    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > self.chatMessage.text.length)
    {
        return NO;
    }
        
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 500;
}

- (void) emptyMessageAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Message Alert"
                                message:@"You have submitted an empty message. Please enter at least 1 character for your message and try again."
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

@end

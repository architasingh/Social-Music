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
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"

@interface MessagesViewController () <UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *chatMessage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorChat;
@property (strong, nonatomic) PFLiveQueryClient *liveQueryClient;
@property (strong, nonatomic) PFLiveQuerySubscription *liveQuerySubscription;

@end

@implementation MessagesViewController

NSString *liveQueryURL = @"wss://socialmusicnew.b4a.io";

// view setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicatorChat startAnimating];
    
    [self setupLiveQuery];
    
    self.chatTableView.dataSource = self;
    self.chatTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.chatTableView insertSubview:refreshControl atIndex:0];
    
    self.chatMessage.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    self.chatTableView.dataSource = self;

    [self.chatTableView reloadData];
    [refreshControl endRefreshing];
}

// live query
- (void)setupLiveQuery {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
    NSString *parseAppID = [dict objectForKey: @"parse_app_id"];
    NSString *parseClientKey = [dict objectForKey: @"parse_client_key"];
    
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:liveQueryURL applicationId:parseAppID clientKey:parseClientKey];
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    self.liveQuerySubscription = [self.liveQueryClient subscribeToQuery:query];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.liveQuerySubscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf.messages insertObject:object atIndex:0];
        NSLog(@"object: %@", object);
        dispatch_async(dispatch_get_main_queue(), ^ {[strongSelf.chatTableView reloadData];});
    }];
    [self loadMessages];
}

- (void)loadMessages {
    [self.activityIndicatorChat stopAnimating];

    PFQuery *query = [PFQuery queryWithClassName:@"Message"];

    [query orderByDescending:@"date"];
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

// button action

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
                [chatMessageObject saveInBackground]; // not showing immediately
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
            }
        }];
}

// tableview methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chatLabel.text = self.messages[indexPath.row][@"text"];
//    NSLog(@"%@",self.messages);
    cell.bubbleView.layer.cornerRadius = 16;
    cell.bubbleView.clipsToBounds = true;
    
    NSDate *dateForm = self.messages[indexPath.row][@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-yyyy";
    
    NSDate *date = dateForm; // your NSDate object
    NSString *dateString = [dateFormatter stringFromDate:date];
    cell.dateLabel.text = dateString;
    
    PFUser *chatAuthor = self.messages[indexPath.row][@"user"];
    
    [chatAuthor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.usernameLabel.text = [@"@" stringByAppendingString: self.messages[indexPath.row][@"user"][@"username"]];
        cell.profileImage.file = self.messages[indexPath.row][@"user"][@"profilePicture"];
        cell.profileImage.layer.cornerRadius = 30;
        cell.profileImage.layer.masksToBounds = YES;
        [cell.profileImage loadInBackground];
    }];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

// keyboard methods

- (void) hideKeyboard {
    [self.view endEditing:YES];
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

// textfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > self.chatMessage.text.length)
    {
        return NO;
    }
        
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 500;
}

// alert

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

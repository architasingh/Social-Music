//
//  SongsViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessagesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITextField *chatMessage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

- (IBAction)didTapLogout:(id)sender;
- (IBAction)didTapSend:(id)sender;

@end

NS_ASSUME_NONNULL_END

//
//  CustomRefresh.m
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import "CustomRefresh.h"

@implementation CustomRefresh
- (id)init {
    if ((self = [super init]) ) {
    }
    return self;
}

// Create custom refresh control to be used across view controllers
- (void) customRefresh: (UITableView *)tableView {
    KafkaRingIndicatorHeader * circle = [[KafkaRingIndicatorHeader alloc] init];
    circle.themeColor = UIColor.systemOrangeColor;
    circle.animatedBackgroundColor = UIColor.systemYellowColor;
    __weak KafkaRingIndicatorHeader *weakCircle = circle;
    circle.refreshHandler = ^{
        [tableView reloadData];
        [weakCircle endRefreshing];
    };
     tableView.headRefreshControl = circle;
}

@end

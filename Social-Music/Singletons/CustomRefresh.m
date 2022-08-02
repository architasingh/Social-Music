//
//  CustomRefresh.m
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import "CustomRefresh.h"

@implementation CustomRefresh
+ (id)shared {
    static CustomRefresh *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) customRefresh: (UITableView *)tableView {
    KafkaRingIndicatorHeader * circle = [[KafkaRingIndicatorHeader alloc] init];
    circle.themeColor = UIColor.systemIndigoColor;
    circle.animatedBackgroundColor = UIColor.systemTealColor;
    __weak KafkaRingIndicatorHeader *weakCircle = circle;
    circle.refreshHandler = ^{
        [tableView reloadData];
        [weakCircle endRefreshing];
    };
     tableView.headRefreshControl = circle;
}

@end

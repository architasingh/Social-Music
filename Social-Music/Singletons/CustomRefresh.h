//
//  CustomRefresh.h
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import <Foundation/Foundation.h>
#import "KafkaRingIndicatorHeader.h"
#import "KafkaRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRefresh : NSObject
+ (id)shared;

-(void)customRefresh :(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

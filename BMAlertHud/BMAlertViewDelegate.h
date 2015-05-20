//
//  BMAlertViewDelegate.h
//  TestFirst
//
//  Created by shaowei on 5/14/15.
//  Copyright (c) 2015 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMAlertView;

@protocol BMAlertViewDelegate <NSObject>

- (void)bmAlertView:(BMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

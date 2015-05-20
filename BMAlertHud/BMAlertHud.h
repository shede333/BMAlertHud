//
//  BMAlertHud.h
//  TestFirst
//
//  Created by shaowei on 5/13/15.
//  Copyright (c) 2015 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMAlertHudDelegate.h"
#import "BMAlertView.h"



@interface BMAlertHud : NSObject

/**
 *  show alert
 *
 *  @param title             title,暂时只支持设置字体颜色
 *  @param message           message,暂时只支持设置字体颜色
 *  @param delegate          回调对象
 *  @param cancelButtonTitle 取消按钮
 *  @param otherButtonTitles 其他按钮
 *
 *  @return <#return value description#>
 */
+ (BMAlertView *)showWithTitle:(NSAttributedString *)title
                      message:(NSAttributedString *)message
                     delegate:(id /*<BMAlertHudDelegate>*/)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

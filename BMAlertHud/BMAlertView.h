//
//  BMAlertView.h
//  TestFirst
//
//  Created by shaowei on 5/13/15.
//  Copyright (c) 2015 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Sizes.h"
#import "SWCommonMacro.h"


@interface BMAlertView : UIView

- (instancetype)initWithTitle:(NSAttributedString *)title
                      message:(NSAttributedString *)message
                     delegate:(id /*<BMAlertViewDelegate>*/)delegate
                       titles:(NSArray *)titles;



@end

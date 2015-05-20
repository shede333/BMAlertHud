//
//  ViewController.m
//  Demo
//
//  Created by shaowei on 5/20/15.
//  Copyright (c) 2015 shaowei. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Sizes.h"
#import "SWCommonMacro.h"
#import "BMAlertHud.h"

@interface ViewController ()<BMAlertHudDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    showLabel.backgroundColor = [UIColor yellowColor];
    showLabel.text = @"hello, world!";
    [showLabel sizeToFit];
    showLabel.top = 50;
    showLabel.centerX = self.view.width/2;
    [self.view addSubview:showLabel];
    
    [self addBtn1];
    [self addBtn2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Function - Private

- (void)addBtn1{
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setTitle:@"click me!" forState:UIControlStateNormal];
    [clickBtn setBackgroundColor:[UIColor blueColor]];
    [clickBtn sizeToFit];
    clickBtn.centerX = self.view.width/2;
    clickBtn.top = 100;
    [clickBtn addTarget:self
                 action:@selector(actionClick1)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
}

- (void)addBtn2{
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setTitle:@"click me!叠加显示两个AlertView" forState:UIControlStateNormal];
    [clickBtn setBackgroundColor:[UIColor blueColor]];
    [clickBtn sizeToFit];
    clickBtn.centerX = self.view.width/2;
    clickBtn.top = 150;
    [clickBtn addTarget:self
                 action:@selector(actionClick2)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
}

#pragma mark - action

- (void)actionClick2{
    //弹出两个 alert框
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"这是 文字高亮，模仿系统提示框的样式，但是可以定义文字格式"];
    [message setAttributes:attributes
                     range:NSMakeRange(3, 4)];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert Title-1"];
    
    //显示第1个Alert
    [BMAlertHud showWithTitle:title
                      message:message
                     delegate:self
            cancelButtonTitle:@"确定"
            otherButtonTitles: nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //显示第2个Alert
        NSAttributedString *title2 = [[NSAttributedString alloc] initWithString:@"Alert Title-2"];
        [BMAlertHud showWithTitle:title2
                          message:message
                         delegate:self
                cancelButtonTitle:@"确定"
                otherButtonTitles: nil];
    });

}


- (void)actionClick1{
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"这是 文字高亮，模仿系统提示框的样式，但是可以定义文字格式"];
    [message setAttributes:attributes
                     range:NSMakeRange(3, 4)];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert Title"];
    
    [BMAlertHud showWithTitle:title
                      message:message
                     delegate:self
            cancelButtonTitle:@"确定"
            otherButtonTitles: nil];
}

#pragma mark - BMAlertHudDelegate

- (void)bmAlertView:(BMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"button is clicked, index: %d", (int)buttonIndex);
}



@end

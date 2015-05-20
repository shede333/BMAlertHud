//
//  BMAlertHud.m
//  TestFirst
//
//  Created by shaowei on 5/13/15.
//  Copyright (c) 2015 baidu. All rights reserved.
//

#import "BMAlertHud.h"
#import "BMAlertViewDelegate.h"

#define kALAnimationDuration 0.3f

typedef NS_ENUM(NSInteger, BMAlertHudStatus){
    BMAlertHudStatusOfNone = 0,
    BMAlertHudStatusOfShowing,
};

@interface BMAlertContentModel : NSObject

@property (nonatomic, weak) id<BMAlertHudDelegate> delegate;
@property (nonatomic, strong) BMAlertView *alertView;

@end

@implementation BMAlertContentModel

@end

/***********************************************************************/

/*
 * 注意：
 * 在ios8上， UIScreen.bounds,UIViewController.iew.size, 是随着屏幕方向旋转变化的，所以设置子View的mask即可自动旋转
 * 但是在ios6、7，这些尺寸都是保持竖屏的尺寸不变，所以，子view的旋转，是需要自己在controller的willAnimateRotationToInterfaceOrientation设置旋转后的位置。
**/
@interface BMAlertViewController : UIViewController

@property (nonatomic, strong) UIView *showingView;

- (void)addShowingView:(UIView *)showingView;
- (void)removeShowingView;

@end

@implementation BMAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - rotation

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (_showingView && (!OS_VERSION_G_E(8))) {
        [self moveShowingViewToCenterWithOrientation:toInterfaceOrientation];
    }
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    DFuncLog;
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}

#pragma mark - Function - Public

- (void)addShowingView:(UIView *)showingView{
    if (self.showingView) {
        [_showingView removeFromSuperview];
    }
    self.showingView = showingView;
    [self.view addSubview:_showingView];
    if (OS_VERSION_G_E(8)) {
        _showingView.centerX = self.view.width/2;
        _showingView.centerY = self.view.height/2;
    }else{
        [self moveShowingViewToCenterWithOrientation:self.interfaceOrientation];
    }
    
}

- (void)removeShowingView{
    if (self.showingView) {
        [_showingView removeFromSuperview];
    }
    self.showingView = nil;
}

#pragma mark - Function - Private

- (void)moveShowingViewToCenterWithOrientation:(UIInterfaceOrientation)orientation{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _showingView.centerX = self.view.width/2;
        _showingView.centerY = self.view.height/2;
    }else if(UIInterfaceOrientationIsLandscape(orientation)){
        _showingView.centerX = self.view.height/2;
        _showingView.centerY = self.view.width/2;
    }
    
}

@end

/***********************************************************************/

@interface BMAlertHud()<BMAlertViewDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) BMAlertContentModel *modelOfShowing;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation BMAlertHud

+ (instancetype)sharedInstance{
    static BMAlertHud *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[[self class] alloc] init];
        
        sInstance.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        sInstance.alertWindow.backgroundColor = [UIColor clearColor];  //很重要，要不然屏幕旋转的动画为黑色
        sInstance.alertWindow.windowLevel = UIWindowLevelAlert;
        [sInstance.alertWindow setHidden:YES];
        
        //controller
        BMAlertViewController *controller = [[BMAlertViewController alloc] init];
        sInstance.alertWindow.rootViewController = controller;
        
        //bgackground
        UIView *bgView = [[UIView alloc] init];
        bgView.origin = CGPointZero;
        bgView.size = controller.view.size;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
        UIViewAutoresizingFlexibleWidth;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;
        bgView.transform = CGAffineTransformMakeScale(4, 4); //防止statusBar没有覆盖到
        sInstance.bgView = bgView;
        
        [controller.view addSubview:bgView];
        
        sInstance.models = [NSMutableArray arrayWithCapacity:3];
        
    });
    
    return sInstance;
}

#pragma mark - Function - Public

+ (BMAlertView *)showWithTitle:(NSAttributedString *)title
                      message:(NSAttributedString *)message
                     delegate:(id /*<BMAlertViewDelegate>*/)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...{
    NSMutableArray *btnTitles = [NSMutableArray arrayWithCapacity:2];
    if (cancelButtonTitle) {
        [btnTitles addObject:cancelButtonTitle];
    }
    if (otherButtonTitles) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *tmpStr = otherButtonTitles; tmpStr != nil; tmpStr = va_arg(args, NSString *)) {
            [btnTitles addObject:tmpStr];
        }
    }
    
    BMAlertHud *hud = [BMAlertHud sharedInstance];
    
    BMAlertView *alertView = [[BMAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:hud
                                                         titles:btnTitles];
    if (OS_VERSION_G_E(8)) {
        alertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|
        UIViewAutoresizingFlexibleRightMargin|
        UIViewAutoresizingFlexibleTopMargin|
        UIViewAutoresizingFlexibleBottomMargin;
    }
    BMAlertContentModel *model = [[BMAlertContentModel alloc] init];
    model.delegate = delegate;
    model.alertView = alertView;

    if (hud.modelOfShowing == nil) {
        [self showAlertWithModel:model];
    }else{
        [hud.models addObject:model];
    }
    
    return alertView;
}

#pragma mark - Function - Private

+ (void)showAlertWithModel:(BMAlertContentModel *)model{
    [BMAlertHud sharedInstance].modelOfShowing = model;
    BMAlertView *alertView = model.alertView;
    
    BMAlertViewController *rootController = (BMAlertViewController *)[BMAlertHud sharedInstance].alertWindow.rootViewController;
    
    alertView.alpha = 0.1f;
    alertView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
    BMAlertHud *hud = [BMAlertHud sharedInstance];
    hud.bgView.alpha = 0;
    [rootController addShowingView:alertView];
    
    hud.alertWindow.hidden = NO;
    [hud.alertWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:kALAnimationDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         alertView.alpha = 1;
                         alertView.transform = CGAffineTransformIdentity;
                         hud.bgView.alpha = 0.3f;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

+ (void)handleAlertFinish{
    BMAlertHud *hud = [BMAlertHud sharedInstance];
    BMAlertViewController *rootController = (BMAlertViewController *)hud.alertWindow.rootViewController;
    
    [rootController removeShowingView];
    hud.modelOfShowing = nil;
    hud.alertWindow.hidden = YES;
    [hud.alertWindow resignKeyWindow];
    
    if ([hud.models count] > 0) {
        BMAlertContentModel *tmpModel = hud.models.firstObject;
        [hud.models removeObjectAtIndex:0];
        [self showAlertWithModel:tmpModel];
    }
}

#pragma mark - BMAlertViewDelegate

- (void)bmAlertView:(BMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.modelOfShowing.delegate respondsToSelector:@selector(bmAlertView:clickedButtonAtIndex:)]) {
        [self.modelOfShowing.delegate bmAlertView:alertView
                             clickedButtonAtIndex:buttonIndex];
    }
    
    [BMAlertHud handleAlertFinish];
}

@end

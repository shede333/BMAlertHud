//
//  SWCommonMacro.h
//  SWCommonFrame
//
//  Created by shaowei on 13-4-26.
//  Copyright (c) 2013年 shaowei. All rights reserved.
//


#ifndef SWCommonFrame_SWCommonMacro_h
#define SWCommonFrame_SWCommonMacro_h



//设备判断
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

//设备尺寸
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width) //屏幕宽度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height) //屏幕高度
#define SCREEN_HEIGHT_NOSTATUS ([[UIScreen mainScreen] bounds].size.height-20) //屏幕高度,去掉状态栏

//加载View-xib
#define VIEW_WITH_XIBNAME(viewName) [[[NSBundle mainBundle] loadNibNamed:XIBNAME_LOAD(viewName) owner:nil options:nil] lastObject]

#define VIEW_WITH_XIBNAME_AND_OWNER(viewName,ownerObj) [[[NSBundle mainBundle] loadNibNamed:XIBNAME_LOAD(viewName) owner:ownerObj options:nil] lastObject]

#define ARRAY_WITH_NAME(fileName,extName) [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:extName]]

//View动画过渡统一时间
#define VIEW_ANIMATION_DURATION 0.3f 

//获取系统版本号
#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


//系统目前的语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断iPhone 是否高清，判断是否是iPhone5
#define iPhoneIsRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断ARC
//#if __has_feature(objc_arc)
////compiling with ARC
//#else
//// compiling without ARC
//#endif

//安全的release，（便于以后arc的转换）
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//弧度与角度的转换
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

//颜色的快速输入
#define UIColorFromRGB0_255(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColorFromRGBA0_255(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//rgb颜色转换（16进制->10进制）
#define _UIColorFromHexadecimal(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorFromHexadecimal(hexadecimalValue) _UIColorFromHexadecimal(hexadecimalValue, 1.0)
#define UIColorFromHexadecimal_0x(hexadecimalValue) _UIColorFromHexadecimal(0x##hexadecimalValue, 1.0)
#define UIColorAFromHexadecimal_0x(hexadecimalValue, alphaValue) _UIColorFromHexadecimal(0x##hexadecimalValue, alphaValue)

//本地化
#define LocalizedString(string)  NSLocalizedString(string, nil)


//简化NSString 的创建方式
#define SWString(fmt, ...) [NSString stringWithFormat:fmt,##__VA_ARGS__]

////判断CGFloat 值是否等于0
//#define CGFLOAT_EQUAL_ZERO(value) fabsf(value - 0.0f) < 0.01f

//****************************** update 2014_02_20 ***************************************

//自定义的断言格式

#ifndef SW_ASSERT_FLAG
#define SW_ASSERT_FLAG 0
#endif

#if SW_ASSERT_FLAG
#define SWASSERT(bool,fmt, ...) NSAssert4(bool, @"%s-%d-%s:%@",__FILE__,__LINE__,__func__,SWString(fmt,##__VA_ARGS__))
#else
#define SWASSERT(bool,fmt, ...) \
if(!bool){\
NSLog((@"AssertLog:%s-%s [Line %d]:" fmt), __FILE__,__func__,__LINE__,##__VA_ARGS__);\
}
#endif

#define SWASSERT_SWITCH_OVER SWASSERT(0,@"Switch超出界限")

//判断系统版本 大于等于(great or equal to)版本号
#define OS_VERSION_G_E(version) (OS_VERSION >= version)
//判断系统版本 小于(less than)
#define OS_VERSION_LT(version) (OS_VERSION < version)

//****************************** update 2014_05_21 ***************************************

//创建UIAlertView
#define ALERT_VIEW_CREATE(title,content,btnTitle) \
[[UIAlertView alloc] initWithTitle:title \
message:content \
delegate:nil \
cancelButtonTitle:btnTitle \
otherButtonTitles:nil]

//展现 UIAlertView
#define ALERT_VIEW_SHOW(title,content,btnTitle) \
[ALERT_VIEW_CREATE(title,content,btnTitle) show]

//在主线程展现 UIAlertView
#define ALERT_VIEW_SHOW_IN_MAIN_THREAD(title,content,btnTitle) \
dispatch_async(dispatch_get_main_queue(), ^{ \
ALERT_VIEW_SHOW(title,content,btnTitle);\
})

//在主线程展现 UIAlertView
#define ALERT_VIEW(title,content) ALERT_VIEW_SHOW_IN_MAIN_THREAD(title,content,nil)
#define ALERT_VIEW_SURE(title,content) ALERT_VIEW_SHOW_IN_MAIN_THREAD(title,content,@"确定")

/**************************************** update 2014_06_19 ******************************************/

//检测float值 是否相等
#define __FLOAT_ACCURACY 0.0001f
#define FLOAT_EQUAL_WITH_ACCURACY(f1, f2, accuracy) (fabs(f1 * 1.0f - f2) < accuracy)
#define FLOAT_EQUAL(f1, f2) FLOAT_EQUAL_WITH_ACCURACY(f1, f2, __FLOAT_ACCURACY)
#define FLOAT_IS_ZERO_WITH_ACCURACY(f1,accuracy) FLOAT_EQUAL_WITH_ACCURACY(f1, 0, accuracy)
#define FLOAT_IS_ZERO(f1) FLOAT_IS_ZERO_WITH_ACCURACY(f1, __FLOAT_ACCURACY)

//#define FLOAT_NOT_EQUAL_WITH_ACCURACY(f1, f2, accuracy) (!FLOAT_EQUAL_WITH_ACCURACY(f1, f2, accuracy))
//#define FLOAT_NOT_EQUAL(f1, f2) (!FLOAT_EQUAL(f1, f2))
//#define FLOAT_NOT_ZERO_WITH_ACCURACY(f1,accuracy) (!FLOAT_IS_ZERO_WITH_ACCURACY(f1,accuracy))
//#define FLOAT_NOT_ZERO(f1) (!FLOAT_IS_ZERO(f1))

//判断屏幕尺寸
#define SCREEN_IS_LENGTH_IN_IPHONE ([[UIScreen mainScreen] bounds].size.height > 500)
#define SCREEN_IS_SHORT_IN_IPHONE  ([[UIScreen mainScreen] bounds].size.height < 500)

//状态栏在不同系统下的高度
#define STATUS_BAR_FLEXIBLE_20 (OS_VERSION_G_E(7)?20.0f:0)

/**************************************** update 2014_07_29 ******************************************/
#define SW_WARNING_DISMISS_START \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \

#define SW_WARNING_DISMISS_END \
_Pragma("clang diagnostic pop")

#define APPBUNDLE_ID [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"]
#define APPBUNDLE_VERSION_NUM [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
#define APPBUNDLE_APPNAME [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]

#define SWAutoResize568Height(height) (height) * SCREEN_HEIGHT / 568.0f

/********* Other ************/

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif

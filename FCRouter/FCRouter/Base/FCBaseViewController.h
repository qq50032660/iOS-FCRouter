//
//  FCBaseViewController.h
//  FCRouter
//
//  Created by fc_curry on 2019/8/2.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCRouterManager.h"
#import "FCRouterAction.h"


@interface FCBaseViewController : UIViewController

/**
 *  设置允许右滑动默认值
 *
 *  @return YES，允许， NO：不允许
 */
+ (BOOL)defaultAllowRightSlide;

+ (void)setDefaultAllowRightSlide:(BOOL)allow;

/**
 *  是否允许右滑动
 *
 *  @return YES，允许， NO：不允许
 */
-(BOOL)allowRightSlide;


/**
 导航控制器将要显示页面前，会调用handleWillOpenUrlWithParams:方法
 如果有依赖其他的页面，可以不弹出当前的页面，先监听其他的页面状态。
 比如，个人信息页面的弹出，依赖登录页面，先弹出登录页面，同时监听登录状态，等登录成功，同时登录页面pop掉后，延时打开当前需要打开的页面。有点复杂:-(
 */
- (BOOL)handleWillOpenUrlWithParams:(NSDictionary*)params;


/**
 页面是否是单例（即在导航堆栈中只会保留一个页面，当跳转到该页面的时候会将其堆栈之上的页面都pop掉）
 默认是NO
 */
+ (BOOL)isSingleton;


/**
 设置该页面是否以push的方式进行切换，否则以present的方式打开。
 默认是YES
 */
+ (BOOL)shouldPresent;

/**
 设置该页面是否以pop的方式进行切换，否则以dismiss的方式打开。
 默认是NO
 */
+ (BOOL)shouldDimiss;

/**
 *  当前页面依赖其他页面的时候,先调出改页面，然后由开发者在被依赖的页面写代码发通知。
 例如，“个人中心”页面的显示依赖于登录页面，先弹出登录页面，在登录成功后做通知，把“个人中心“页面弹出来。
 *
 *  @return <#return value description#>
 */
+ (NSString*)relyingOnOtherUrlSchemeWithParams:(NSDictionary*)params;

@end



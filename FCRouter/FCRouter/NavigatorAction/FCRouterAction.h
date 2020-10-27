//
//  FCRouterAction.h
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCRouterManager.h"

@interface FCRouterAction : UIViewController

/**
 *  初始化数据
 *
 *  @param navigationController 主导航器，全局只有一个
 *  @param schemeArray          scheme码，可以多个
 *  @param urlMappingDictionary map表
 */
+(void)loadWithRootNavigationController:(UINavigationController*)navigationController schemeArray:(NSArray*)schemeArray urlMappingDictionary:(NSDictionary*)urlMappingDictionary outsideUrlMappingDictionary:(NSDictionary*)outsideUrlMappingDictionary;

/**
 设置高级页面，当前页面如果是高级页面时，禁止跳转，需要等高级页面结束后，才可以跳转。
 */
+(void)setTopLevelViewControllers:(NSArray*)topLevelVCs;//废弃

+(void)setTopLevelViewControllers:(NSArray*)topLevelVCs exceptionViewControllers:(NSArray*)exceptionVCs;

//当前top vc是否是高级别的vc
+(BOOL)isCurrentVcTopLevelWithFromViewController:(UIViewController*)fromVc;//废弃

//当前top vc是否是高级别的vc 对于特殊的vc是允许跳转的
+(BOOL)isCurrentVcTopLevelWithFromViewController:(UIViewController*)fromVc url:(NSString*)urlString;

/**
 在当前的Navigator栈中打开新的URL
 参数fromViewController，可以不考虑，暂时没有用处，只是为方便扩展，暂时想到的而已
 例如:
 [[Navigator navigator] openURLString:@"a://shop?id=123"]
 或
 OpenURL(@"a://shop?id=123")
 */
+ (UIViewController *)openURLString:(id)urlString fromViewController:(UIViewController *)controller;

+(UIViewController *)openURLString:(id)urlString fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block;
/**
 *  输入一个NSString，或NSURL，统一转为NSURL
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+(NSURL*)checkAndGetStandardUrlWithUrl:(id)urlString;

/**
 *  根据一个url scheme 获取相应的实际view controller
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+(UIViewController*)checkAndGetViewcontrollerWithUrl:(id)urlString;

/**
 *  检测当前的url scheme是否存在合法的页面，如果有，则会返回相应的vc，否则返回nil。
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)checkAndGetViewControllerNameWithUrl:(id)urlString;

/**
 *  检测依赖的页面链接
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)checkRelyingOnViewControllerWithUrl:(id)urlString;


+(void)addScheme:(NSString*)scheme;

+(void)addUrlMap:(NSDictionary*)urlMappingDictionary;

#define ROOT_NAVIGATION_CONTROLLER    [FCRouterAction getRootNavigationViewController]
+(UINavigationController*)getRootNavigationViewController;

+(NSArray*)getSchemeArray;

+(NSString*)getPreviousViewContrllerFromStack;

+(BOOL)canOpenOutSideWithUrlScheme:(NSString*)url;

+(BOOL)canOpenUrlScheme:(NSString*)url;

@end



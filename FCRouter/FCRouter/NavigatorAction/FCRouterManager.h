//
//  FCRouterManager.h
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSDictionary*(^InitAfterViewControllerAlloc)(UIViewController* vc);

@protocol FCNavigatorViewControllerProtocal <NSObject>

@optional

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

/**
 导航控制器将要显示页面前，会调用handleWillOpenUrlWithParams:方法
 当返回NO时，将不弹出该页面，默认为YES；
 */
- (BOOL)handleWillOpenUrlWithParams:(NSDictionary*)params;

- (void)handleTransferPublicParams:(NSDictionary*)params;

/**
 *  设置页面间传递的参数，一般是第一个页面才会使用，之后的页面会自动传递。一般传递公用参数。
 *
 *  @param params <#params description#>
 */
-(void)setPublicParams:(NSDictionary*)params;

/**
 *  用于页面间传数据，尽量避免调用此函数
 *
 *  @return <#return value description#>
 */
-(NSDictionary*)getPublicParams;

/**
 是否开启Public参数传递
 
 @return <#return value description#>
 */
+ (BOOL)isEnablePublicParams;

@end

@interface FCRouterManager : NSObject

/**
 *  初始化数据
 *
 *  @param navigationController 主导航器，全局只有一个
 *  @param schemeArray          scheme码，可以多个
 *  @param urlMappingDictionary map表
 */
+(void)loadWithRootNavigationController:(UINavigationController*)navigationController schemeArray:(NSArray*)schemeArray privateUrlMappingDictionary:(NSDictionary*)privateUrlMappingDictionary publicUrlMappingDictionary:(NSDictionary *)publicUrlMappingDictionary;

/**
 设置高级页面，当前页面如果是高级页面时，禁止跳转，需要等高级页面结束后，才可以跳转,比如当前页面是登录页面时，是不能打开的，一般用于外部使用统链打开时使用。
 */
+(void)setTopLevelViewControllers:(NSArray*)topLevelVCs;//废弃

/**
 设置高级页面，当前页面如果是高级页面时，禁止跳转，需要等高级页面结束后，才可以跳转,比如当前页面是登录页面时，是不能打开的，一般用于外部使用统链打开时使用。
 但对于一些特殊页面，比如注册页面，是可以在登录页面上弹出来的。
 */
+(void)setTopLevelViewControllers:(NSArray*)topLevelVCs exceptionViewControllers:(NSArray*)exceptionVCs;

+(void)addScheme:(NSString*)scheme;

+(void)addUrlMap:(NSDictionary*)urlMappingDictionary;
/**
 在当前的FCNavigator栈中打开新的URL
 
 例如:
 [[FCNavigator navigator] openURLString:@"FC://shop?id=123"]
 
 OpenURL(@"FC://shop?id=123")  这里参数只能为基础参数 不能Arrary 和 Dictionary
 */
+ (void)openURLString:(id)urlString fromViewController:(UIViewController *)controller;
#define FCOpenUrl(Url) \
[FCRouterManager openURLString:(Url) fromViewController:nil]; \

+ (void)openURLString:(id)urlString fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block;
/**
 在当前的FCNavigator栈中打开新的URL
 只处理Arrary 和 Dictionary的情况
 */
+ (void)openURLString:(id)urlString fromViewController:(UIViewController *)controller params:(id)params;

+(BOOL)canOpenOutSideWithUrlScheme:(NSString*)url;

+(BOOL)canOpenUrlScheme:(NSString*)url;

/**
 *  通知等待的url页面弹出来。
 */
+(void)notifyToUrlSchemeQueue;

//丢弃队列中的url scheme
+(void)queuePopAllUrlscheme;
@end




//
//  FCRouterAction.m
//  FCRouter
//
//  Created by fc_curry on 2019/7/25.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "FCRouterAction.h"
#import "FCRouterManager.h"
#import <objc/message.h>
#import "UINavigationController+CustomPresent.h"

@interface FCRouterAction ()

@end

static FCRouterAction * _fcNavigator = nil;
static NSMutableDictionary* _fcUrlMapDictionary = nil;
static NSMutableArray* _fcUrlSchemeArray = nil;
static NSMutableArray* _fcTopLevelVcs = nil;
static NSMutableArray* _fcTopLevelExcetpionVcs = nil;

static NSMutableDictionary* _fcOutSideUrlMapDictionary = nil;

@implementation FCRouterAction

+ (void)initialize {
    _fcNavigator = [[self alloc] init];
    _fcUrlMapDictionary = [[NSMutableDictionary alloc]init];
    _fcOutSideUrlMapDictionary = [[NSMutableDictionary alloc]init];
    _fcUrlSchemeArray = [[NSMutableArray alloc]init];
    _fcTopLevelVcs = [[NSMutableArray alloc]init];
    _fcTopLevelExcetpionVcs = [[NSMutableArray alloc]init];
    [_fcUrlSchemeArray addObject:@"fc"];//默认添加一个，方便内部开发
}

+(void)openViewController:(UIViewController*)vc params:(NSDictionary*)params fromeVc:(UIViewController*)fromeVc
{
    if ([[vc class] respondsToSelector:@selector(isEnablePublicParams)]) {
        BOOL isEnablePublicParams = [[vc class] isEnablePublicParams];
        if (isEnablePublicParams) {
            [((id<FCNavigatorViewControllerProtocal>)vc) setPublicParams:params];
        }
    }
    
    if ([vc respondsToSelector:@selector(handleWillOpenUrlWithParams:)]) {
        if (![((id<FCNavigatorViewControllerProtocal>)vc) handleWillOpenUrlWithParams:params]) {
            //如果响应对象实现handleWillOpenUrlWithParams方法 并且 handleWillOpenUrlWithParams 方法返回了NO, 则终止后续行为
            return;
        }
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([vc respondsToSelector:@selector(universal_handleUrlScheme)]) {//处理通用功能，可以是脱离页面的scheme跳转
        ((void(*)(id, SEL))objc_msgSend)(vc, @selector(universal_handleUrlScheme));
        return;
    }
#pragma clang diagnostic pop
    
    BOOL isSingleton = NO;
    if ([[vc class] respondsToSelector:@selector(isSingleton)]) {
        isSingleton = [[vc class] isSingleton];
    }
    
    if (YES == isSingleton) {
        [self pushSingleViewController:vc];
    }
    else
    {
        if (fromeVc) {
            [self pushViewControllerFromPresentViewCtronttler:fromeVc toViewContrller:vc];
        }
        if (!fromeVc) {
            [self pushViewController:vc];
        }
    }
}

+(void)pushSingleViewController:(UIViewController*)vc
{
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:[[self class] getRootNavigationViewController].viewControllers];
    __block BOOL isExit = NO;
    [controllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == vc) {
            isExit = YES;
        }
    }];
    if (isExit) {
        if (vc != [controllers lastObject]) {
            UIViewController* topVc = [[[self class] getRootNavigationViewController] topViewController];
            if ([[topVc class] respondsToSelector:@selector(shouldDimiss)]) {
                if ([[(id<FCNavigatorViewControllerProtocal>)topVc class] shouldDimiss] == YES) {
                    [[[self class] getRootNavigationViewController] dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
            }
            [[[self class] getRootNavigationViewController] popToViewController:vc animated:YES];
        }
        else {
            [vc viewWillAppear:NO];
            [vc viewDidAppear:NO];
        }
    }else{
        [self pushViewController:vc];

    }

}

+ (void)pushViewController:(UIViewController *)controller{
    
    if ([[controller class] respondsToSelector:@selector(shouldPresent)]) {
        if ([[(id<FCNavigatorViewControllerProtocal>)controller class] shouldPresent] == YES) {
            
            [[[self class] getRootNavigationViewController] fcPresentViewController:controller];
            return;
        }
    }
    [[[self class] getRootNavigationViewController] pushViewController:controller animated:YES];
}
+(void)pushViewControllerFromPresentViewCtronttler:(UIViewController*)fromeVc toViewContrller:(UIViewController*)toVc{
    [fromeVc.navigationController pushViewController:toVc animated:YES];
}
+ (UIViewController *)obtainControllerWithClassName:(NSString *)viewControllerClassName {
    if (viewControllerClassName == nil) return nil;
    Class class = NSClassFromString(viewControllerClassName);
    if ([class respondsToSelector:@selector(isSingleton)] && [class isSingleton]) {
        
        __block UIViewController *newController;
        [[[[self class] getRootNavigationViewController] viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:class]) {
                newController = obj;
            }
        }];
        return newController ?: [class new];
    }
    return [class new];
}

+(NSURL*)checkAndGetStandardUrlWithUrl:(id)urlString
{
    if ([urlString isKindOfClass:[NSURL class]]) {
        return urlString;
    }
    
    NSString* tempString = nil;
    if ([urlString isKindOfClass:[NSString class]]) {
        tempString = urlString;
    }
    
    
    if ((tempString).length < 1) {
        return nil;
    }
    tempString = [tempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL* url = [NSURL URLWithString:tempString];
    return url;
}

+(NSString*)checkAndGetViewControllerNameWithUrl:(id)urlString
{
    NSURL* url = [self checkAndGetStandardUrlWithUrl:urlString];
    if (url == nil) {
        return nil;
    }
    //查看scheme是否注册过
    __block id schemeObj;
    [_fcUrlSchemeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj lowercaseString] isEqualToString:[[url scheme]lowercaseString]] == YES) {
            schemeObj = obj;
        }
    }];
    if (schemeObj == nil) {
        return nil;
    }
    
    //寻找注册表中是否含有该host
    __block id hostObj;
    NSLog(@"host == %@",url.host);
    [_fcUrlMapDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[key lowercaseString] isEqualToString:[[url host]lowercaseString]]) {
            hostObj = key;
        }
    }];
    
    if (hostObj == nil) {
        return nil;
    }
    
    //生成页面
    NSString* value = [_fcUrlMapDictionary objectForKey:hostObj];
    return value;
}

+(UIViewController*)checkAndGetViewcontrollerWithUrl:(id)urlString
{
    NSString* className = [self checkAndGetViewControllerNameWithUrl:urlString];
    if ((className).length <= 0) {
        return nil;
    }
    UIViewController* vc = [self obtainControllerWithClassName:className];
    if (vc == nil) {
        return nil;
    }
    return vc;
}

+(NSString*)checkRelyingOnViewControllerWithUrl:(id)urlString
{
    NSString* className = [self checkAndGetViewControllerNameWithUrl:urlString];
    if ((className).length <= 0) {
        return nil;
    }
    
    NSURL* url = [self checkAndGetStandardUrlWithUrl:urlString];
    NSDictionary* params = [self parseQuery:url];
    Class class = NSClassFromString(className);
    if (class) {
        if ([class respondsToSelector:@selector(relyingOnOtherUrlSchemeWithParams:)]) {
            NSString* relyingUrl = [class relyingOnOtherUrlSchemeWithParams:params];
            if (relyingUrl) {
                return relyingUrl;
            }
        }
    }
    
    return nil;
}

#pragma mark - public methods


+(BOOL)isCurrentVcTopLevelWithFromViewController:(UIViewController*)fromVc
{
    UIViewController* topVc = [ROOT_NAVIGATION_CONTROLLER topViewController];
    for (NSString* className in _fcTopLevelVcs) {
        if ([topVc class] == NSClassFromString(className)) {
            if ([fromVc class] == NSClassFromString(className)) {
                return NO;
            }
            return YES;
        }
    }
    
    return NO;
}

+(BOOL)isCurrentVcTopLevelWithFromViewController:(UIViewController*)fromVc url:(NSString*)urlString
{
    
    NSString* className = [self checkAndGetViewControllerNameWithUrl:urlString];
    if ((className).length > 0) {
        
        __block id vc;
        [_fcTopLevelExcetpionVcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj lowercaseString] isEqualToString:[className lowercaseString]] == YES) {
                vc = obj;
            }
        }];
        
        if (vc != nil) {
            return NO;
        }
    }
    
    
    UIViewController* topVc = [ROOT_NAVIGATION_CONTROLLER topViewController];
    for (NSString* className in _fcTopLevelVcs) {
        if ([topVc class] == NSClassFromString(className)) {
            if ([fromVc class] == NSClassFromString(className)) {
                return NO;
            }
            return YES;
        }
    }
    
    
    return NO;
}

+(UIViewController *)openURLString:(id)urlString fromViewController:(UIViewController *)controller initAfterAlloc:(InitAfterViewControllerAlloc)block
{
    UIViewController* vc = [self checkAndGetViewcontrollerWithUrl:[urlString copy]];
    if (vc == nil) {
        return nil;
    }
    
    NSURL* url = [self checkAndGetStandardUrlWithUrl:urlString];
    if (url == nil) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[self parseQuery:url]];
    if (block) {
        NSDictionary* tempDit = block(vc);
//        WDAssert([tempDit isKindOfClass:[NSDictionary class]], @"不是NSDictionary类型");
        if ([tempDit isKindOfClass:[NSDictionary class]]) {
            [dic addEntriesFromDictionary:tempDit];
        }
    }
    
    //打开页面
    [self openViewController:vc params:dic fromeVc:vc];
    return vc;
}

+(UIViewController *)openURLString:(id)urlString fromViewController:(UIViewController *)controller
{
    UIViewController* vc = [self checkAndGetViewcontrollerWithUrl:[urlString copy]];
    if (vc == nil) {
        return nil;
    }
    
    NSURL* url = [self checkAndGetStandardUrlWithUrl:urlString];
    if (url == nil) {
        return nil;
    }
    NSDictionary *dic = [self parseQuery:url];
    
    //打开页面
    [self openViewController:vc params:dic fromeVc:controller];
    return vc;
}

+(void)loadWithRootNavigationController:(UINavigationController *)navigationController schemeArray:(NSArray *)schemeArray urlMappingDictionary:(NSDictionary *)urlMappingDictionary outsideUrlMappingDictionary:(NSDictionary *)outsideUrlMappingDictionary
{
    if (navigationController == nil) {
        navigationController = [[self class] getRootNavigationViewController];
        if (navigationController == nil) {
            return;
        }
    }
    [_fcUrlSchemeArray addObjectsFromArray:[schemeArray copy]];
    [_fcUrlMapDictionary addEntriesFromDictionary:[urlMappingDictionary copy]];
    [_fcUrlMapDictionary addEntriesFromDictionary:[outsideUrlMappingDictionary copy]];
    [_fcOutSideUrlMapDictionary addEntriesFromDictionary:[outsideUrlMappingDictionary copy]];
    //todo 检测是否有该vc
}

+ (UINavigationController *)getRootNavigationViewController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbarVC = (UITabBarController *)window.rootViewController;
        UINavigationController *nav = tabbarVC.viewControllers[tabbarVC.selectedIndex];
//        UIViewController *currentVC = nav.jt_viewControllers[nav.jt_viewControllers.count - 1];
//        return currentVC.navigationController;
        return nav;
    }
    return (UINavigationController *)window.rootViewController;
}
+ (UITabBarController *)getRootController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbarVC = (UITabBarController *)window.rootViewController;
        return tabbarVC;
    }
    return window.rootViewController;
}
+(void)setTopLevelViewControllers:(NSArray *)topLevelVCs
{
    if (topLevelVCs.count <= 0) {
        return;
    }
    [_fcTopLevelVcs addObjectsFromArray:topLevelVCs];
}

+(void)setTopLevelViewControllers:(NSArray *)topLevelVCs exceptionViewControllers:(NSArray *)exceptionVCs
{
    if (topLevelVCs.count <= 0) {
        return;
    }
    [_fcTopLevelVcs addObjectsFromArray:topLevelVCs];
    
    if (exceptionVCs.count <= 0) {
        return;
    }
    [_fcTopLevelExcetpionVcs addObjectsFromArray:exceptionVCs];
}

+(void)addScheme:(NSString*)scheme
{
    [_fcUrlSchemeArray addObject:[scheme copy]];
}

+(void)addUrlMap:(NSDictionary*)urlMappingDictionary
{
    [_fcUrlMapDictionary addEntriesFromDictionary:[urlMappingDictionary copy]];
}

+(NSArray*)getSchemeArray
{
    return [_fcUrlSchemeArray copy];
}

+(NSString*)getPreviousViewContrllerFromStack
{
    if ([[[self class] getRootNavigationViewController] viewControllers].count <= 1) {
        return nil;
    }
    UIViewController* vc = [[[[self class] getRootNavigationViewController] viewControllers] objectAtIndex:([[[self class] getRootNavigationViewController] viewControllers].count-2)];
    return NSStringFromClass([vc class]);
}

+(BOOL)canOpenUrl:(NSString*)url inMapDict:(NSDictionary*)dict
{
    if ((url).length < 4) {
        return NO;
    }
    NSURL* uu = [NSURL URLWithString:(url)];
    
    __block NSString *key;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj lowercaseString] isEqualToString:[[uu host] lowercaseString]]) {
            key = obj;
        }
    }];

    if (key.length > 0) {
        return YES;
    }
    return NO;
}

+(BOOL)canOpenOutSideWithUrlScheme:(NSString*)url
{
    return [self canOpenUrl:url inMapDict:_fcOutSideUrlMapDictionary];
}

+(BOOL)canOpenUrlScheme:(NSString*)url
{
    return [self canOpenUrl:url inMapDict:_fcUrlMapDictionary];
}

+ (NSDictionary *)parseQuery:(NSURL *)url {
    NSString *query = [url query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            continue;
        }
        
        //     NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //stringByRemovingPercentEncoding
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end

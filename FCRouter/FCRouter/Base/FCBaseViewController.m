//
//  FCBaseViewController.m
//  FCRouter
//
//  Created by fc_curry on 2019/8/2.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#define ISIOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

#import "FCBaseViewController.h"
#import "UINavigationController+CustomPresent.h"

@interface FCBaseViewController ()<FCNavigatorViewControllerProtocal>
{
    void (^_hideAction)(void);
    BOOL _allowRightSlide;
}
@end

@implementation FCBaseViewController


#pragma mark ---------------------System---------------------
#pragma mark 初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _allowRightSlide = [self allowRightSlide];
    }
    return self;
}

static BOOL fcBaseViewController_default_allowRightSlide;
+ (BOOL)defaultAllowRightSlide
{
    return fcBaseViewController_default_allowRightSlide;
}
+ (void)setDefaultAllowRightSlide:(BOOL)allow
{
    fcBaseViewController_default_allowRightSlide = allow;
}

-(BOOL)allowRightSlide
{
    return [self.class defaultAllowRightSlide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    
//[NSString stringWithFormat:@"内存警告:%@", NSStringFromClass([self class])]
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:self.preferredStatusBarStyle animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_allowRightSlide == NO) {
        if ([ROOT_NAVIGATION_CONTROLLER respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            ROOT_NAVIGATION_CONTROLLER.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (_allowRightSlide == NO) {
        if ([ROOT_NAVIGATION_CONTROLLER respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            ROOT_NAVIGATION_CONTROLLER.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor getWithIntColor:0xF4F5FA];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    if (ISIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self setBackWithTitle:@""];
}

-(void)leftTopAction:(id)sender
{
    if ([[self class] shouldDimiss] == YES) {
        [self.navigationController fcDismissViewController];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- virtual method
/**
 页面是否是单例（即在导航堆栈中只会保留一个页面，当跳转到该页面的时候会将其堆栈之上的页面都pop掉）
 默认是NO
 */
+ (BOOL)isSingleton
{
    return NO;
}

/**
 设置该页面是否以push的方式进行切换，否则以present的方式打开。
 默认是NO
 */
+ (BOOL)shouldPresent
{
    
    return NO;
}

/**
 设置该页面是否以pop的方式进行切换，否则以dismiss的方式打开。
 默认是NO
 */
+ (BOOL)shouldDimiss
{
    return NO;
}

/**
 导航控制器将要显示页面前，会调用handleWillOpenUrlWithParams:方法
 如果有依赖其他的页面，可以不弹出当前的页面，先监听其他的页面状态。
 比如，个人信息页面的弹出，依赖登录页面，先弹出登录页面，同时监听登录状态，等登录成功，同时登录页面pop掉后，延时打开当前需要打开的页面。有点复杂:-(
 */
- (BOOL)handleWillOpenUrlWithParams:(NSDictionary*)params
{
    return YES;
}

/**
 *  当前页面依赖其他页面的时候,先调出改页面，然后由开发者在被依赖的页面写代码发通知。
 例如，“个人中心”页面的显示依赖于登录页面，先弹出登录页面，在登录成功后做通知，把“个人中心“页面弹出来。
 *
 *  @return <#return value description#>
 */
+ (NSString*)relyingOnOtherUrlSchemeWithParams:(NSDictionary*)params
{
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  FCTabBarController.m
//  FCRouter
//
//  Created by fc_curry on 2019/8/5.
//  Copyright © 2019 fc_curry. All rights reserved.
//

#import "FCTabBarController.h"
#import "FCBaseViewController.h"
#import "FCNavigationController.h"

@interface FCTabBarController ()

@end

@implementation FCTabBarController

static FCTabBarController* _fcSharedTabBarViewController = nil;
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fcSharedTabBarViewController = [[FCTabBarController alloc] init];
    });
    return _fcSharedTabBarViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupChildController];

}
#pragma mark - 重构新增的方法

- (void)setupChildController {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *configPath = [docDir stringByAppendingString:@"MainTabbarConfig.json"];
    NSData *data = [NSData dataWithContentsOfFile:configPath];
    if (data == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MainTabbarConfig" ofType:@"json"];
        data = [NSData dataWithContentsOfFile:path];
    }
    NSArray *configArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray<UIViewController *> *arrayVC = [NSMutableArray arrayWithCapacity:4];
    for (NSDictionary *dict in configArray) {
        [arrayVC addObject:[self creatChildController:dict]];
    }
    self.viewControllers = arrayVC;
}

- (UIViewController *)creatChildController:(NSDictionary *)dict {
    if ([[dict allKeys] count] == 1) {
        UIViewController * vc = [[UIViewController alloc]init];
        return vc;
    } else {
        NSString *className = dict[@"clsName"], *title = dict[@"title"], *imgName = dict[@"imageName"];
        if (NSClassFromString(className)) {
            Class class = NSClassFromString(className);
            
            FCBaseViewController *controller = [[class alloc] init];
            
            controller.title = title;
            controller.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@", imgName]];
            [controller.tabBarItem setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected", imgName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            //            controller.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected", imgName]];
            FCNavigationController *nav = [[FCNavigationController alloc] initWithRootViewController:controller];
            NSDictionary * titleColorAttributeDict = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
            [controller.tabBarItem setTitleTextAttributes:titleColorAttributeDict forState:UIControlStateNormal];
            
            NSDictionary * titleSelectColorAttributeDict = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
            [controller.tabBarItem setTitleTextAttributes:titleSelectColorAttributeDict forState:UIControlStateSelected];
            
            return nav;
        }
        return [UIViewController new];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
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

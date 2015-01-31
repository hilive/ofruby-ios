#import "AppDelegate.h"
#import "SelectViewController.h"
#import "HelpViewController.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];

    tabBarController = [[UITabBarController alloc] init];
    tabBarController.title = @"";

    UIViewController* tab1 = [[SelectViewController alloc]init];
    UIImage* icon1 = [UIImage imageNamed:@"tabbar_files.png"];
    tab1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Files" image:icon1 tag:0];

    UIViewController* tab2 = [[HelpViewController alloc]init];
    UIImage* icon2 = [UIImage imageNamed:@"tabbar_samples.png"];
    tab2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Samples" image:icon2 tag:0];

    NSArray* tabs = [NSArray arrayWithObjects:tab1, tab2, nil];
    [tabBarController setViewControllers:tabs animated:NO];

    naviController = [[UINavigationController alloc]
                      initWithRootViewController:tabBarController];

    [self.window addSubview:naviController.view];
    [self.window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
　　NSNotification* n = [NSNotification notificationWithName:@"applicationDidEnterBackground" object:self];
　　[[NSNotificationCenter defaultCenter] postNotification:n];
}

@end

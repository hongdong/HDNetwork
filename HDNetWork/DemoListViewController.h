

#import <UIKit/UIKit.h>

typedef UIViewController *(^ViewControllerHandler)();

@interface DemoListViewController : UIViewController

+ (void)registerWithTitle:(NSString *)title handler:(ViewControllerHandler)handler;

@end

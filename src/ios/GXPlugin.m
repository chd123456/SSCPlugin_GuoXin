/********* GXPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "GKStatic.h"



@interface SSCTempVC : UIViewController
@property(nonatomic, strong) NSNumber* b;

@end

@implementation SSCTempVC

- (void)viewDidAppear:(BOOL)animated
{
    _b = 0;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{

    if (([_b  isEqual: @10010]) && ([[SSCTempVC getCurrentVC] isEqual:self]))    {
    [[self parentViewController] dismissViewControllerAnimated:false completion:^{
        
    }];
    }
}

+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
        
       // <span style="font-family: Arial, Helvetica, sans-serif;">//  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}


@end


@interface GXPlugin : CDVPlugin {
    // Member variables go here.
}
@property(nonatomic, strong) NSString * barcode;
@property(nonatomic, strong) UINavigationController * nav;
- (void)startTakePhoto:(CDVInvokedUrlCommand*)command;
    
@end

@implementation GXPlugin


- (void)pluginInitialize {
    //通知：
    // MARK:第一步（国信通知：）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startGuoXin:) name:@"startDocumentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guoXinInfos:) name:@"uploadImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReletived:) name:@"delfFileDocumentNotification" object:nil];
}

- (void)dealloc{
    //移除通知：
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startDocumentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadImageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"delfFileDocumentNotification" object:nil];
    self.barcode = nil;
}
-(void)startGuoXin:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSLog(@"%@",dic);
    self.barcode = dic[@"barcode"];
    
}
-(void)guoXinInfos:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSLog(@"其实是同一个barcode%@",dic[@"barcode"]);
}
-(void)deleteReletived:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSLog(@"国信影像删除返回的通知%@",dic);
}
- (void)startTakePhoto:(CDVInvokedUrlCommand*)command
{
    
    NSDictionary* paramters = [command.arguments objectAtIndex:0];
    NSLog(@"传来的参数：%@",paramters);
  
    [self.commandDelegate runInBackground:^{
        
        self.viewController.hidesBottomBarWhenPushed = YES;
        
        NSString * token = paramters[@"param"][@"token"];
        NSString * deliveredBarcode = paramters[@"param"][@"barcode"];
        NSString * fordername = paramters[@"param"][@"fordername"];
        SSCTempVC *tempVC = [[SSCTempVC alloc]init];
        
        self.nav = [[UINavigationController alloc]initWithRootViewController:tempVC];
        [self.viewController presentViewController:self.nav animated:NO completion:^{
            
            [GKStatic startDocument:self.nav.viewControllers[0] withCustomCode:paramters[@"customcode"] withGuestCode:paramters[@"guestcode"] withUserName:paramters[@"username"] withPassword:@"123" withDatetime:paramters[@"datetime"] withTick:paramters[@"ticket"] withServerName:paramters[@"servername"] withToken: token withBarcode:deliveredBarcode withForderName:fordername];
            
            if (self.barcode != nil) {
                CDVPluginResult * barcodeResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self.barcode];
                [self.commandDelegate sendPluginResult:barcodeResult callbackId:command.callbackId];
            }
            tempVC.b = @10010;
            
        }];
        
        
        
    }];
    
    
}

//删除：H5来调



@end



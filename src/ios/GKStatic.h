//
//  GKStatic.h
//  GKStatic
//
//  Created by gordon on 2016/10/9.
//  Copyright © 2016年 gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GKStatic : NSObject


+ (instancetype)sharedInstance;

/* 启动插件
 * serverUrl:服务器地址
 * guestCode:授权码
 * userName:当前用户帐号
 * password:密码
 * dataTime:调用接口的时间
 * tick:调用接口的密码，动态生成
 * serverName:startSiitApp
 * token:业务唯一标记
 * barcode:条码，可以为空
 * forderName:明细类型
 */
+ (void)startDocument:(UIViewController *) viewController
        withCustomCode:(NSString *) customCode
        withGuestCode:(NSString *) guestCode
         withUserName:(NSString *) userName
         withPassword:(NSString *) password
         withDatetime:(NSString *) dateTime
             withTick:(NSString *) tick
       withServerName:(NSString *) serverName
            withToken:(NSString *) token
          withBarcode:(NSString *) barcode
       withForderName:(NSString *) forderName;

/*删除文件夹
 *barcode:条码
 */
+ (void)delFileDocumnet:(NSString *)barcode;


@end

//
//  UIViewController+Alert.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 07/01/21.
//

#import "UIViewController+Alert.h"


@implementation UIViewController (Alert)

- (void)showAlert:(NSString *)message{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:3.f];
}

@end

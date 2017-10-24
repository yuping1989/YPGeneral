//
//  UIAlertView+YPKit.m
//  HuoQiuJiZhang-buyer
//
//  Created by 喻平 on 14-4-2.
//  Copyright (c) 2014年 com.huoqiu. All rights reserved.
//

#import "UIAlertView+YPKit.h"
#import <objc/runtime.h>

static const int alert_block_key;

@implementation UIAlertView (YPKit)

+ (UIAlertView *)showAlertWithTitle:(NSString *)title {
    return [UIAlertView showAlertWithTitle:title
                                   message:nil];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message {
    return [UIAlertView showAlertWithTitle:title
                                   message:message
                         cancelButtonTitle:@"确定"];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [UIAlertView showAlertWithTitle:title
                                   message:message
                         cancelButtonTitle:cancelButtonTitle
                         otherButtonTitles:nil
                                completion:nil];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                    okButtonClicked:(void (^)(void))okButtonClicked {
    return [UIAlertView showAlertWithTitle:title
                             okButtonTitle:@"确定"
                           okButtonClicked:okButtonClicked];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                      okButtonTitle:(NSString *)okButtonTitle
                    okButtonClicked:(void (^)(void))okButtonClicked {
    return [UIAlertView showAlertWithTitle:title
                                   message:nil
                             okButtonTitle:okButtonTitle
                           okButtonClicked:okButtonClicked];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                      okButtonTitle:(NSString *)okButtonTitle
                    okButtonClicked:(void (^)(void))okButtonClicked {
    return [UIAlertView showAlertWithTitle:title
                                   message:message
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[okButtonTitle]
                                completion:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1 && okButtonClicked) {
                                        okButtonClicked();
                                    }
                                }];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSArray *)otherButtonTitles
                         completion:(void (^)(NSInteger buttonIndex))completion {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    if (cancelButtonTitle) {
        [alert addButtonWithTitle:cancelButtonTitle];
    }
    if (otherButtonTitles.count > 0) {
        for (int i = 0; i < otherButtonTitles.count; i++) {
            [alert addButtonWithTitle:otherButtonTitles[i]];
        }
    }
    [alert setCancelButtonIndex:0];
    [alert showWithCompletionBlock:completion];
    return alert;
}

+ (UIAlertView *)showPlainTextInputAlertWithTitle:(NSString *)title
                                          message:(NSString *)message
                                   textFieldBlock:(void (^)(UITextField *textField))textFieldBlock
                                    okButtonTitle:(NSString *)okButtonTitle
                                       completion:(void (^)(NSString *text))okButtonClicked {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:okButtonTitle, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    if (textFieldBlock) {
        textFieldBlock(textField);
    }
    
    [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
        if (okButtonClicked) {
            okButtonClicked(textField.text);
        }
    }];
    return alert;
}

- (void)showWithCompletionBlock:(void (^)(NSInteger))completionBlock {
    if (completionBlock) {
        objc_setAssociatedObject(self, &alert_block_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.delegate = self;
    }
    
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^completionBlock)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &alert_block_key);
    if(!completionBlock) return;
    
    completionBlock(buttonIndex);
}

@end

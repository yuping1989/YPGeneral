//
//  YPDateUtilController.m
//  YPKit
//
//  Created by 喻平 on 15/8/20.
//  Copyright (c) 2015年 YPKit. All rights reserved.
//

#import "YPDateUtilController.h"
#import "YPSettingItem.h"

@interface YPDateUtilController ()
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet UILabel *minuteLabel;
@property (nonatomic, weak) IBOutlet UILabel *hourLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet YPSettingItem *topItem;
@property (nonatomic, weak) IBOutlet YPSettingItem *centerItem;
@property (nonatomic, weak) IBOutlet YPSettingItem *bottomItem;

@property (nonatomic, weak) IBOutlet UIButton *pickerButton;
@end

@implementation YPDateUtilController

- (void)viewDidLoad {
    [super viewDidLoad];
    int date = [[NSDate date] timeIntervalSince1970];
    
    _secondLabel.text = [YPDateUtil dateDiffStringWithFromTimeInterval:date - 10];
    _minuteLabel.text = [YPDateUtil dateDiffStringWithFromTimeInterval:date - 3 * 60];
    _hourLabel.text = [YPDateUtil dateDiffStringWithFromTimeInterval:date - 60 * 60 * 3];
    _dayLabel.text = [YPDateUtil dateDiffStringWithFromTimeInterval:date - 60 * 60 * 40];
    _dateLabel.text = [YPDateUtil dateDiffStringWithFromTimeInterval:date - 60 * 60 * 24 * 3];
    
    _topItem.title = @"顶部标题";
    _topItem.text = @"顶部内容";
    _centerItem.title = @"中间标题";
    _centerItem.text = @"中间内容";
    _bottomItem.title = @"底部标题";
    _bottomItem.text = @"底部内容";
    [_topItem topStyle];
    [_centerItem centerStyle];
    [_bottomItem bottomStyle];
    NSLog(@"second-->%@", NSStringFromCGRect(self.view.frame));
    self.centerItem.arrowImage = nil;
    _topItem.leftImage = [UIImage imageNamed:@"icon_discovery_joined"];
    _bottomItem.rightImage = [UIImage imageNamed:@"icon_discovery_joined"];
    [self.centerItem setTouchUpInsideEventBlock:^(id sender) {
        NSLog(@"setTouchUpInsideEventBlock");
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

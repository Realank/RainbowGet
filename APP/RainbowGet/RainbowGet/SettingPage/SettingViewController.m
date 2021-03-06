//
//  SettingViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "SettingViewController.h"
#import "PopUpBigViewForNotice.h"
#import "ThemeTableViewController.h"
#import "LeanCloudFeedback.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    [self refreshUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)refreshUI{
    self.view.tintColor = [ThemeColor currentColor].tintColor;
    self.view.backgroundColor = [ThemeColor currentColor].tintColor;
    self.tableView.backgroundColor = [ThemeColor currentColor].tintColor;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuse"];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"主题";
            cell.detailTextLabel.text = [ThemeColor currentColor].themeName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"关于";
            cell.detailTextLabel.text = [CommTool bundleVersion];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"帮助";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
//        case 3:
//        {
//            cell.textLabel.text = @"支付宝打赏";
//            cell.detailTextLabel.text = @"realank@126.com";
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//        }
//            break;
        case 3:
        {
            cell.textLabel.text = @"意见反馈";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    cell.textLabel.textColor = [ThemeColor currentColor].foreColor;
    cell.detailTextLabel.textColor = DefaultGrayColor;
    cell.backgroundColor = [ThemeColor currentColor].tintColor;
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [ThemeColor currentColor].selectedTintColor;
    cell.tintColor = DefaultGrayColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CommTool commCellHeight];
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            ThemeTableViewController *detailViewController = [[ThemeTableViewController alloc] init];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
            break;
        case 1:
        {
            [PopUpBigViewForNotice showAppIntroduce];
        }
            break;
        case 2:
        {
            [PopUpBigViewForNotice showAppHelp];
        }
            break;
        case 3:
        {
            LCUserFeedbackViewController *feedbackViewController = [[LCUserFeedbackViewController alloc] init];
            feedbackViewController.feedbackTitle = @"意见反馈";
            feedbackViewController.contact = nil;
            feedbackViewController.navigationBarStyle = LCUserFeedbackNavigationBarStyleNone;
            
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}


@end

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
    return 3;
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
            cell.textLabel.text = @"技术支持 / 打赏支付宝账号";
            cell.detailTextLabel.text = @"realank@126.com";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
            break;
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.textColor = [ThemeColor currentColor].foreColor;
    cell.detailTextLabel.textColor = [ThemeColor currentColor].grayColor;
    cell.backgroundColor = [ThemeColor currentColor].tintColor;
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [ThemeColor currentColor].selectedTintColor;
    cell.tintColor = [ThemeColor currentColor].grayColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
        default:
            break;
    }
    
    
}


@end

//
//  ThemeTableViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ThemeTableViewController.h"
#import "CustomThemeViewController.h"
@interface ThemeTableViewController ()

@property (nonatomic, strong) NSArray* themes;

@end

@implementation ThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主题";
    _themes = [[ThemeColor allThemeColor] copy];
    UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithTitle:@"编辑自定义主题" style:UIBarButtonItemStylePlain target:self action:@selector(customTheme)];
    [self.navigationItem setRightBarButtonItem:barbutton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _themes = [[ThemeColor allThemeColor] copy];
    [self refreshTheme];
}

- (void)customTheme{
    CustomThemeViewController* vc = [[CustomThemeViewController alloc] init];
    vc.preloadTheme = [ThemeColor customTheme];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshTheme{
    self.view.tintColor = [ThemeColor currentColor].tintColor;
    self.navigationController.view.tintColor = [ThemeColor currentColor].tintColor;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuse"];
    ThemeColor* theme = _themes[indexPath.row];
    cell.textLabel.text = theme.themeName;
    cell.textLabel.textColor = theme.foreColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
//    cell.detailTextLabel.text = @"文字颜色";
//    cell.detailTextLabel.textColor = theme.foreColor;
    cell.backgroundColor = theme.tintColor;
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = theme.selectedTintColor;
    cell.tintColor = DefaultGrayColor;
    if ([theme.themeName isEqualToString: [ThemeColor currentColor].themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CommTool commCellHeight];
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThemeColor* theme = _themes[indexPath.row];
    [ThemeColor setTheme:theme];
    [self refreshTheme];
}


@end

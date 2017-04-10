//
//  ClassesListViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/4.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ClassesListViewController.h"
#import "WordModel.h"
#import "WordBoardViewController.h"
#import "PersistWords.h"
#import "WordsListViewController.h"
#import "PortraitWordBoardViewController.h"
@interface ClassesListViewController ()

@end

@implementation ClassesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = [ThemeColor currentColor].tintColor;
    self.view.backgroundColor = [ThemeColor currentColor].tintColor;
    self.tableView.backgroundColor = [ThemeColor currentColor].tintColor;
    self.title = _classes.firstObject.bookName;
//    self.tableView.backgroundColor = TINT_COLOR;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![CommTool isIPAD]) {
         [self orientationChange];
    }
   
}

- (void)orientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    
}

- (void)pushWordBoardToClass:(ClassModel*)aclass withFullScreen:(BOOL)fullScreen{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:fullScreen forKey:@"FullScreenWordBoard"];
    if (fullScreen) {
        [self pushFullScreenWordBoardWithClass:aclass withAnimate:NO];
    }else{
        [self pushPortraitWordBoardWithClass:aclass withAnimate:NO];
    }
}

- (void)pushFullScreenWordBoardWithClass:(ClassModel*)aclass withAnimate:(BOOL)animate{
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [aclass loadWordsWithComplete:^{
        [SVProgressHUD dismiss];
        if (aclass.words.count == 0) {
            weakSelf.view.userInteractionEnabled = YES;
            return;
        }
        WordBoardViewController *vc = [[WordBoardViewController alloc] init];
        vc.aclass = aclass;
        vc.pushWordBoardDeleagte = self;
        [weakSelf.navigationController pushViewController:vc animated:animate];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
        });
    }];
}

- (void)pushPortraitWordBoardWithClass:(ClassModel*)aclass withAnimate:(BOOL)animate{
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [aclass loadWordsWithComplete:^{
        [SVProgressHUD dismiss];
        if (aclass.words.count == 0) {
            weakSelf.view.userInteractionEnabled = YES;
            return;
        }
        PortraitWordBoardViewController* vc = [[PortraitWordBoardViewController alloc] init];
        vc.aclass = aclass;
        vc.pushWordBoardDeleagte = self;
        [weakSelf.navigationController pushViewController:vc animated:animate];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classes.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
//    header.backgroundColor = [UIColor clearColor];
//    return header;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuse"];
    cell.textLabel.textColor = [ThemeColor currentColor].foreColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.backgroundColor = [ThemeColor currentColor].tintColor;
    

    ClassModel* aclass = _classes[indexPath.row];
    cell.textLabel.text = aclass.className;
    cell.detailTextLabel.text = aclass.classTitle;
    cell.detailTextLabel.textColor = [ThemeColor currentColor].grayColor;
    cell.tintColor = [ThemeColor currentColor].grayColor;
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [ThemeColor currentColor].selectedTintColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ClassModel* aclass = _classes[indexPath.row];
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [aclass loadWordsWithComplete:^{
        [SVProgressHUD dismiss];
        [weakSelf pushToWordsListWithClass:aclass];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommTool isIPAD]) {
        return 65;
    }else{
        return 50;
    }
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    ClassModel* aclass = _classes[indexPath.row];
    BOOL needFullScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"FullScreenWordBoard"];
    if (needFullScreen) {
        [self pushFullScreenWordBoardWithClass:aclass withAnimate:YES];
    }else{
        [self pushPortraitWordBoardWithClass:aclass withAnimate:YES];
    }
}

- (void)pushToWordsListWithClass:(ClassModel*)aclass{
    if (aclass.words.count == 0) {
        return;
    }
    WordsListViewController *detailViewController = [[WordsListViewController alloc] init];
    detailViewController.aclass = aclass;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end

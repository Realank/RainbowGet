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
@interface ClassesListViewController ()

@end

@implementation ClassesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = TINT_COLOR;
    self.title = @"课程列表";
//    self.tableView.backgroundColor = TINT_COLOR;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classes.count + 1;
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
    cell.textLabel.textColor = TINT_COLOR;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    if (indexPath.row < _classes.count) {
        ClassModel* class = _classes[indexPath.row];
        cell.textLabel.text = class.className;
        cell.detailTextLabel.text = @"新编日语第一册";
    }else{
        cell.textLabel.text = @"生词";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isIPAD]) {
        return 65;
    }else{
        return 45;
    }
}

- (BOOL)isIPAD{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _classes.count) {
        ClassModel* class = _classes[indexPath.row];
        self.view.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;
        [WordModel loadWordsFromClass:class.classID result:^(NSArray<WordModel *> *words) {
            [weakSelf pushToWithWords:words];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
            });
        }];
    }else{
        NSArray* words = [PersistWords allWords];
        [self pushToWithWords:words];
    }
    

}

- (void)pushToWithWords:(NSArray*)words{
    if (words.count == 0) {
        return;
    }
    WordBoardViewController *detailViewController = [[WordBoardViewController alloc] init];
    detailViewController.wordsList = [words copy];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end

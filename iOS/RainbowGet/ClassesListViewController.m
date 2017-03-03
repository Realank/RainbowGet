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
@interface ClassesListViewController ()

@end

@implementation ClassesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程列表";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuse"];
    ClassModel* class = _classes[indexPath.row];
    cell.textLabel.text = class.className;
    cell.detailTextLabel.text = @"新编日语第一册";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    ClassModel* class = _classes[indexPath.row];
    [self pushToClass:class];
}

- (void)pushToClass:(ClassModel*)class{
    self.view.userInteractionEnabled = NO;
    [WordModel loadWordsFromClass:class.classID result:^(NSArray<WordModel *> *words) {
        if (words.count > 0) {
            WordBoardViewController *detailViewController = [[WordBoardViewController alloc] init];
            detailViewController.wordsList = [words copy];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
        });
    }];
    
}

@end

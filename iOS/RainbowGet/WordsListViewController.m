//
//  WordsListViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/21.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordsListViewController.h"
#import "WordCell.h"
#import "WordModel.h"
@interface WordsListViewController ()

@end

@implementation WordsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = TINT_COLOR;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _wordsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WordCell cellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     WordCell *cell = [WordCell cellWithTableView:tableView];
    WordModel* word = _wordsList[indexPath.row];
    cell.word = word;
    return cell;
}


@end

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
#import "AudioPlaybackTool.h"

@interface WordsListViewController ()

@property (nonatomic, assign) BOOL autoPlaying;
@property (nonatomic, assign) NSInteger autoPlayIndex;
@property (weak, nonatomic) UIBarButtonItem* barbutton;
@end

@implementation WordsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _aclass.className;
    self.tableView.backgroundColor = [ThemeColor currentColor].tintColor;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    WordModel* word = _aclass.words.firstObject;
    if ([CommTool hasAudioFile:word.audiofile]) {
        UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(loopPlaySound)];
        _barbutton = barbutton;
        [self.navigationItem setRightBarButtonItem:barbutton];
        self.tableView.allowsSelection = YES;
    }else{
        self.tableView.allowsSelection = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.autoPlaying = NO;
}

- (void)loopPlaySound{
    if (_autoPlaying) {
        self.autoPlaying = NO;
        [[AudioPlaybackTool sharedInstance] stopAndCloseFile];
    }else{
        self.autoPlaying = YES;
        WordModel* word = _aclass.words.firstObject;
        if([[AudioPlaybackTool sharedInstance] loadAudioFile:word.audiofile]){
            [self loopPlay];
        }else{
            self.autoPlaying = NO;
        }
        
    }
    
}

- (void)setAutoPlaying:(BOOL)autoPlaying{
    _autoPlaying = autoPlaying;
    if (autoPlaying) {
        UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(loopPlaySound)];
        [self.navigationItem setRightBarButtonItem:barbutton];
    }else{
        UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(loopPlaySound)];
        [self.navigationItem setRightBarButtonItem:barbutton];
        [[AudioPlaybackTool sharedInstance] stopAndCloseFile];
        if (_autoPlayIndex > 0 && _autoPlayIndex <= _aclass.words.count) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_autoPlayIndex-1 inSection:0] animated:YES];
        }
        
    }
}

- (void)loopPlay{
    if (!_autoPlaying) {
        [[AudioPlaybackTool sharedInstance] stopAndCloseFile];
        return;
    }
    
    if (_autoPlayIndex < _aclass.words.count) {
        WordModel* word = _aclass.words[_autoPlayIndex];
        if (word.audiofile.length > 0) {
            [[AudioPlaybackTool sharedInstance] playLoadedAudioFileFromTime:word.starttime withDuration:word.periodtime complete:^{
                [self loopPlay];
            } interrupt:^{
                self.autoPlaying = NO;
            }];
        }else{
            [self loopPlay];
        }
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_autoPlayIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle]; 
        _autoPlayIndex ++;
    }else{
        
        self.autoPlaying = NO;
        _autoPlayIndex = 0;
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aclass.words.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WordCell cellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     WordCell *cell = [WordCell cellWithTableView:tableView];
    WordModel* word = _aclass.words[indexPath.row];
    cell.word = word;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    _autoPlayIndex = indexPath.row;
    if (_autoPlaying) {
        self.autoPlaying = NO;
    }
    WordModel* word = _aclass.words[indexPath.row];
    if (word.audiofile.length > 0) {
        [[AudioPlaybackTool sharedInstance] playbackAudioFile:word.audiofile fromTime:word.starttime withDuration:word.periodtime];
    }
}




@end

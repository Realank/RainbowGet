//
//  PortraitWordBoardViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/4/7.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "PortraitWordBoardViewController.h"
#import "BoardCell.h"
#import "WordModel.h"
#import "PersistWords.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AudioPlaybackTool.h"
#import "PortraitBoardCell.h"
@implementation UIImage (ChangeColor)

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface PortraitWordBoardViewController ()
@property (assign, nonatomic) NSInteger wordIndex;
@property (weak, nonatomic) UIBarButtonItem* rewindButton;
@property (weak, nonatomic) UIBarButtonItem* playButton;

@end

@implementation PortraitWordBoardViewController

#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [ThemeColor currentColor].tintColor;
    if (_shouldBeginWithZero) {
        self.wordIndex = 0;
    }else{
        self.wordIndex = [[NSUserDefaults standardUserDefaults] integerForKey:[_aclass wordBookKey]];
    }
    [self setupNavigationBar];
    
    [self setupTableView];
}

- (void)setupNavigationBar{
    UIImage* fullScreenImage = [[UIImage imageNamed:@"fullScreen"] imageWithColor:[ThemeColor currentColor].tintColor];
    UIBarButtonItem* fullScreenButton = [[UIBarButtonItem alloc] initWithImage:fullScreenImage style:UIBarButtonItemStylePlain target:self action:@selector(fullScreen)];
    UIBarButtonItem* rewindButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewind)];
    UIBarButtonItem* playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playSound)];
    _rewindButton = rewindButton;
    _playButton = playButton;
    [self.navigationItem setRightBarButtonItems:@[playButton,rewindButton,fullScreenButton]];
}

- (void)setupTableView{
    self.tableView.backgroundColor = [ThemeColor currentColor].tintColor;
    UISwipeGestureRecognizer* leftSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    leftSwipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    //    leftSwipeGes.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:leftSwipeGes];
    
    UISwipeGestureRecognizer* rightSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    rightSwipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    //    rightSwipeGes.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:rightSwipeGes];
}

#pragma mark - actions

- (IBAction)aNewWordAction:(UIButton*)sender {
    BOOL isAdd = !sender.selected;
    WordModel* word = _aclass.words[_wordIndex];
    if (isAdd) {
        if (![PersistWords worldExist:word]) {
            [PersistWords addWord:word];
        }
    }else{
        [PersistWords delWord:word];
    }
    sender.selected = isAdd;
}

- (void)swipeAction:(UISwipeGestureRecognizer*)ges{
    if (ges.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"forward");
        [self forward];
    }else if (ges.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"backward");
        [self backward];
    }
}

- (void)forward{
    NSInteger index = _wordIndex;
    index++;
    if (index >= _aclass.words.count) {
        index = 0;
    }
    self.wordIndex = index;
    
    [self refreshWord];
}

- (void)backward{
    NSInteger index = _wordIndex;
    index--;
    if (index < 0) {
        index = _aclass.words.count - 1;
    }
    self.wordIndex = index;
    [self refreshWord];
}

- (void)fullScreen{
    if (_pushWordBoardDeleagte) {
        [_pushWordBoardDeleagte pushWordBoardToClass:_aclass withFullScreen:YES];
    }
}

- (void)rewind{
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.wordIndex = 0;
        [self refreshWord];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"注意" message:@"确认跳转到单词起始位置吗？" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:confirmAction];
    [vc addAction:cancelAction];
    [self presentViewController:vc animated:YES completion:nil];
}




#pragma mark - voice

- (void)playSound{
    WordModel* word = _aclass.words[_wordIndex];
    if (word.audiofile.length > 0) {
        [[AudioPlaybackTool sharedInstance] playbackAudioFile:word.audiofile fromTime:word.starttime withDuration:word.periodtime];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![CommTool isIPAD]) {
        [self orientationChange];
    }
    
}

- (void)orientationChange{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    
}

#pragma mark - refresh

- (void)setWordIndex:(NSInteger)wordIndex{
    _wordIndex = wordIndex;
    self.title = [NSString stringWithFormat:@"%@(%d/%d)",_aclass.className,wordIndex+1,_aclass.words.count];
    
    if (!_shouldBeginWithZero) {
        [[NSUserDefaults standardUserDefaults] setInteger:wordIndex forKey:[_aclass wordBookKey]];
    }
    
}

- (void)refreshWord{
    WordModel* word = _aclass.words[_wordIndex];
    //    _aNewWordButton.selected = [PersistWords worldExist:word];
    
    _playButton.enabled = word.audiofile.length > 0;
    _rewindButton.enabled = _wordIndex != 0;
    
    [self reloadData];
}
- (void)reloadData{
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PortraitBoardCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = indexPath.section;
    WordModel* word = _aclass.words[_wordIndex];
    PortraitBoardCell* cell = [PortraitBoardCell cellWithTableView:tableView];
    switch (row) {
        case 0:
        {
            NSString* content =  word.japanese;
            if (content.length == 0) {
                content = word.kana;
            }
            cell.content = content;
            cell.property = @"";
        }
            break;
        case 1:
        {
            cell.content = word.kana;
            cell.property = [word toneString];
        }
            break;
        case 2:
        {
            cell.content = word.chinese;
            cell.property = [word typeString];
        }
            break;
        default:
            break;
    }
    return cell;

}



@end

//
//  WordBoardViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordBoardViewController.h"
#import "BoardCell.h"
#import "WordModel.h"
#import "PersistWords.h"
#import <AVOSCloud/AVOSCloud.h>
#import "DrawView.h"
#import "AudioPlaybackTool.h"

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

@interface WordBoardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (assign, nonatomic) NSInteger wordIndex;

@property (weak, nonatomic) IBOutlet UIButton *jTCModeButton;
@property (weak, nonatomic) IBOutlet UIButton *cTJModeButton;

@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIButton *aNewWordButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;

@property (weak, nonatomic) UIBarButtonItem* barbutton;

@property (assign, nonatomic) NSInteger showAllState;//0 don't show all, 1 show all once, 2 show all always

@end

@implementation WordBoardViewController

#pragma mark - setup
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = TINT_COLOR;
    self.wordIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playSound)];
    _barbutton = barbutton;
    [self.navigationItem setRightBarButtonItem:barbutton];
    
    [self refreshWord];
    [self setupButtons];
    [self setupCollectionView];
    [self setupDrawView];
    
    
}

- (void)setupButtons{
    [_modeButton setImage:[[UIImage imageNamed:@"loop"] imageWithColor:TINT_COLOR] forState:UIControlStateNormal];
    [_modeButton setImage:[[UIImage imageNamed:@"shuffle"] imageWithColor:TINT_COLOR] forState:UIControlStateSelected];
    BOOL japaneseToChineseMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"japaneseToChineseMode"];
    BOOL dontShowAll = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontShowAll"];
    if (japaneseToChineseMode) {
        [self japaneseToChineseModeAction:_jTCModeButton];
    }else{
        [self chineseToJapaneseModeAction:_cTJModeButton];
    }
    
    self.showAllState = dontShowAll ? 0 : 2;
}

- (void)setWordIndex:(NSInteger)wordIndex{
    _wordIndex = wordIndex;
    self.title = [NSString stringWithFormat:@"%d/%d",wordIndex+1,_wordsList.count];
}

- (void)setupDrawView{
    _drawView.backgroundColor = TINT_COLOR;
    _drawView.strokeColor = FORE_COLOR;
    _drawView.strokeWidth = 8.0f;
}

- (void)setupCollectionView{
    _contentCollectionView.backgroundColor = TINT_COLOR;
    [_contentCollectionView registerNib:[UINib nibWithNibName:[BoardCell identifier] bundle:nil] forCellWithReuseIdentifier:[BoardCell identifier]];

    //setup the cell space
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = [BoardCell width];
    CGFloat cellHeight = [BoardCell height];
//    NSInteger cellNum = 3;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
//    NSInteger space = (_contentCollectionView.bounds.size.width - cellNum*cellWidth - 20)/(cellNum-1);
//    space = space > 5 ? space : 5;
    layout.minimumInteritemSpacing = 10;
    //    space = (470 - 2*cellHeight);
    //    space = space > 5 ? space : 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
    _contentCollectionView.collectionViewLayout = layout;
    
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    
    UISwipeGestureRecognizer* leftSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    leftSwipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
//    leftSwipeGes.numberOfTouchesRequired = 2;
    [_contentCollectionView addGestureRecognizer:leftSwipeGes];
    
    UISwipeGestureRecognizer* rightSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    rightSwipeGes.direction = UISwipeGestureRecognizerDirectionRight;
//    rightSwipeGes.numberOfTouchesRequired = 2;
    [_contentCollectionView addGestureRecognizer:rightSwipeGes];
}

#pragma mark - actions


- (IBAction)modeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self reloadData];
}
- (IBAction)japaneseToChineseModeAction:(UIButton *)sender {
    
    _cTJModeButton.selected = NO;
    _jTCModeButton.selected = YES;
    self.showAllState = 0;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"japaneseToChineseMode"];
    [self reloadData];
}

- (IBAction)chineseToJapaneseModeAction:(UIButton *)sender {
    
    _cTJModeButton.selected = YES;
    _jTCModeButton.selected = NO;
    self.showAllState = 0;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"japaneseToChineseMode"];
    [self reloadData];
    
}
- (IBAction)showAllAction:(UIButton*)sender {
    _showAllState ++;
    if (_showAllState > 2) {
        _showAllState = 0;
    }
    self.showAllState = _showAllState;
    [self reloadData];
}

- (void)setShowAllState:(NSInteger)showAllState{
    _showAllState = showAllState;
    if (showAllState == 0) {
        _showAllButton.selected = NO;
    }else if (showAllState == 1){
        _showAllButton.selected = NO;
    }else{
        _showAllButton.selected = YES;
    }
    
    if (showAllState == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dontShowAll"];
    }else if (showAllState >= 2) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dontShowAll"];
    }
}


- (IBAction)aNewWordAction:(UIButton*)sender {
    BOOL isAdd = !sender.selected;
    WordModel* word = _wordsList[_wordIndex];
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

- (void)resetShowAllState{
    if (_showAllState == 1) {
        self.showAllState = 0;
    }
}

- (void)forward{
    if (_modeButton.selected) {
        self.wordIndex = arc4random() % _wordsList.count;
    }else{
        self.wordIndex++;
        if (self.wordIndex >= _wordsList.count) {
            self.wordIndex = 0;
        }
    }
    [self resetShowAllState];
    [self refreshWord];
    [self reloadData];
    [_drawView clearDrawing];
}

- (void)backward{
    if (_modeButton.selected) {
        self.wordIndex = arc4random() % _wordsList.count;
    }else{
        self.wordIndex--;
        if (self.wordIndex < 0) {
            self.wordIndex = _wordsList.count - 1;
        }
    }
    [self resetShowAllState];
    [self refreshWord];
    [self reloadData];
    [_drawView clearDrawing];
}

- (void)refreshWord{
    WordModel* word = _wordsList[_wordIndex];
    _aNewWordButton.selected = [PersistWords worldExist:word];
    
    _barbutton.enabled = word.audiofile.length > 0;
}

- (IBAction)undoDraw:(id)sender {
    [_drawView undoDrawing];
}
- (IBAction)clearDraw:(id)sender {
    [_drawView clearDrawing];
    
}

- (void)playSound{
    WordModel* word = _wordsList[_wordIndex];
    if (word.audiofile.length > 0) {
        [[AudioPlaybackTool sharedInstance] playbackAudioFile:word.audiofile fromTime:word.starttime withDuration:word.periodtime];
    }
    
}

- (void)reloadData{
    [_contentCollectionView reloadData];
}

#pragma mark - collectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    WordModel* word = _wordsList[_wordIndex];
    BoardCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BoardCell identifier] forIndexPath:indexPath];
    BOOL show = _showAllState > 0;
    switch (row) {
        case 0:
        {
            NSString* content =  word.japanese;
            if (content.length == 0) {
                content = word.kana;
            }
            if (_jTCModeButton.selected) {
                show = YES;
            }
            cell.content = show ? content : @"";
            cell.property = @"";
        }
            break;
        case 1:
        {
            cell.content = show ? word.kana : @"";
            cell.property = show ? [word toneString] : @"";
        }
            break;
        case 2:
        {
            if (_cTJModeButton.selected) {
                show = YES;
            }
            cell.content = show ? word.chinese : @"";
            cell.property = show ? [word typeString] : @"";
        }
            break;
        default:
            break;
    }
    return cell;
}


@end

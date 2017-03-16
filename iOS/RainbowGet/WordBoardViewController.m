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
#import <AVOSCloud/AVOSCloud.h>
#import "DrawView.h"
@interface WordBoardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (assign, nonatomic) NSInteger wordIndex;
@property (weak, nonatomic) IBOutlet UIButton *japaneseButton;

@property (weak, nonatomic) IBOutlet UIButton *kanaButton;

@property (weak, nonatomic) IBOutlet UIButton *chineseButton;
@property (weak, nonatomic) IBOutlet UIButton *jTCModeButton;
@property (weak, nonatomic) IBOutlet UIButton *cTJModeButton;

@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet DrawView *drawView;



@end

@implementation WordBoardViewController

#pragma mark - setup
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = TINT_COLOR;
    self.wordIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupButtons];
    [self setupCollectionView];
    [self setupDrawView];
    
}

- (void)setupButtons{
    [self japaneseToChineseModeAction:_jTCModeButton];

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
    NSInteger cellNum = 3;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    NSInteger space = (_contentCollectionView.bounds.size.width - cellNum*cellWidth - 20)/(cellNum-1);
    space = space > 5 ? space : 5;
    layout.minimumInteritemSpacing = space;
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


- (IBAction)japaneseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self reloadData];
}
- (IBAction)kanaAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self reloadData];
}
- (IBAction)chineseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self reloadData];
}
- (IBAction)modeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self reloadData];
}
- (IBAction)japaneseToChineseModeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _cTJModeButton.selected = NO;
        [self refreshTestMode];
        [self reloadData];
    }
    
}

- (IBAction)chineseToJapaneseModeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _jTCModeButton.selected = NO;
        [self refreshTestMode];
        [self reloadData];
    }
    
}
- (IBAction)showAllAction:(id)sender {
    _japaneseButton.selected = YES;
    _kanaButton.selected = YES;
    _chineseButton.selected = YES;
    [self reloadData];
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
    if (_modeButton.selected) {
        self.wordIndex = arc4random() % _wordsList.count;
    }else{
        self.wordIndex++;
        if (self.wordIndex >= _wordsList.count) {
            self.wordIndex = 0;
        }
    }
    [self refreshTestMode];
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
    [self refreshTestMode];
    [self reloadData];
    [_drawView clearDrawing];
}

- (void)refreshTestMode{
    if (_jTCModeButton.selected) {
        _japaneseButton.selected = YES;
        _kanaButton.selected = NO;
        _chineseButton.selected = NO;
        
    }else if (_cTJModeButton.selected){
        _japaneseButton.selected = NO;
        _kanaButton.selected = NO;
        _chineseButton.selected = YES;

    }
}

- (IBAction)undoDraw:(id)sender {
    [_drawView undoDrawing];
}
- (IBAction)clearDraw:(id)sender {
    [_drawView clearDrawing];
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
    switch (row) {
        case 0:
        {
            NSString* content =  word.japanese;
            if (content.length == 0) {
                content = word.kana;
            }
            cell.content = _japaneseButton.selected ? content : @"";
        }
            break;
        case 1:
        {
            NSString* content = [NSString stringWithFormat:@"%@\n%@",word.kana,[word toneString]];
            cell.content = _kanaButton.selected ? content : @"";
        }
            break;
        case 2:
        {
            NSString* content = [NSString stringWithFormat:@"%@\n(%@)",word.chinese,[word typeString]];
            cell.content = _chineseButton.selected ? content : @"";
        }
            break;
        default:
            break;
    }
    return cell;
}


@end

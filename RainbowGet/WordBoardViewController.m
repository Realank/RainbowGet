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

@interface WordBoardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (strong, nonatomic) NSMutableArray* wordsList;
@property (assign, nonatomic) NSInteger wordIndex;

@end

@implementation WordBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillWords];
    [self setupCollectionView];
}

- (void)fillWords{
    _wordsList = [NSMutableArray array];
    WordModel* word1 = [[WordModel alloc] init];
    word1.japanese = @"綺麗";
    word1.kana = @"きれい";
    word1.chinese = @"漂亮的;干净的";
    word1.type = @"形动";
    word1.tone = 1;
    word1.isHiragana = YES;
    [self.wordsList addObject:word1];
    WordModel* word2 = [[WordModel alloc] init];
    word2.japanese = @"高い";
    word2.kana = @"たかい";
    word2.chinese = @"高的";
    word2.type = @"形";
    word2.tone = 2;
    word2.isHiragana = YES;
    [self.wordsList addObject:word2];
    WordModel* word3 = [[WordModel alloc] init];
    word3.japanese = @"机";
    word3.kana = @"つくえ";
    word3.chinese = @"桌子";
    word3.type = @"名";
    word3.tone = 0;
    word3.isHiragana = YES;
    [self.wordsList addObject:word3];
}

- (void)setupCollectionView{

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
    _wordIndex++;
    if (_wordIndex >= _wordsList.count) {
        _wordIndex = 0;
    }
    [self reloadData];
}

- (void)backward{
    _wordIndex--;
    if (_wordIndex < 0) {
        _wordIndex = _wordsList.count - 1;
    }
    [self reloadData];
}

- (void)reloadData{
    [_contentCollectionView reloadData];
}

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
            cell.content = word.japanese;
            break;
        case 1:
            cell.content = [NSString stringWithFormat:@"%@  %@",word.kana,[word toneString]];
            break;
        case 2:
            cell.content = [NSString stringWithFormat:@"(%@)%@",word.type,word.chinese];
            break;
        default:
            break;
    }
    return cell;
}


@end
//
//  ViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ViewController.h"
#import "WordBoardViewController.h"
#import "ClassesListViewController.h"
#import "WordModel.h"
#import "PersistWords.h"
#import "PopUpBigViewForNotice.h"
#import "BookCell.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (strong, nonatomic) NSArray* someNewWords;
@property (strong, nonatomic) NSArray* books;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.tintColor = TINT_COLOR;
    self.view.backgroundColor = TINT_COLOR;
    [self setupCollectionView];
    // Do any additional setup after loading the view, typically from a nib.
//    _signLabel.layer.affineTransform = CGAffineTransformMakeRotation(-M_PI/4);
    [self checkFirstUse];
    [self loadBooks];
}
- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = 120;
    CGFloat cellHeight = 160;
    if ([CommTool isIPAD]) {
        cellWidth = 180;
        cellHeight = 240;
    }
    //    NSInteger cellNum = 3;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    //    NSInteger space = (_contentCollectionView.bounds.size.width - cellNum*cellWidth - 20)/(cellNum-1);
    //    space = space > 5 ? space : 5;
    layout.minimumInteritemSpacing = 10;
    //    space = (470 - 2*cellHeight);
    //    space = space > 5 ? space : 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
    _bookCollectionView.collectionViewLayout = layout;

    _bookCollectionView.delegate = self;
    _bookCollectionView.dataSource = self;
    
}

- (void)reloadData{
    [_bookCollectionView reloadData];
}
- (IBAction)aboutAction:(id)sender {
    [self showIntroduce];
}


- (void) checkFirstUse {

    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *key = [NSString stringWithFormat:@"firstUseThisVersion:%@",bundleVersion];
    NSString *firstUseThisVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!firstUseThisVersion) {
        firstUseThisVersion = @"yes";
        [[NSUserDefaults standardUserDefaults] setObject:firstUseThisVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showIntroduce];
    }
    
}

- (IBAction)showIntroduce{
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    PopUpBigViewForNotice *view = [[PopUpBigViewForNotice alloc]initWithFrame:self.view.bounds];
    view.title = [NSString stringWithFormat:@"こんにちは(%@)",bundleVersion];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"introduce" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    view.content = content;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)configRoundButton:(UIButton*)button{
    [button setTitleColor:TINT_COLOR forState:UIControlStateNormal];
    button.backgroundColor = FORE_COLOR;
    button.layer.cornerRadius = button.frame.size.height/2.0;
    
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowRadius = 4;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    button.layer.shadowOpacity = 0.5;
    button.layer.masksToBounds = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _someNewWords = [PersistWords allWords];
    [self reloadData];
}

- (void)showButtonAnimate:(UIButton*)button{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        button.layer.affineTransform = CGAffineTransformMakeScale(6, 6);
        [button setTitleColor:FORE_COLOR forState:UIControlStateNormal];
        button.alpha = 0;
    } completion:^(BOOL finished) {
        button.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
        [button setTitleColor:TINT_COLOR forState:UIControlStateNormal];
        button.alpha = 1;
    }];
}

- (void)loadBooks {
    
    __weak typeof(self) weakSelf = self;
    
    [BookModel loadBooksWithResult:^(NSArray<BookModel *> *books) {
        if (books.count) {
            weakSelf.books = [books copy];
            [weakSelf reloadData];

        }
    }];
    
    
    
}
- (IBAction)enterNewWordPage:(UIButton*)sender {
    [self showButtonAnimate:sender];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushToWithWords:_someNewWords];
    });
}

- (void)goNextWithClasses:(NSArray*)classes ofBookName:(NSString*)bookName{
    ClassesListViewController* vc = [[ClassesListViewController alloc] init];
    vc.classes = [classes copy];
    vc.title = bookName;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToWithWords:(NSArray*)words{
    if (words.count == 0) {
        return;
    }
    WordBoardViewController *detailViewController = [[WordBoardViewController alloc] init];
    detailViewController.wordsList = [words copy];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - collectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number =  _books.count + (_someNewWords.count > 0 ? 1 : 0);
    return number;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    BookCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCell" forIndexPath:indexPath];
    if (row < _books.count) {
        BookModel* book = _books[row];
        cell.book = book;
    }else{
        BookModel* newWordsBook = [[BookModel alloc] init];
        newWordsBook.title = @"生词本";
        cell.book = newWordsBook;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row < _books.count) {
        BookModel* book = _books[row];
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        [book loadClassesWithComplete:^{
            weakSelf.view.userInteractionEnabled = YES;
            if (book.classes.count) {
                NSString* bookName = [NSString stringWithFormat:@"%@(%@)",book.title,book.subtitle];
                [weakSelf goNextWithClasses:book.classes ofBookName:bookName];
            }
        }];
    }else{
        [self pushToWithWords:_someNewWords];
    }
    
}


@end

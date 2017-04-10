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
#import "SettingViewController.h"
#import "BookCell.h"
#import "PortraitWordBoardViewController.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (strong, nonatomic) NSArray* someNewWords;
@property (strong, nonatomic) NSArray* books;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self checkFirstUse];
    [self loadBooks];
}

- (void)orientationChange{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    
}

- (void)refreshTheme{
    self.navigationController.view.tintColor = [ThemeColor currentColor].tintColor;
    self.view.backgroundColor = [ThemeColor currentColor].tintColor;
}
- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = 120;
    CGFloat cellHeight = 160;
    if ([CommTool isIPAD]) {
        cellWidth = 180;
        cellHeight = 240;
    }
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    CGFloat edgeMargin = 10;
    if ([CommTool isIPAD]) {
        layout.minimumInteritemSpacing = 15;
    }else{
        layout.minimumInteritemSpacing = ([CommTool screenWidth] - 2*cellWidth)/3;
        edgeMargin = ([CommTool screenWidth] - 2*cellWidth)/3;
    }
    
    layout.minimumLineSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(15, edgeMargin, 15, edgeMargin);
    _bookCollectionView.collectionViewLayout = layout;

    _bookCollectionView.delegate = self;
    _bookCollectionView.dataSource = self;
    
}

- (void)reloadData{
    [_bookCollectionView reloadData];
}
- (IBAction)aboutAction:(id)sender {
    SettingViewController* vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) checkFirstUse {

    NSString *bundleVersion = [CommTool bundleVersion];
    NSString *key = [NSString stringWithFormat:@"firstUseThisVersion:%@",bundleVersion];
    NSString *firstUseThisVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!firstUseThisVersion) {
        firstUseThisVersion = @"yes";
        [[NSUserDefaults standardUserDefaults] setObject:firstUseThisVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [PopUpBigViewForNotice showAppIntroduce];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![CommTool isIPAD]) {
        [self orientationChange];
    }
    _someNewWords = [PersistWords allWords];
    [self setupCollectionView];
    [self refreshTheme];
    [self reloadData];
}

- (void)loadBooks {
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [BookModel loadBooksWithResult:^(NSArray<BookModel *> *books) {
        if (books.count) {
            [SVProgressHUD dismiss];
            weakSelf.books = [books copy];
            [weakSelf reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:@"网络错误\n如果您第一次打开，请在设置中允许互联网访问，再重启APP"];
        }
    }];
    
    
    
}

- (void)goNextWithClasses:(NSArray*)classes{
    ClassesListViewController* vc = [[ClassesListViewController alloc] init];
    vc.classes = [classes copy];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToWithWords:(NSArray*)words{
    if (words.count == 0) {
        return;
    }
    ClassModel* aclass= [ClassModel new];
    aclass.words = words;
    aclass.className = @"生词";
    aclass.bookName = @"生词本";
    BOOL needFullScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"FullScreenWordBoard"];
    if (needFullScreen) {
        [self pushFullScreenWordBoardWithClass:aclass  withAnimate:YES];
    }else{
        [self pushPortraitWordBoardWithClass:aclass  withAnimate:YES];
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
    if (aclass.words.count == 0) {
        return;
    }
    WordBoardViewController *vc = [[WordBoardViewController alloc] init];
    vc.aclass = aclass;
    vc.pushWordBoardDeleagte = self;
    vc.shouldBeginWithZero = YES;
    [self.navigationController pushViewController:vc animated:animate];
}

- (void)pushPortraitWordBoardWithClass:(ClassModel*)aclass withAnimate:(BOOL)animate{
    if (aclass.words.count == 0) {
        return;
    }
    PortraitWordBoardViewController* vc = [[PortraitWordBoardViewController alloc] init];
    vc.aclass = aclass;
    vc.pushWordBoardDeleagte = self;
    vc.shouldBeginWithZero = YES;
    [self.navigationController pushViewController:vc animated:animate];

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
        [SVProgressHUD show];
        [book loadClassesWithComplete:^{
            weakSelf.view.userInteractionEnabled = YES;
            if (book.classes.count) {
                [SVProgressHUD dismiss];
                [weakSelf goNextWithClasses:book.classes];
            }else{
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }
        }];
    }else{
        [self pushToWithWords:_someNewWords];
    }
    
}




@end

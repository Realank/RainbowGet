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
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
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
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

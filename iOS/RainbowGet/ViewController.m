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
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *aNewWordButton;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (strong, nonatomic) NSArray* someNewWords;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.tintColor = TINT_COLOR;
    self.view.backgroundColor = TINT_COLOR;
    [self configRoundButton:self.enterButton];
    [self configRoundButton:self.aNewWordButton];
    // Do any additional setup after loading the view, typically from a nib.
//    _signLabel.layer.affineTransform = CGAffineTransformMakeRotation(-M_PI/4);
    [self checkFirstUse];
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
    _aNewWordButton.hidden = _someNewWords.count == 0;
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

- (IBAction)enter:(UIButton*)sender {
    
    __weak typeof(self) weakSelf = self;
    [ClassModel loadClassesWithResult:^(NSArray<ClassModel *> *classes) {
        if (classes.count <= 0) {
            return;
        }
        [self showButtonAnimate:sender];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf goNextWithClasses:classes];
        });
    }];
    
    
    
}
- (IBAction)enterNewWordPage:(UIButton*)sender {
    [self showButtonAnimate:sender];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushToWithWords:_someNewWords];
    });
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
    WordBoardViewController *detailViewController = [[WordBoardViewController alloc] init];
    detailViewController.wordsList = [words copy];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end

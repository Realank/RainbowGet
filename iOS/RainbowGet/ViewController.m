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
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.tintColor = TINT_COLOR;
    self.view.backgroundColor = TINT_COLOR;
    [self.enterButton setTitleColor:TINT_COLOR forState:UIControlStateNormal];
    self.enterButton.backgroundColor = FORE_COLOR;
    self.enterButton.layer.cornerRadius = self.enterButton.frame.size.height/2.0;
    
    self.enterButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.enterButton.layer.shadowRadius = 4;
    self.enterButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.enterButton.layer.shadowOpacity = 0.5;
    self.enterButton.layer.masksToBounds = NO;
    // Do any additional setup after loading the view, typically from a nib.
//    _signLabel.layer.affineTransform = CGAffineTransformMakeRotation(-M_PI/4);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    _enterButton.layer.affineTransform = CGAffineTransformMakeScale(2, 2);
    _enterButton.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    [_enterButton setTitleColor:TINT_COLOR forState:UIControlStateNormal];
    _enterButton.alpha = 1;
}

- (IBAction)enter:(UIButton*)sender {
    
//    [UIView animateWithDuration:0.1 animations:^{
//        sender.layer.affineTransform = CGAffineTransformMakeTranslation(0, 20);
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.35 animations:^{
//            sender.layer.affineTransform = CGAffineTransformMakeTranslation(0, -200);
//            sender.alpha = 0;
//        } completion:^(BOOL finished) {
//            [self goNext];
//        }];
//    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        sender.layer.affineTransform = CGAffineTransformMakeScale(8, 8);
//        [_enterButton setTitleColor:FORE_COLOR forState:UIControlStateNormal];
//        sender.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self goNext];
//    }];
    __weak typeof(self) weakSelf = self;
    [ClassModel loadClassesWithResult:^(NSArray<ClassModel *> *classes) {
        if (classes.count <= 0) {
            return;
        }
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            sender.layer.affineTransform = CGAffineTransformMakeScale(5, 5);
            [_enterButton setTitleColor:FORE_COLOR forState:UIControlStateNormal];
            sender.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf goNextWithClasses:classes];
        });
    }];
    
    
    
}

- (void)goNextWithClasses:(NSArray*)classes{
    ClassesListViewController* vc = [[ClassesListViewController alloc] init];
    vc.classes = [classes copy];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

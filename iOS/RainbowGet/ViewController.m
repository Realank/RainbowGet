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
    // Do any additional setup after loading the view, typically from a nib.
    _signLabel.layer.affineTransform = CGAffineTransformMakeRotation(-M_PI/4);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _enterButton.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    _enterButton.alpha = 1;
}

- (IBAction)enter:(UIButton*)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        sender.layer.affineTransform = CGAffineTransformMakeTranslation(0, 20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            sender.layer.affineTransform = CGAffineTransformMakeTranslation(0, -200);
            sender.alpha = 0;
        } completion:^(BOOL finished) {
            [self goNext];
        }];
    }];
}

- (void)goNext{
    [ClassModel loadClassesWithResult:^(NSArray<ClassModel *> *classes) {
        if (classes.count <= 0) {
            return;
        }
        ClassesListViewController* vc = [[ClassesListViewController alloc] init];
        vc.classes = [classes copy];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end

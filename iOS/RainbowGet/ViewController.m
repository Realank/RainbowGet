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

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _signLabel.layer.affineTransform = CGAffineTransformMakeRotation(-M_PI/4);
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                sender.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
                sender.alpha = 1;
            });
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

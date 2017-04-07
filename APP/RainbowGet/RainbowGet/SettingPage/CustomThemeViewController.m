//
//  CustomThemeViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "CustomThemeViewController.h"
#import "FCBrightDarkGradView.h"
@interface CustomThemeViewController (){
    CGFloat currentBrightness;
    CGFloat currentHue;
    CGFloat currentSaturation;
}

@property (weak, nonatomic) IBOutlet UIImageView *pickColorView;
@property (weak, nonatomic) IBOutlet FCBrightDarkGradView *gradView;
@property (weak, nonatomic) IBOutlet UIView *gradBarView;
@property (weak, nonatomic) IBOutlet UIView *colorPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorTypeSegmentView;
@property (weak, nonatomic) IBOutlet UIView *demoView;
@property (weak, nonatomic) IBOutlet UILabel *demoLabel;

@end

@implementation CustomThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"自定义主题";
    _pickColorView.image = [UIImage imageNamed:@"colormap"];
    _pickColorView.contentMode = UIViewContentModeScaleToFill;
    [self setPickerColor:_preloadTheme.tintColor];
    self.demoView.backgroundColor = _preloadTheme.tintColor;
    self.demoLabel.textColor = _preloadTheme.foreColor;
    [self configUI];
    UIBarButtonItem* barbutton = [[UIBarButtonItem alloc] initWithTitle:@"设定" style:UIBarButtonItemStylePlain target:self action:@selector(saveThemeColor)];
    [self.navigationItem setRightBarButtonItem:barbutton];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _colorPicker.hidden = YES;
    _gradBarView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setPickerColor:_preloadTheme.tintColor];
    _colorPicker.hidden = NO;
    _gradBarView.hidden = NO;
}

- (void)saveThemeColor{
    [ThemeColor setTheme:_preloadTheme];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshDemoColor{
    if (_colorTypeSegmentView.selectedSegmentIndex == 0) {
        //tint
        _preloadTheme.tintColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1];
        _preloadTheme.selectedTintColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness > 0.1 ? currentBrightness - 0.06 : 0.04 alpha:1];
        self.navigationController.view.tintColor = _preloadTheme.tintColor;
    }else{
        _preloadTheme.foreColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1];
    }
    self.demoView.backgroundColor = _preloadTheme.tintColor;
    self.demoLabel.textColor = _preloadTheme.foreColor;
    
}

- (void)configUI{
    UIColor *edgeColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    
    self.colorPicker.layer.cornerRadius = 19;
    self.colorPicker.layer.borderColor = edgeColor.CGColor;
    self.colorPicker.layer.borderWidth = 2;
    self.colorPicker.layer.shadowColor = [UIColor blackColor].CGColor;
    self.colorPicker.layer.shadowOffset = CGSizeZero;
    self.colorPicker.layer.shadowRadius = 1;
    self.colorPicker.layer.shadowOpacity = 0.5;
    
    self.gradBarView.layer.cornerRadius = 9;
    self.gradBarView.layer.borderColor = edgeColor.CGColor;
    self.gradBarView.layer.borderWidth = 2;
}
- (IBAction)switchColorType:(id)sender {
    if (_colorTypeSegmentView.selectedSegmentIndex == 0) {
        //tint
        [self setPickerColor:_preloadTheme.tintColor];
    }else{
        [self setPickerColor:_preloadTheme.foreColor];
    }
}

- (void)setPickerColor:(UIColor *)newColor {
    
    CGFloat hue, saturation, brightness;
    [newColor getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL];
    
    currentHue = hue;
    currentSaturation = saturation;
    currentBrightness = brightness;
    [self updateGradientColor];
    [self updateBrightnessPosition];
    [self updateCrosshairPosition];
}

- (void)updateBrightnessPosition {
    
    CGPoint brightnessPosition;
    brightnessPosition.y = (1.0-currentBrightness)*_gradView.frame.size.height;
    brightnessPosition.x = _gradView.bounds.size.width/2;
    _gradBarView.center = brightnessPosition;
}

- (void)updateCrosshairPosition {
    CGPoint hueSatPosition;
    
    hueSatPosition.x = (currentHue*_pickColorView.frame.size.width);
    hueSatPosition.y = (1.0-currentSaturation)*_pickColorView.frame.size.height;
    
    _colorPicker.center = hueSatPosition;
    [self updateGradientColor];
}

- (void)updateGradientColor {
    UIColor *gradientColor = [UIColor colorWithHue: currentHue
                                        saturation: currentSaturation
                                        brightness: 1.0
                                             alpha:1.0];
    
    _gradBarView.layer.backgroundColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1].CGColor;
    _colorPicker.layer.backgroundColor = gradientColor.CGColor;
    
    [_gradView setColor:gradientColor];
}

- (void)updateHueSatWithMovement:(CGPoint) position {
    
    currentHue = position.x/_pickColorView.frame.size.width;
    currentSaturation = 1.0 -  position.y/_pickColorView.frame.size.height;
    
    UIColor *gradientColor = [UIColor colorWithHue: currentHue
                                        saturation: currentSaturation
                                        brightness: 1.0
                                             alpha:1.0];
    
    
    _colorPicker.layer.backgroundColor = gradientColor.CGColor;
    [self updateGradientColor];
    _gradBarView.layer.backgroundColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1].CGColor;
}

- (void)updateBrightnessWithMovement:(CGPoint) position {
    
    currentBrightness = 1.0 - position.y/_gradView.frame.size.height;
    _gradBarView.layer.backgroundColor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1].CGColor;
}

#pragma mark - Touch Handling

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches allObjects].firstObject;
    [self dispatchTouchEvent:touch];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches allObjects].firstObject;
    [self dispatchTouchEvent:touch];
}

- (void)dispatchTouchEvent:(UITouch*)touch {
    if (CGRectContainsPoint(_pickColorView.frame,[touch locationInView:self.view])) {
        CGPoint position = [touch locationInView:_pickColorView];
        _colorPicker.center = position;
        [self updateHueSatWithMovement:position];
        [self refreshDemoColor];
    } else if (CGRectContainsPoint(_gradView.frame, [touch locationInView:self.view])) {
        CGPoint position = [touch locationInView:_gradView];
        position.x = _gradView.bounds.size.width/2;
        _gradBarView.center = position;
        [self updateBrightnessWithMovement:position];
        [self refreshDemoColor];
    }
}


@end

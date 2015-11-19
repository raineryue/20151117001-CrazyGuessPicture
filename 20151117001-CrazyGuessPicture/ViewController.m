//
//  ViewController.m
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/17.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "ViewController.h"
#import "QuestionsModel.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *coinButton;
@property (strong, nonatomic) IBOutlet UIView *countLabel;
@property (strong, nonatomic) IBOutlet UIView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (strong, nonatomic) IBOutlet UIView *trueAnswerView;
@property (weak, nonatomic) IBOutlet UIView *selectAnswerView;

@property (nonatomic, weak) UIButton *coverButton;

@property (nonatomic, strong) NSArray *questions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[QuestionsModel questionArray]);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)changePicture:(id)sender {
    if (0.0 == self.coverButton.alpha) {
        // 1.将图像调至试图最前端
        [self.view bringSubviewToFront:self.pictureButton];
        
        CGFloat pictureButtonW = self.view.bounds.size.width;
        CGFloat pictureButtonH = pictureButtonW;
        CGFloat pictureButtonX = 0;
        CGFloat pictureButtonY = (self.view.bounds.size.height - pictureButtonH) * 0.5;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.coverButton.alpha = 0.8;
            self.pictureButton.frame = CGRectMake(pictureButtonX, pictureButtonY, pictureButtonW, pictureButtonH);
        }];
    } else {
        [UIView animateWithDuration:1.0 animations:^{
            self.coverButton.alpha = 0.0;
            self.pictureButton.frame = CGRectMake(85, 98, 150, 150);
        }];
    }
}

#pragma mark - 属性懒加载
/**
 *  遮罩按钮懒加载
 */
- (UIButton *)coverButton {
    if (nil == _coverButton) {
        UIButton *coverButton = [[UIButton alloc] initWithFrame:self.view.frame];
        coverButton.backgroundColor = [UIColor grayColor];
        coverButton.alpha = 0.0;
        [coverButton addTarget:self action:@selector(changePicture:) forControlEvents:UIControlEventTouchUpInside];
        
        _coverButton = coverButton;
        [self.view addSubview:_coverButton];
    }
    
    return _coverButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

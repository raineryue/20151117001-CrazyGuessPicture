//
//  ViewController.m
//  20151117001-CrazyGuessPicture
//
//  Created by Rainer on 15/11/17.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "ViewController.h"
#import "QuestionsModel.h"

#define kAnswerColumn 7
#define kAnswerButtonHeight 35.0
#define kAnswerButtonWidth 35.0
#define kAnswerPading 10.0

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *coinButton;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (strong, nonatomic) IBOutlet UIView *trueAnswerView;
@property (weak, nonatomic) IBOutlet UIView *selectAnswerView;

@property (nonatomic, weak) UIButton *coverButton;

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, assign) int index;

@end

@implementation ViewController

#pragma mark - 控制器加载
/**
 *  控制器试图加载事件
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化题目索引
    self.index = -1;
    
    // 2.初始化当前题目
    [self nextQuestionButtonClickAction];
}

/**
 *  设置状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 私有辅助方法
/**
 *  设置基础信息
 */
- (void)setupBasiceWithQuestion:(QuestionsModel *)questionModel {
    // 1.设置当前序号
    self.countLabel.text = [NSString stringWithFormat:@"%d/%d", self.index + 1, self.questions.count];
    
    // 2.设置当前描述
    self.descriptionLabel.text = questionModel.title;
    
    // 3.设置当前图片
    [self.pictureButton setImage:questionModel.iconImage forState:UIControlStateNormal];
}

/**
 *  设置备选答案列表
 */
- (void)setupSelectAnswerViewWithQuestion:(QuestionsModel *)questionModel {
    // 备选区答案信息
    NSArray *options = questionModel.options;
    
    // 判断当前被选区答案的按钮个数是否和当前题目的备选答案个数一致：如果一致直接给按钮赋值，如果不一致则删掉按钮重新创建
    if (options.count == self.selectAnswerView.subviews.count) {
        // 循环被选区按钮并赋值
        [self.selectAnswerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
            button.hidden = NO;
            [button setTitle:options[idx] forState:UIControlStateNormal];
        }];
    } else {
        // 删除被选区答案按钮
        [self.selectAnswerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        // 重新创建被选区按钮
        CGFloat selectAnswerButtonMargin = (self.view.bounds.size.width - kAnswerButtonWidth * kAnswerColumn) / (kAnswerColumn + 1);
    
        [options enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 当前行
            int currentQuestionRow = idx / kAnswerColumn;
            
            // 当前列
            int currentQuestionCol = idx % kAnswerColumn;
            
            UIButton *questionButton = [[UIButton alloc] init];
            
            [questionButton setTitle:obj forState:UIControlStateNormal];
            [questionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [questionButton setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [questionButton setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
            
            [questionButton addTarget:self action:@selector(selectAnswerButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat questionButtonX = selectAnswerButtonMargin + (selectAnswerButtonMargin + kAnswerButtonWidth) * currentQuestionCol;
            CGFloat questionButtonY = selectAnswerButtonMargin + (selectAnswerButtonMargin + kAnswerButtonHeight) * currentQuestionRow;
            
            questionButton.frame = CGRectMake(questionButtonX, questionButtonY, kAnswerButtonWidth, kAnswerButtonHeight);
            
            [self.selectAnswerView addSubview:questionButton];
        }];
    }
}

/**
 *  设置答案区按钮
 */
- (void)setupAnserViewWithQuestion:(QuestionsModel *)questionModel {
    // 1.如果当前模型中的答案长度和答案视图中的按钮总数一样就不需要重新创建
    if (questionModel.answer.length == self.trueAnswerView.subviews.count) return;
    
    // 2.如果不一样就先将答案视图中的按钮移除
    [self.trueAnswerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    // 3.创建答案按钮
    int answerCount = questionModel.answer.length;
    CGFloat answerButtonStartX = (self.view.bounds.size.width - kAnswerButtonWidth * answerCount - (answerCount + 1)) * 0.5;
    
    for (int i = 0; i < answerCount; i ++) {
        UIButton *answerButton = [[UIButton alloc] init];
        
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerButton addTarget:self action:@selector(trueAnswerButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat answerButtonX = answerButtonStartX + (kAnswerButtonWidth + kAnswerPading) * i;
        answerButton.frame = CGRectMake(answerButtonX, 0, kAnswerButtonWidth, kAnswerButtonHeight);
        
        [self.trueAnswerView addSubview:answerButton];
    }
}

#pragma mark - 按钮监听事件
/**
 *  大图小图切换
 */
- (IBAction)changePicture:(id)sender {
    if (0.0 == self.coverButton.alpha) {
        // 1.将图像调至试图最前端
        [self.view bringSubviewToFront:self.pictureButton];
        
        // 2.调整图片位置大小
        CGFloat pictureButtonW = self.view.bounds.size.width;
        CGFloat pictureButtonH = pictureButtonW;
        CGFloat pictureButtonX = 0;
        CGFloat pictureButtonY = (self.view.bounds.size.height - pictureButtonH) * 0.5;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.coverButton.alpha = 0.8;
            self.pictureButton.frame = CGRectMake(pictureButtonX, pictureButtonY, pictureButtonW, pictureButtonH);
        }];
    } else {
        // 2.调整图片位置大小
        [UIView animateWithDuration:1.0 animations:^{
            self.coverButton.alpha = 0.0;
            self.pictureButton.frame = CGRectMake(85, 98, 150, 150);
        }];
    }
}

/**
 *  下一题按钮点击事件监听
 */
- (IBAction)nextQuestionButtonClickAction {
    self.index++;
    
    if (self.questions.count <= self.index) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您通关了！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // 1.初始化题目索引
            self.index = -1;
            
            // 2.初始化当前题目
            [self nextQuestionButtonClickAction];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    QuestionsModel *questionModel = self.questions[self.index];
    
    // 设置基本信息
    [self setupBasiceWithQuestion:questionModel];
    
    // 设置答案区按钮
    [self setupAnserViewWithQuestion:questionModel];
    
    // 设置被选区按钮
    [self setupSelectAnswerViewWithQuestion:questionModel];
}

/**
 *  提示按钮点击事件处理
 */
- (IBAction)tipButtonClickAction:(id)sender {
    // 1.清空答案区按钮信息
    for (UIButton *button in self.trueAnswerView.subviews) {
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    // 2.恢复被选区隐藏的按钮
    for (UIButton *button in self.selectAnswerView.subviews) {
        if (YES == button.hidden) button.hidden = NO;
    }
    
    // 3.设置第一个按钮的文字信息
    // 3.1.取出当前问题信息
    QuestionsModel *questionsModel = self.questions[self.index];
    
    // 3.2.截取正确答案的一个文字
    NSString *firstWord = [questionsModel.answer substringToIndex:1];
    
    for (UIButton *button in self.selectAnswerView.subviews) {
        if ([firstWord isEqualToString:button.currentTitle]) {
            // 扣除分数
            [self scoreManage:-1000];
            
            // 模拟被选区按钮点击事件
            [self selectAnswerButtonClickAction:button];
            
            break;
        }
    }
}

/**
 *  备选答案按钮点击事件处理
 */
- (void)selectAnswerButtonClickAction:(UIButton *)button {
    // 1.设置答案按钮
    for (UIButton *answerButton in self.trueAnswerView.subviews) {
        if (0 == answerButton.currentTitle.length) {
            // 隐藏当前按钮
            button.hidden = YES;
            
            // 设置答案区按钮
            [answerButton setTitle:button.currentTitle forState:UIControlStateNormal];
            
            break;
        }
    }
    
    // 2.判断结果
    [self checkAnswerWithCurrentButton:button];
}

/**
 *  答案按钮点击事件处理
 */
- (void)trueAnswerButtonClickAction:(UIButton *)button {
    // 1.判断是否点击了空白按钮
    if (0 == button.currentTitle.length) return;
    
    // 2.恢复被选答案按钮
    for (UIButton *selectAnswerButton in self.selectAnswerView.subviews) {
        if ([button.currentTitle isEqualToString:selectAnswerButton.currentTitle] && selectAnswerButton.hidden == YES) {
            selectAnswerButton.hidden = NO;
            
            break;
        }
    }
    
    // 3.清空当前按钮文字
    [button setTitle:nil forState:UIControlStateNormal];
    
    // 4.恢复答案区文字颜色
    for (UIButton *trueAnswerButton in self.trueAnswerView.subviews) {
        [trueAnswerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 业务逻辑处理
/**
 *  验证答案是否正确
 */
- (void)checkAnswerWithCurrentButton:(UIButton *)currentButton {
    // 1.标示答案区是否填满
    BOOL isFull = YES;
    
    // 2.记录玩家选择的答案
    NSMutableString *answerString = [NSMutableString string];
    
    for (UIButton *button in self.trueAnswerView.subviews) {
        if (0 == button.currentTitle.length) {
            isFull = NO;
        } else {
            [answerString appendString:button.currentTitle];
        }
    }
    
    // 3.判断答案是否正确
    if (isFull) {
        // 3.1.取出当前问题
        QuestionsModel *questionsModel = self.questions[self.index];
        
        // 3.2.判断答案是否正确
        if ([questionsModel.answer isEqualToString:answerString]) {
            // 更改答案区文字颜色
            for (UIButton *button in self.trueAnswerView.subviews) {
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            // 增加分数
            [self scoreManage:800];
            
            // 自动跳转到下一题
            [self performSelector:@selector(nextQuestionButtonClickAction) withObject:nil afterDelay:0.5];
        } else {
            // 更改错误时答案区文字颜色
            for (UIButton *button in self.trueAnswerView.subviews) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

/**
 *  分数管理
 */
- (void)scoreManage:(int)score {
    int currentScore = self.coinButton.currentTitle.intValue;
    
    int resultScore = currentScore + score;
    
    [self.coinButton setTitle:[NSString stringWithFormat:@"%d", resultScore] forState:UIControlStateNormal];
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

/**
 *  数据列表懒加载
 */
- (NSArray *)questions {
    if (nil == _questions) {
        _questions = [QuestionsModel questionArray];
    }
    
    return _questions;
}

#pragma mark - 内存管理
/**
 *  内存泄漏处理方法
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

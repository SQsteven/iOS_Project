//
//  ViewController.m
//  ConvertGeometry
//
//  Created by 常彪 on 16/1/6.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UILabel *_labFirst;
    UILabel *_labSecond;
    UILabel *_labThree;
    CATextLayer *_textLayer;
}
@end

@implementation ViewController

//修改了self.view为UILabel
- (void)loadView
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.userInteractionEnabled = YES;
    self.view = lab;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _labFirst = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    _labFirst.backgroundColor = [UIColor greenColor];
    _labFirst.userInteractionEnabled = YES;
    _labFirst.clipsToBounds = NO;
    _labFirst.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_labFirst];
    
    _labSecond = [[UILabel alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
    _labSecond.backgroundColor = [UIColor colorWithRed:0.430 green:0.468 blue:1.000 alpha:1.000];
    _labSecond.textAlignment = NSTextAlignmentCenter;
    [_labFirst addSubview:_labSecond];
    
    _labThree = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    _labThree.backgroundColor = [UIColor cyanColor];
    _labThree.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_labThree];
    
    _textLayer = [CATextLayer layer];
    _textLayer.frame = CGRectMake(50, 400, 80, 80);
    [self.view.layer addSublayer:_textLayer];
    
}

- (void)updateTouchPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView:self.view];
    NSLog(@"相对于self.view触摸的位置 === %@", NSStringFromCGPoint(touchPos));
    //注意：不重写loadView把self.view改成UILabel这里是不能强转的
    ((UILabel *)self.view).text = NSStringFromCGPoint(touchPos);
    
    
    //两种转换方式的结果肯定是一样的
    CGPoint convFirst = [_labFirst convertPoint:touchPos fromView:self.view];
    CGPoint convFirst2 = [self.view convertPoint:touchPos toView:_labFirst];
    //断言：为了判断一条关键的语句是否成立，
    //如果不成立直接挂掉，并且断在这里
    BOOL isPosEqual = CGPointEqualToPoint(convFirst, convFirst2);
    NSAssert(isPosEqual, @"两个点不相等，严重问题！！！");
    _labFirst.text = NSStringFromCGPoint(convFirst);
    
    CGPoint convSecond = [self.view convertPoint:touchPos toView:_labSecond];
    _labSecond.text = NSStringFromCGPoint(convSecond);
    
    CGPoint convThree = [self.view convertPoint:touchPos toView:_labThree];
    _labThree.text = NSStringFromCGPoint(convThree);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

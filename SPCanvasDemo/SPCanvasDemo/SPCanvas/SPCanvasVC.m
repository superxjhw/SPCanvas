//
//  SPCanvasVC.m
//  SPevaluation
//
//  Created by Super Y on 2019/11/19.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import "SPCanvasVC.h"
#import "SPCanvas.h"

@interface SPCanvasVC ()

@property (nonatomic, weak) SPCanvas *canvas;
@property (nonatomic, weak)  UIStackView *stackView;

@end

@implementation SPCanvasVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCanvas];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.canvas.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    self.stackView.frame = CGRectMake(0, CGRectGetMaxY(self.canvas.frame), self.view.bounds.size.width, 50);
}

- (void)setupCanvas {
    self.view.backgroundColor = [UIColor whiteColor];
    
    SPCanvas *canvas = [[SPCanvas alloc] init];
    canvas.lineWidth = 1;
    canvas.pathColor = [UIColor blueColor];
    canvas.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:canvas];
    self.canvas = canvas;
        
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 5;
    [self.view addSubview:stackView];
    self.stackView = stackView;

    NSArray *titles = @[@"back",@"forward",@"eraser:",@"clean",@"save"];
    for (NSInteger i = 0; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] init];
        if ([titles[i] isEqual:@"eraser:"]) {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        }
        button.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.6];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(titles[i]) forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:button];
    }
}

- (void)back {
    [self.canvas back];
}

- (void)forward {
    [self.canvas forward];
}

- (void)clean {
    [self.canvas clean];
}

- (void)eraser:(UIButton *)eraserButton {
    eraserButton.selected = !eraserButton.selected;
    [self.canvas eraser];
}

- (void)save {
    [self.canvas save];
}


@end

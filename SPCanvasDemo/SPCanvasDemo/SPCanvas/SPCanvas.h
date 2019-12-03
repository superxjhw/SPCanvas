//
//  SPCanvas.h
//  SPevaluation
//
//  Created by Super Y on 2019/11/19.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPCanvas : UIView

@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, assign) BOOL isEraser;
@property (nonatomic,assign) CGFloat lineWidth;

- (void)back;
- (void)forward;
- (void)clean;
- (void)eraser;
- (void)save;


@end

NS_ASSUME_NONNULL_END

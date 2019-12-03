//
//  SPCanvas.m
//  SPevaluation
//
//  Created by Super Y on 2019/11/19.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import "SPCanvas.h"
#import "SPBezierPath.h"

@interface SPCanvas ()

@property (nonatomic, strong) SPBezierPath *path;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *cancles;
@property (nonatomic, assign) CGPoint preMidllePoint2;

@end

@implementation SPCanvas

- (NSMutableArray *)paths {
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (NSMutableArray *)cancles {
    if (_cancles == nil) {
        _cancles = [NSMutableArray array];
    }
    return _cancles;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    self.preMidllePoint2 = curPoint;
    self.path = [[SPBezierPath alloc] init];
    if (self.isEraser) {
        self.path.pathColor = [UIColor whiteColor];
        self.path.lineWidth = self.lineWidth * 10;
    }else {
        self.path.pathColor = self.pathColor;
        self.path.lineWidth = self.lineWidth;
    }
    self.path.lineJoinStyle = kCGLineJoinRound;
    self.path.lineCapStyle = kCGLineCapRound;
    [self.path moveToPoint:curPoint];
    [self.paths addObject:self.path];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGPoint curPoint = [touch locationInView:self];
    //  线条优化 明显不可行 仅仅测试
//    if ([touch respondsToSelector:@selector(force)]) {
//        if (touch.force > 2) {
//            self.path.lineWidth = self.lineWidth;
//        }else {
//            self.path.lineWidth = self.lineWidth * touch.force / 2.0;
//        }
//    }
    CGPoint midllePoint = [self getMidllePointPrePoint:prePoint curPoint:curPoint];
    CGPoint midllePoint1 = [self getMidllePointPrePoint:prePoint curPoint:midllePoint];
    CGPoint midllePoint2 = [self getMidllePointPrePoint:curPoint curPoint:midllePoint];
    [self.path addQuadCurveToPoint:midllePoint1 controlPoint:[self getMidllePointPrePoint:self.preMidllePoint2 curPoint:midllePoint1]];
    [self.path addLineToPoint:midllePoint2];
    self.preMidllePoint2 = midllePoint2;
    CGFloat margin = 80;
    [self setNeedsDisplayInRect:CGRectMake(MIN(prePoint.x, curPoint.x) - margin, MIN(prePoint.y, curPoint.y) - margin, MAX(prePoint.x, curPoint.x) - MIN(prePoint.x, curPoint.x) + 2 * margin, MAX(prePoint.y, curPoint.y) - MIN(prePoint.y, curPoint.y) + 2 * margin)];
}

- (CGPoint)getMidllePointPrePoint:(CGPoint)prePoint curPoint:(CGPoint)curPoint {
    return CGPointMake((prePoint.x + curPoint.x) * 0.5, (prePoint.y + curPoint.y) * 0.5);
}

- (void)drawRect:(CGRect)rect {
    for (SPBezierPath *path in self.paths) {
        [path.pathColor set];
        [path stroke];
    }
}

- (void)back {
    if (self.paths.count) {
        [self.cancles addObject:self.paths.lastObject];
        [self.paths removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)forward {
    if (self.cancles.count) {
        [self.paths addObject:self.cancles.lastObject];
        [self.cancles removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)clean {
    [self.paths removeAllObjects];
    [self.cancles removeAllObjects];
    [self setNeedsDisplay];
}

- (void)eraser {
    self.isEraser = !self.isEraser;
}

- (void)save {
    
}


@end
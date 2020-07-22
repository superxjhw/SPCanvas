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
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint preMidllePoint;

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
    self.lastPoint = self.preMidllePoint = curPoint;
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
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    CGPoint midllePoint = [self getMidllePointPrePoint:self.lastPoint curPoint:curPoint];
    [self.path addQuadCurveToPoint:midllePoint controlPoint:self.lastPoint];
    // 绘制区域 + 10 只是为了处理拐角 > 270° 的情况
    CGFloat margin = self.path.lineWidth / 2 + 10;
    [self setNeedsDisplayInRect:CGRectMake(MIN(self.preMidllePoint.x, midllePoint.x) - margin, MIN(self.preMidllePoint.y, midllePoint.y) - margin, MAX(self.preMidllePoint.x, midllePoint.x) - MIN(self.preMidllePoint.x, midllePoint.x) + 2 * margin, MAX(self.preMidllePoint.y, midllePoint.y) - MIN(self.preMidllePoint.y, midllePoint.y) + 2 * margin)];
    self.lastPoint = curPoint;
    self.preMidllePoint = midllePoint;
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
    UIImage *image = [self getImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
     ///图片未能保存到本地
        NSLog(@"SuperLog------ 保存图片失败");
    }else {
        NSLog(@"SuperLog------ 已保存");
    }
}

- (UIImage *)getImage {
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = self.frame;
    [self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}


@end

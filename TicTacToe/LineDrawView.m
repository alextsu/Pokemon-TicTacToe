//
//  LineDrawView.m
//  TicTacToe
//
//  Created by Alexander Tsu on 2/5/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "LineDrawView.h"

@interface LineDrawView ()
@property CGPoint firstPoint;
@property CGPoint secondPoint;
@end

@implementation LineDrawView

-(void)passFirstPoint:(CGPoint) fp andSecondPoint:(CGPoint) sp {
    self.firstPoint = fp;
    self.secondPoint = sp;
    
    [self setNeedsDisplay];
}

- (void) clearLine {
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.secondPoint.x, self.secondPoint.y);
    CGContextStrokePath(context);
    
}


@end

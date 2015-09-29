//
//  TicTacToeSquareView.m
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "TicTacToeSquareView.h"

@implementation TicTacToeSquareView

//method to check if x or o overlaps?
//method to check if the current square is already occupied
//method to check whether square is an x or an o


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    NSLog(@"You touched Square %d", self.positionNumber);
    NSLog(@"Coordinates for this Square are %d, %d", self.xCoordinate, self.yCoordinate);
}

@end

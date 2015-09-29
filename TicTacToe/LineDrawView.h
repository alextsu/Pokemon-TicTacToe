//
//  LineDrawView.h
//  TicTacToe
//
//  Created by Alexander Tsu on 2/5/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDrawView : UIView
- (void) clearLine;
-(void)passFirstPoint:(CGPoint) fp andSecondPoint:(CGPoint) sp;
@end

//
//  XView.h
//  TicTacToe
//
//  Created by Alexander Tsu on 2/4/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XView : UIImageView

@property (nonatomic, assign) id  delegate;

@end


@protocol XViewDelegate

-(void) getXOverlap: (XView *) XView;
@end
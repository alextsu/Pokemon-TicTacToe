//
//  OView.h
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface OView : UIImageView

@property (nonatomic, assign) id  delegate;

@end


@protocol OViewDelegate

-(void) getOverlap: (OView *) OView;
@end
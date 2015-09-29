//
//  TicTacToeSquareView.h
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicTacToeSquareView : UIImageView
@property int positionNumber;
@property int xCoordinate;
@property int yCoordinate;
@property (strong, nonatomic) NSString* occupancy;
@end

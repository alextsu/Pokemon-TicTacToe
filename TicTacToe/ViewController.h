//
//  ViewController.h
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OView.h"
#import "XView.h"
#import "GameInfoView.h"
#import "LineDrawView.h"

@interface ViewController : UIViewController <OViewDelegate, XViewDelegate>
- (IBAction)getGameInfo:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *givButton;
@property (weak, nonatomic) IBOutlet GameInfoView *giv;
@property (weak, nonatomic) IBOutlet XView *zubat;
@property (weak, nonatomic) IBOutlet OView *pokeball;
@property (weak, nonatomic) IBOutlet LineDrawView *ldv;
- (IBAction)dismissGameInfo:(UIButton *)sender;
@end


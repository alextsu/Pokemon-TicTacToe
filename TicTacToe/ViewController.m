//
//  ViewController.m
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "ViewController.h"
#import "TicTacToeSquareView.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray*squares;
@end

AVAudioPlayer *audioPlayer;
BOOL isPlayerXTurn;
CGPoint gameInfoStartingLocation;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.squares = [[NSMutableArray alloc] init];
    
    CGPoint gameInfoCenter = [self.giv center];
    
    gameInfoCenter.y = gameInfoCenter.y - 500;
    [self.giv setCenter:gameInfoCenter];
    gameInfoStartingLocation = gameInfoCenter;
    [self gameSetup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gameSetup {
    for(int i = 0; i<9; i++) {
        int x = i;
        
        int y = 0;
        if(i >= 3 && i<6) {
            y = 1;
            x = x - 3;
        }
        if(i>= 6) {
            y = 2;
            x = x - 6;
        }
        
        TicTacToeSquareView * ttt = [[TicTacToeSquareView alloc] initWithFrame:CGRectMake(0+125*x, 72+125*y, 125, 125)];
        [ttt setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [ttt setUserInteractionEnabled:YES];
        [ttt setPositionNumber:i];
        [ttt setXCoordinate:0+125*x];
        [ttt setYCoordinate:72+125*y];
        ttt.occupancy = [[NSString alloc]init];
        [self.view addSubview:ttt];
        [self.squares addObject:ttt];
        
        self.pokeball.delegate = self;
        self.zubat.delegate = self;
        
        isPlayerXTurn = YES;
        [self.pokeball setUserInteractionEnabled:NO];
        [self.pokeball setAlpha:0.5];
    }
}

- (IBAction)getGameInfo:(UIButton *)sender {
    [self.view bringSubviewToFront:self.giv];
    [self.giv setCenter:gameInfoStartingLocation];
    self.givButton.enabled = NO;
    [UIView animateWithDuration:1.25 animations:^{
        CGPoint gameInfoCenter = [self.giv center];
        gameInfoCenter.y = gameInfoCenter.y + 500;
        [self.giv setCenter:gameInfoCenter];
    }
                     completion:^(BOOL completed) {
                     }
     ];
}

- (IBAction)dismissGameInfo:(UIButton *)sender {
    self.givButton.enabled = YES;
    [UIView animateWithDuration:1.25 animations:^{
        CGPoint gameInfoCenter = [self.giv center];
        gameInfoCenter.y = gameInfoCenter.y + 600;
        [self.giv setCenter:gameInfoCenter];
    }
                     completion:^(BOOL completed) {
                     }
     ];
    
}

- (void) getOverlap:(OView *)OView {
    [self overlapChecker:@"pokeball" andPointChecker:OView.center];
}

- (void) getXOverlap:(XView *)XView {
    [self overlapChecker:@"zubat" andPointChecker:XView.center];
}

- (void) overlapChecker:(NSString*)player andPointChecker:(CGPoint) point {

    for(int i = 0; i < [self.squares count]; i++) {
        //Get the 4 corners of each square in the UIImageView array representing the spaces in the board
        int a = [self.squares[i] xCoordinate];
        int b = [self.squares[i] yCoordinate];
        int c = [self.squares[i] xCoordinate]+125;
        int d = [self.squares[i] yCoordinate]+125;
        
        //Check if the point passed from the delegate method is within the boundaries of the board
        if(point.x > a && point.x < c && point.y > b && point.y < d) {
            
            //Check if overlapped square is occupied
            if ([[self.squares[i] occupancy] length] == 0  ) {
        
                //If it's empty, set the uiviewimage to the corresponding piece and switch player turns
                NSString* imageName = [NSString stringWithFormat: @"%@.png", player];
                [self.squares[i] setImage:[UIImage imageNamed:imageName]];
                [self.squares[i] setOccupancy:player];
                
                //Play the sound indicating you've put the piece on a correct tile
                NSString *path = [NSString stringWithFormat:@"%@/pikachu.mp3", [[NSBundle mainBundle] resourcePath]];
                NSURL *soundUrl = [NSURL fileURLWithPath:path];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
                [audioPlayer play];
                
                //Check for win. If true, play sound
                if([self checkForWin:player]) {
                    
                    //Bring line to front view
                    [self.view bringSubviewToFront:self.ldv];
                    [self.ldv setAlpha:1.0];
                    
                    NSString *path = [NSString stringWithFormat:@"%@/fatality.mp3", [[NSBundle mainBundle] resourcePath]];
                    NSURL *soundUrl = [NSURL fileURLWithPath:path];
                    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
                    [audioPlayer play];
                    
                    //Create UIAlert
                    NSString * winMessage = [NSString stringWithFormat:@"Team %@ wins!", player];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:winMessage delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
                    [alert show];
                }
                //Check for a tie
                else if ([self checkForTie]) {
                    //Create UIAlert
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Tie game!" delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
                    [alert show];
                }
                //If no win or tie, switch turns
                else {
                    [self turnSwitcher];
                }
            }
            else {
                //Play Nope Sound when Space is Occupied
                NSString *path = [NSString stringWithFormat:@"%@/nope.mp3", [[NSBundle mainBundle] resourcePath]];
                NSURL *soundUrl = [NSURL fileURLWithPath:path];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
                [audioPlayer play];
                
                //Animate the X or O back to start
                [UIView animateWithDuration:1.5 animations:^{
                        if(isPlayerXTurn) self.zubat.center = CGPointMake(325, 617);
                        else self.pokeball.center = CGPointMake(50, 617);
                        }
                        completion:^(BOOL completed) {
                        }
                ];
            }
        }
    }
}

//Triggered when user dismisses the win or tie UIAlert
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    //Delete the line
    //[self.ldv removeFromSuperview];
    [self.ldv setAlpha:0.0];
    [self.view sendSubviewToBack:self.ldv];
    
    [self startNewGame];
}

//Start a new game by animating the squares off the screen,resetting the UIView array, resetting the pieces, and setting up the new game
- (void) startNewGame {
    for(int i = 0; i < [self.squares count]; i++) {
        [UIView animateWithDuration:2.0 animations:^{
            
            CGPoint currentCenter = [self.squares[i] center];
            currentCenter.x = currentCenter.x + 400;
            [self.squares[i] setCenter:currentCenter];
            
        }
                         completion:^(BOOL completed) {
                         }
         ];
    }
    [self.squares removeAllObjects];
    
    [self.pokeball setUserInteractionEnabled:YES];
    [self.pokeball setAlpha:1.0];
    [self.zubat setUserInteractionEnabled:YES];
    [self.zubat setAlpha:1.0];
    
    //[self.view insertSubview:self.ldv belowSubview:self.zubat];
    
    [self gameSetup];
}

//Switches player turns by setting UserInteraction and Alpha
- (void) turnSwitcher {
    //If it's X's turn
    if(isPlayerXTurn == YES) {
        isPlayerXTurn = NO;
        [self.zubat setUserInteractionEnabled:NO];
        [self.zubat setAlpha:0.5];
        
        [self.pokeball setUserInteractionEnabled:YES];
        [self.pokeball setAlpha:1.0];
        
        //Animate the growth & shrink of the icon
        [UIView animateWithDuration:0.5 animations:^{
                self.pokeball.center = CGPointMake(50, 517);
                CGRect newFrame = self.pokeball.frame;
                newFrame.size.width = 200;
                newFrame.size.height = 200;
                [self.pokeball setFrame:newFrame];
        }
                completion:^(BOOL completed) {
                    [UIView animateWithDuration:1.0 animations:^{
                        self.pokeball.center = CGPointMake(100, 667);
                        CGRect newFrame = self.pokeball.frame;
                        newFrame.size.width = 100;
                        newFrame.size.height = 100;
                        [self.pokeball setFrame:newFrame];
                    }
                                     completion:^(BOOL completed) {
                                     }
                     ];
                }
         ];

    }
    //If it's O's turn
    else {
        isPlayerXTurn = YES;
        [self.pokeball setUserInteractionEnabled:NO];
        [self.pokeball setAlpha:0.5];
        
        [self.zubat setUserInteractionEnabled:YES];
        [self.zubat setAlpha:1.0];
        
        //Animate the growth & shrink of the icon
        [UIView animateWithDuration:0.5 animations:^{
            self.zubat.center = CGPointMake(225, 517);
            CGRect newFrame = self.zubat.frame;
            newFrame.size.width = 200;
            newFrame.size.height = 200;
            [self.zubat setFrame:newFrame];
        }
                         completion:^(BOOL completed) {
                             [UIView animateWithDuration:1.0 animations:^{
                                 self.zubat.center = CGPointMake(375, 667);
                                 CGRect newFrame = self.zubat.frame;
                                 newFrame.size.width = 100;
                                 newFrame.size.height = 100;
                                 [self.zubat setFrame:newFrame];
                             }
                                              completion:^(BOOL completed) {
                                              }
                              ];
                         }
         ];
    }
}

//Checks for ties. Returns true if game is tied
- (BOOL) checkForTie {
    for(int i = 0; i < [self.squares count]; i++) {
        if ([[self.squares[i] occupancy] length] == 0  ) {
            return false;
        }
    }
    return true;
}

//Checks each win condition on TicTacToe board. Pass draw line coordinates to uiview. Returns true if game has been won
- (BOOL) checkForWin: (NSString *) player {
    if([[self.squares[0] occupancy] isEqualToString:player]  && [[self.squares[0] occupancy] isEqualToString:[self.squares[1] occupancy]] && [[self.squares[0] occupancy] isEqualToString:[self.squares[2] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(0, 125/2+72) andSecondPoint:CGPointMake(375, 125/2+72)];
        return true;
    }
    else if([[self.squares[3] occupancy] isEqualToString:player]  &&[[self.squares[3] occupancy] isEqualToString:[self.squares[4] occupancy]] && [[self.squares[3] occupancy] isEqualToString:[self.squares[5] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(0, (3*125)/2+72) andSecondPoint:CGPointMake(375, (3*125)/2+72)];
        return true;
    }
    else if([[self.squares[6] occupancy] isEqualToString:player]  &&[[self.squares[6] occupancy] isEqualToString:[self.squares[7] occupancy]] && [[self.squares[6] occupancy] isEqualToString:[self.squares[8] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(0, (5*125)/2+72) andSecondPoint:CGPointMake(375, (5*125)/2+72)];
        return true;
    }
    else if([[self.squares[0] occupancy] isEqualToString:player]  &&[[self.squares[0] occupancy] isEqualToString:[self.squares[3] occupancy]] && [[self.squares[0] occupancy] isEqualToString:[self.squares[6] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(125/2, 72) andSecondPoint:CGPointMake(125/2, 375+72)];
        return true;
    }
    else if([[self.squares[1] occupancy] isEqualToString:player]  &&[[self.squares[1] occupancy] isEqualToString:[self.squares[4] occupancy]] && [[self.squares[1] occupancy] isEqualToString:[self.squares[7] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(125+125/2, 72) andSecondPoint:CGPointMake(125+125/2, 375+72)];
        return true;
    }
    else if([[self.squares[2] occupancy] isEqualToString:player]  &&[[self.squares[2] occupancy] isEqualToString:[self.squares[5] occupancy]] && [[self.squares[2] occupancy] isEqualToString:[self.squares[8] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(2*125+125/2, 72) andSecondPoint:CGPointMake(2*125+125/2, 375+72)];
        return true;
    }
    else if([[self.squares[0] occupancy] isEqualToString:player]  &&[[self.squares[0] occupancy] isEqualToString:[self.squares[4] occupancy]] && [[self.squares[0] occupancy] isEqualToString:[self.squares[8] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(0, 72) andSecondPoint:CGPointMake(375, 375+72)];
        return true;
    }
    else if([[self.squares[2] occupancy] isEqualToString:player]  &&[[self.squares[2] occupancy] isEqualToString:[self.squares[4] occupancy]] && [[self.squares[2] occupancy] isEqualToString:[self.squares[6] occupancy]]) {
        [self.ldv passFirstPoint:CGPointMake(375, 72) andSecondPoint:CGPointMake(0, 375+72)];
        return true;
    }
    return false;
}

@end

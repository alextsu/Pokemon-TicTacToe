//
//  OView.m
//  TicTacToe
//
//  Created by Alexander Tsu on 2/3/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "OView.h"
CGPoint currentPoint;
AVAudioPlayer *audioPlayer;

@implementation OView
@synthesize delegate;


//Audio code was taken from the following link: http://codewithchris.com/avaudioplayer-tutorial/
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // When a touch starts, get the current location in the view
    currentPoint = [[touches anyObject] locationInView:self];
    self.alpha = 1.0;
    
    NSString *path = [NSString stringWithFormat:@"%@/snap.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    [audioPlayer play];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate getOverlap:self];
    self.center = CGPointMake(50, 617);
    //self.alpha = 0.5;
    
    
}

//Following code is taken from iOS developer:tips at the following URL http://iosdevelopertips.com/graphics/drag-an-image-within-the-bounds-of-superview.html
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Get active location upon move
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    // Determine new point based on where the touch is now located
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
                                   self.center.y + (activePoint.y - currentPoint.y));
    
    //--------------------------------------------------------
    // Make sure we stay within the bounds of the parent view
    //--------------------------------------------------------
    float midPointX = CGRectGetMidX(self.bounds);
    // If too far right...
    if (newPoint.x > self.superview.bounds.size.width  - midPointX)
        newPoint.x = self.superview.bounds.size.width - midPointX;
    else if (newPoint.x < midPointX)  // If too far left...
        newPoint.x = midPointX;
    
    float midPointY = CGRectGetMidY(self.bounds);
    // If too far down...
    if (newPoint.y > self.superview.bounds.size.height  - midPointY)
        newPoint.y = self.superview.bounds.size.height - midPointY;
    else if (newPoint.y < midPointY)  // If too far up...
        newPoint.y = midPointY;
    
    // Set new center location
    self.center = newPoint;
}
@end

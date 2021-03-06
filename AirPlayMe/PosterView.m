//
//  PosterView.m
//  AirPlayMe
//
//  Created by Plamen Todorov on 21.10.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "PosterView.h"
#import "Config.h"

@interface PosterView ()
{
    NSTrackingArea *trackingArea;
}

@property (assign) BOOL largeView;

@end

@implementation PosterView
@synthesize largeView;

-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {
        self.imageScaling = NSImageScaleAxesIndependently;
        self.imageAlignment = NSImageAlignCenter;
        
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CORNER_RADIUS;
        self.layer.borderWidth = 2;
        self.layer.borderColor = rgba(255, 255, 255, 0.2).CGColor;
        
        [self setNeedsDisplay];
    }
    
    return self;
}

-(void)viewWillDraw
{
    [super viewWillDraw];
    
    if(!largeView)return;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = rgba(255, 255, 255, 0.2).CGColor;
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    if(largeView) return;
    
    self.layer.borderColor = TINT_COLOR.CGColor;
//    self.alphaValue = 0.5;
    [self setNeedsDisplay];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if(largeView) return;
    
    self.layer.borderColor = rgba(255, 255, 255, 0.2).CGColor;;
//    self.alphaValue = 1.0;
    [self setNeedsDisplay];
}

-(void)updateTrackingAreas
{
    if(largeView) return;
    
    if(trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds] options:opts owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

@end

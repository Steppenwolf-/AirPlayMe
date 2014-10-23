//
//  BrowserViewItem.m
//  AirPlayMe
//
//  Created by Plamen Todorov on 19.10.14.
//  Copyright (c) 2014 г. Plamen Todorov. All rights reserved.
//

#import "BrowserViewItem.h"
#import "AppDelegate.h"
#import "Library.h"
#import "ShadowView.h"

@interface BrowserViewItem ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak) IBOutlet NSButton *playButton;
@end

@implementation BrowserViewItem
@synthesize nameField, imageView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    self.playButton.hidden = YES;
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:self.imageView.frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways) owner:self userInfo:nil];
    [self.view addTrackingArea:area];
}

-(IBAction)singleClick:(id)sender
{
    if([[[self.representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"TVShow"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenTVShowDetails object:self.representedObject];
    }
    else if([[[self.representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"Movie"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenMovieDetails object:self.representedObject];
    }
}

-(IBAction)playVideo:(id)sender
{
    if([[[self.representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"Movie"]){
        Movie *movie = (Movie *) self.representedObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayItem object:movie.path];
    }
}

-(void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    if(!representedObject) return;
    
    if([[[representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"TVShow"])
    {
        TVShow *show = (TVShow *)representedObject;
        
        self.imageView.image = [[NSImage alloc] initWithData:show.poster];
        self.nameField.stringValue = show.original_name;
        self.yearField.stringValue = [[YLMoment momentWithDate:show.first_air_date] format:@"YYYY"];
    }
    else if([[[representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"Movie"])
    {
        Movie *movie = (Movie *)representedObject;
        self.nameField.stringValue = movie.title;
        self.yearField.stringValue = movie.year;
        
        if([movie.tmdbID intValue] > 0){
            self.imageView.image = [[NSImage alloc] initWithData:movie.poster];
            self.nameField.stringValue = movie.original_title;
            self.yearField.stringValue = [[YLMoment momentWithDate:movie.release_date] format:@"YYYY"];
        }
    }
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    if([[[self.representedObject valueForKey:@"entity"] valueForKey:@"name"] isEqualToString:@"Movie"]){
        self.playButton.hidden = NO;
    }
}

-(void)mouseExited:(NSEvent *)theEvent
{
    self.playButton.hidden = YES;
}

@end

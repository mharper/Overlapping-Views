//
//  WedgeViewComponent.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WedgeViewComponent.h"


@implementation WedgeViewComponent

@synthesize magnified;
@synthesize originalViewFrame;
@synthesize magnifiedViewFrame;
@synthesize normalTransform;
@synthesize magnifyTransform;
@synthesize magnifyBounceTransform;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    magnified = NO;
    originalViewFrame = self.frame;
    magnifiedViewFrame = CGRectInset(originalViewFrame, -10.0, -10.0);
    normalTransform = self.transform;
    magnifyTransform = CGAffineTransformMakeScale(1.5, 1.5);
    magnifyBounceTransform = CGAffineTransformMakeScale(1.75, 1.75);
	}
	return self;
}

-(void) trackTouches:(NSSet *) touches withEvent:(UIEvent *) event
{
  NSLog(@"trackTouches for view tag %d.\n", self.tag);
  if (!magnified)
  {
    [self magnify];
  }
}

-(void) stopTrackingTouches
{
  if (magnified)
  {
    [self unmagnify];
  }
}

-(void) magnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	self.transform = magnifyBounceTransform;
	[UIView commitAnimations];
  // self.frame = magnifiedViewFrame;
  self.magnified = YES;
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	self.transform = magnifyTransform;	
	[UIView commitAnimations];
}

-(void) unmagnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	self.transform = normalTransform;	
	[UIView commitAnimations];
  // self.frame = originalViewFrame;
  self.magnified = NO;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}


@end

//
//  WedgeView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WedgeView.h"

@interface WedgeView()
-(WedgeViewComponent *) viewFromTouches:(NSSet *) touches withEvent:(UIEvent *)event;
@end

@implementation WedgeView

@synthesize scoreValue; 
@synthesize rotateAngle;
@synthesize selectedComponentView;

+(WedgeView *) wedgeWithValue:(NSInteger) scoreValue angle:(CGFloat) radians
{
  WedgeView *newWedge = [[[WedgeView alloc] init] autorelease];
  newWedge.scoreValue = scoreValue;
  newWedge.rotateAngle = radians;
  return newWedge;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    self.selectedComponentView = nil;
    
    // Add the various subviews that comprise the entire wedge.
    CGFloat overallWedgeRadius = 130.0;
    CGFloat innerWedgeRadius = overallWedgeRadius * 3.0 / 5.0;
    WedgeViewComponent *innerWedge = [WedgeViewComponent wedgeWithOuterRadius:innerWedgeRadius radialLength:innerWedgeRadius];
    innerWedge.tag = 501;
    innerWedge.frame = CGRectMake(25, 25, innerWedge.frame.size.width, innerWedge.frame.size.height);
    [self addSubview:innerWedge];
	}
	return self;
}


-(void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
  WedgeViewComponent *touchedView = [self viewFromTouches:touches withEvent:event];
  if (touchedView != nil)
  {
    [touchedView trackTouches:touches withEvent:event];
    self.selectedComponentView = touchedView;
  }
}

-(void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
  WedgeViewComponent *touchedView = [self viewFromTouches:touches withEvent:event];
  if (touchedView != nil)
  {
    if (selectedComponentView == nil)
    {
      self.selectedComponentView = touchedView;
      [selectedComponentView trackTouches:touches withEvent:event];
    }
    else
    {
      if (selectedComponentView != touchedView)
      {
        [selectedComponentView stopTrackingTouches];
        self.selectedComponentView = touchedView;
        [selectedComponentView trackTouches:touches withEvent:event];
      }
    }
  }
  
  // Moved outside of all interested views.
  else
  {
    [selectedComponentView stopTrackingTouches];
    self.selectedComponentView = nil;
  }
}

-(void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
  if (selectedComponentView != nil)
  {
    [selectedComponentView stopTrackingTouches];
    self.selectedComponentView = nil;
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (selectedComponentView != nil)
  {
    [selectedComponentView stopTrackingTouches];
    self.selectedComponentView = nil;
  }
}

-(WedgeViewComponent *) viewFromTouches:(NSSet *) touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];	
  UIView *touchedView = [self hitTest:[touch locationInView:self] withEvent:event];
  return ([touchedView isKindOfClass:[WedgeViewComponent class]] ? (WedgeViewComponent *) touchedView : nil);
}

- (void)dealloc {
    [super dealloc];
}


@end

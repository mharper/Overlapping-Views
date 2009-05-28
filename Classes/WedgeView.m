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
    CGFloat ringThickness = 9.0;
    CGFloat wedgeX = 25.0;
    
    // Add inner wedge.
    CGFloat innerWedgeRadius = overallWedgeRadius * 3.0 / 5.0;
    WedgeViewComponent *innerWedge = [WedgeViewComponent wedgeWithOuterRadius:innerWedgeRadius radialLength:innerWedgeRadius];
    innerWedge.tag = 501;
    innerWedge.frame = CGRectMake(wedgeX, 25.0, innerWedge.frame.size.width, innerWedge.frame.size.height);
    wedgeX += innerWedge.frame.size.width;
    
    // Add triple ring.
    CGFloat tripleRingRadius = innerWedgeRadius + ringThickness;
    WedgeViewComponent *tripleRing = [WedgeViewComponent wedgeWithOuterRadius:tripleRingRadius radialLength:ringThickness];
    tripleRing.fillColor = [UIColor greenColor].CGColor;
    tripleRing.tag = 503;
    tripleRing.frame = CGRectMake(wedgeX, 25.0 - (tripleRing.frame.size.height - innerWedge.frame.size.height) / 2.0, tripleRing.frame.size.width, tripleRing.frame.size.height);
    wedgeX += tripleRing.frame.size.width;
    
    // Add outer wedge.
    CGFloat outerWedgeRadius = overallWedgeRadius - ringThickness;
    WedgeViewComponent *outerWedge = [WedgeViewComponent wedgeWithOuterRadius:outerWedgeRadius radialLength:outerWedgeRadius - tripleRingRadius];
    outerWedge.tag = 504;
    outerWedge.frame = CGRectMake(wedgeX, 25.0 - (outerWedge.frame.size.height - innerWedge.frame.size.height) / 2.0, outerWedge.frame.size.width, outerWedge.frame.size.height);
    wedgeX += outerWedge.frame.size.width;
    
    // Add double ring.
    CGFloat doubleRingRadius = overallWedgeRadius;
    WedgeViewComponent *doubleRing = [WedgeViewComponent wedgeWithOuterRadius:doubleRingRadius radialLength:ringThickness];
    doubleRing.fillColor = [UIColor greenColor].CGColor;
    doubleRing.tag = 502;
    doubleRing.frame = CGRectMake(wedgeX, 25.0 - (doubleRing.frame.size.height - innerWedge.frame.size.height) / 2.0, doubleRing.frame.size.width, doubleRing.frame.size.height);

    // Add the subviews in the desired priority, e. g. double/triple rings "on top."
    [self addSubview:innerWedge];
    [self addSubview:outerWedge];
    [self addSubview:tripleRing];
    [self addSubview:doubleRing];

	}
	return self;
}


-(void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
  WedgeViewComponent *touchedView = [self viewFromTouches:touches withEvent:event];
  if (touchedView != nil)
  {
    if ([touchedView shouldTrackTouches:touches withEvent:event])
    {
      [touchedView trackTouches:touches withEvent:event];
    }
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

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
      // Add the various subviews that comprise the entire wedge.
      NSLog(@"WedgeView initWithFrame:\n");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    self.selectedComponentView = nil;
	}
	return self;
}

/*
- (void)drawRect:(CGRect)rect
{
  // Well to start with, the origin is going to be to the left at the midpoint for angle = 0 and
  // the arc of the circle is going to touch directly across on the right.  For a straight up and down (pi/4) wedge,
  // the origin is at the bottom and the arc midpoint is at the top.  So, let's draw at least a triangle.
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  // Drawing with a white stroke color
  CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);
  CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + (rect.size.height / 2));
  CGContextAddLineToPoint(context, rect.size.width, 0);
  CGContextStrokePath(context);
/*
  // Rotate the coordinates by number of wedges already done plus half a wedge.
  CGContextRotateCTM(context, -((wedgeIndex * WEDGE_ANGLE) + WEDGE_ANGLE / 2.0));
  CGContextMoveToPoint(context, 0, 0);
  CGContextAddLineToPoint(context, wedgeRadius, 0);
  
  // Rotate a full wedge the other way and finish the wedge.
  CGContextAddArcToPoint(context, wedgeRadius, wedgeRadius * tan(WEDGE_ANGLE / 2.0), wedgeRadius * cos(WEDGE_ANGLE), wedgeRadius * sin(WEDGE_ANGLE), wedgeRadius);
  
  //CGContextAddLineToPoint(context, wedgeRadius, 0);
  CGContextAddLineToPoint(context, 0, 0);
  
  // Fill the wedge.
  CGContextFillPath(context);
  CGContextStrokePath(context);
}
 */  

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

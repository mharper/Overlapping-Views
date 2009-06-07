//
//  WedgeView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WedgeView.h"
#import "WedgeViewComponent.h"

#define WEDGE_WIDTH 130
#define WEDGE_HEIGHT 100

@interface WedgeView()
-(WedgeViewComponent *) viewFromTouches:(NSSet *) touches withEvent:(UIEvent *)event;
-(void) magnify;
-(void) unmagnify;
- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
-(void) addWedgeSubviews;

@end

@implementation WedgeView

@synthesize scoreValue; 
@synthesize rotateAngle;
@synthesize selectedComponentView;
@synthesize normalTransform;
@synthesize magnifyTransform;
@synthesize magnifyBounceTransform;
@synthesize selectionScoreView;

+(WedgeView *) wedgeWithValue:(NSInteger) scoreValue angle:(CGFloat) radians
{
  WedgeView *newWedge = [[[WedgeView alloc] initWithFrame:CGRectMake(0, 0, WEDGE_WIDTH, WEDGE_HEIGHT)] autorelease];
  newWedge.scoreValue = scoreValue;
  newWedge.rotateAngle = radians;
  
  // Move the view so the pointy parts line up again.
  CGPoint wedgeOffset = CGPointMake(WEDGE_WIDTH * (cos(newWedge.rotateAngle) - 1.0) / 2.0, WEDGE_WIDTH * sin(newWedge.rotateAngle) / 2.0);
  newWedge.center = CGPointMake(newWedge.center.x + wedgeOffset.x, newWedge.center.y + wedgeOffset.y);
  return newWedge;
}


-(void) setRotateAngle:(CGFloat) angle
{
  // This rotates the view by setting a rotation transform.  What I need to do also is to move the view because I really want it to rotate around the point of the wedge.
  // Transforms rotate around the view's center.
  self->rotateAngle = angle;
  //self.normalTransform = CGAffineTransformRotate(CGAffineTransformMakeTranslation((self.center.x * cos(angle)) - self.center.x, self.center.y * sin(angle)), angle);
  self.normalTransform = CGAffineTransformMakeRotation(angle);
  self.transform = normalTransform;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      [self addWedgeSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    self.selectedComponentView = nil;
    
    [self addWedgeSubviews];
	}
	return self;
}

-(void) addWedgeSubviews
{
  normalTransform = self.transform;
  magnifyTransform = CGAffineTransformMakeScale(2.0, 2.0);
  magnifyBounceTransform = CGAffineTransformMakeScale(2.5, 2.5);
  
  // Add the various subviews that comprise the entire wedge.
  CGFloat overallWedgeRadius = 130.0;
  CGFloat ringThickness = 9.0;
  CGFloat wedgeX = 0.0;
  CGFloat wedgeY = self.bounds.size.height / 2.0;
  
  // Add inner wedge.
  CGFloat innerWedgeRadius = overallWedgeRadius * 3.0 / 5.0;
  WedgeViewComponent *innerWedge = [WedgeViewComponent wedgeWithOuterRadius:innerWedgeRadius radialLength:innerWedgeRadius];
  innerWedge.tag = 501;
  innerWedge.frame = CGRectMake(wedgeX, wedgeY - innerWedge.frame.size.height / 2.0, innerWedge.frame.size.width, innerWedge.frame.size.height);
  wedgeX += innerWedge.frame.size.width;
  
  // Add triple ring.
  CGFloat tripleRingRadius = innerWedgeRadius + ringThickness;
  WedgeViewComponent *tripleRing = [WedgeViewComponent wedgeWithOuterRadius:tripleRingRadius radialLength:ringThickness];
  tripleRing.fillColor = [UIColor greenColor].CGColor;
  tripleRing.tag = 503;
  tripleRing.frame = CGRectMake(wedgeX, wedgeY - tripleRing.frame.size.height / 2.0, tripleRing.frame.size.width, tripleRing.frame.size.height);
  wedgeX += tripleRing.frame.size.width;
  
  // Add outer wedge.
  CGFloat outerWedgeRadius = overallWedgeRadius - ringThickness;
  WedgeViewComponent *outerWedge = [WedgeViewComponent wedgeWithOuterRadius:outerWedgeRadius radialLength:outerWedgeRadius - tripleRingRadius];
  outerWedge.tag = 504;
  outerWedge.frame = CGRectMake(wedgeX, wedgeY - outerWedge.frame.size.height / 2.0, outerWedge.frame.size.width, outerWedge.frame.size.height);
  wedgeX += outerWedge.frame.size.width;
  
  // Add double ring.
  CGFloat doubleRingRadius = overallWedgeRadius;
  WedgeViewComponent *doubleRing = [WedgeViewComponent wedgeWithOuterRadius:doubleRingRadius radialLength:ringThickness];
  doubleRing.fillColor = [UIColor greenColor].CGColor;
  doubleRing.tag = 502;
  doubleRing.frame = CGRectMake(wedgeX, wedgeY - doubleRing.frame.size.height / 2.0, doubleRing.frame.size.width, doubleRing.frame.size.height);
  
  // Add the subviews in the desired priority, e. g. double/triple rings "on top."
  [self addSubview:innerWedge];
  [self addSubview:outerWedge];
  [self addSubview:tripleRing];
  [self addSubview:doubleRing];
  
  // Set the magnification transforms differently for the double and triple rings.
  CGAffineTransform ringMagnifyTransform = CGAffineTransformMakeScale(1.5, 3.0);
  CGAffineTransform ringMagnifyBounceTransform = CGAffineTransformMakeScale(2.0, 4.0);
  doubleRing.magnifyTransform = ringMagnifyTransform;
  doubleRing.magnifyBounceTransform = ringMagnifyBounceTransform;
  tripleRing.magnifyTransform = ringMagnifyTransform;
  tripleRing.magnifyBounceTransform = ringMagnifyBounceTransform;
  
}

-(void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
  NSLog(@"touchesBegan in WedgeView\n");
  [self magnify];
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
  [self unmagnify];
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

-(void) magnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	self.transform = magnifyBounceTransform;
//  self.alpha = 0.75;
	[UIView commitAnimations];
  //self.magnified = YES;
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
  self.alpha = 1.0;
	[UIView commitAnimations];
  //self.magnified = NO;
}

-(void) hideSelectionScoreView
{
  selectionScoreView.hidden = YES;
}

- (void) moveSelectionScoreViewNear:(NSSet *) touches withEvent:(UIEvent *) event
{
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  touchPoint.y -= 25.0;
  selectionScoreView.center = touchPoint;
//  [self bringSubviewToFront:selectionScoreView];
//  selectionScoreView.hidden = NO;
}

/*
- (void)drawRect:(CGRect)rect {
  // Outline the current view.
  
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the outline.
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  CGContextStrokeRect(context, self.bounds);
  
  // Restore the context.
  CGContextRestoreGState(context);
}
*/

- (void)dealloc {
    [super dealloc];
}


@end

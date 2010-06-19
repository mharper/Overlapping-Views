//
//  WedgeView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WedgeView.h"
#import "WedgeViewComponent.h"
#import <QuartzCore/QuartzCore.h>


#define WEDGE_WIDTH 130
#define WEDGE_HEIGHT 100

@interface WedgeView()
-(WedgeViewComponent *) viewFromTouches:(NSSet *) touches withEvent:(UIEvent *)event;
-(void) magnify;
-(void) unmagnify;
- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
-(void) addWedgeSubviews;
-(void) initWedge;

@end

@implementation WedgeView

@synthesize scoreValue; 
@synthesize rotateAngle;
@synthesize selectedComponentView;
@synthesize normalTransform;
@synthesize magnifyTransform;
@synthesize magnifyBounceTransform;
@synthesize selectionScoreView;
@synthesize magnified;
@synthesize normalFrame;
@synthesize magnifiedFrame;

+(WedgeView *) wedgeWithValue:(NSInteger) scoreValue angle:(CGFloat) radians boardCenter:(CGPoint) centerPoint
{
  WedgeView *newWedge = [[[WedgeView alloc] initWithFrame:CGRectMake(centerPoint.x, centerPoint.y - (WEDGE_HEIGHT / 2.0), WEDGE_WIDTH, WEDGE_HEIGHT)] autorelease];
  newWedge.scoreValue = scoreValue;
  newWedge.rotateAngle = radians;
  
  // Move the view so the pointy part lines up again.
  CGPoint wedgeOffset = CGPointMake(WEDGE_WIDTH * (cos(newWedge.rotateAngle) - 1.0) / 2.0, WEDGE_WIDTH * sin(newWedge.rotateAngle) / 2.0);
  newWedge.center = CGPointMake(newWedge.center.x + wedgeOffset.x, newWedge.center.y + wedgeOffset.y);
  
  // Hang onto the normal frame and create a magnified frame.
  CGRect frame = newWedge.frame;
  newWedge.normalFrame = newWedge.frame;
  newWedge.magnifiedFrame = CGRectMake(frame.origin.x - 25, frame.origin.y - 25, frame.size.width + 50, frame.size.height + 50);
  newWedge.magnified = NO;
  
  return newWedge;
}


-(void) setRotateAngle:(CGFloat) angle
{
  // This rotates the view by setting a rotation transform.
  self->rotateAngle = angle;
  self.normalTransform = CGAffineTransformMakeRotation(angle);
//  self.magnifyTransform = CGAffineTransformRotate(CGAffineTransformMakeScale(2.0, 2.0), angle);
//  self.magnifyBounceTransform = CGAffineTransformRotate(CGAffineTransformMakeScale(2.5, 2.5), angle);
//  
  self.transform = normalTransform;
  
//  CGFloat rotation = [rotatingButton frameCenterRotation];
//  [rotatingButton setFrameCenterRotation:
//   rotation + 15.0f];
  
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      [self initWedge];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    [self initWedge];
	}
	return self;
}

-(void) initWedge
{
  self.selectedComponentView = nil;
  self.autoresizesSubviews = YES;
  self.autoresizingMask = UIViewAutoresizingNone;
  self.backgroundColor = [UIColor clearColor];
  
  // Add an outline of the view so I know where the fuck it is.
  self.layer.borderWidth = 2.0;
  self.layer.borderColor = [UIColor redColor].CGColor;
  
  [self addWedgeSubviews];
}

-(void) addWedgeSubviews
{  
  // Add the various subviews that comprise the entire wedge.
  CGFloat overallWedgeRadius = WEDGE_WIDTH;
  CGFloat ringThickness = 9.0;
  CGFloat wedgeX = 0.0;
  CGFloat wedgeY = self.bounds.size.height / 2.0;
  
  // 130 * 3 = 390 / 5 = 78
  // Add inner wedge.
  CGFloat innerWedgeRadius = overallWedgeRadius * 3.0 / 5.0;
  WedgeViewComponent *innerWedge = [WedgeViewComponent wedgeWithOuterRadius:innerWedgeRadius radialLength:innerWedgeRadius];
  innerWedge.tag = 501;
  innerWedge.frame = CGRectMake(wedgeX, wedgeY - innerWedge.frame.size.height / 2.0, innerWedge.frame.size.width, innerWedge.frame.size.height);
//  innerWedge.autoresizingMask -= UIViewAutoresizingFlexibleLeftMargin;
  wedgeX += innerWedge.wedgeFrame.size.width;
  
  // 78 + 9 = 87
  // Add triple ring.
  CGFloat tripleRingRadius = innerWedgeRadius + ringThickness;
  WedgeViewComponent *tripleRing = [WedgeViewComponent wedgeWithOuterRadius:tripleRingRadius radialLength:ringThickness];
  tripleRing.fillColor = [UIColor greenColor].CGColor;
  tripleRing.tag = 503;
  tripleRing.frame = CGRectMake(wedgeX, wedgeY - tripleRing.frame.size.height / 2.0, tripleRing.frame.size.width, tripleRing.frame.size.height);
//  tripleRing.autoresizingMask -= UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
  wedgeX += tripleRing.wedgeFrame.size.width;
  
  // Add outer wedge.
  CGFloat outerWedgeRadius = overallWedgeRadius - ringThickness;
  WedgeViewComponent *outerWedge = [WedgeViewComponent wedgeWithOuterRadius:outerWedgeRadius radialLength:outerWedgeRadius - tripleRingRadius];
  outerWedge.tag = 504;
  outerWedge.frame = CGRectMake(wedgeX, wedgeY - outerWedge.frame.size.height / 2.0, outerWedge.frame.size.width, outerWedge.frame.size.height);
//  outerWedge.autoresizingMask -= UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
  wedgeX += outerWedge.wedgeFrame.size.width;
  
  // Add double ring.
  CGFloat doubleRingRadius = overallWedgeRadius;
  WedgeViewComponent *doubleRing = [WedgeViewComponent wedgeWithOuterRadius:doubleRingRadius radialLength:ringThickness];
  doubleRing.fillColor = [UIColor greenColor].CGColor;
  doubleRing.tag = 502;
  doubleRing.frame = CGRectMake(wedgeX, wedgeY - doubleRing.frame.size.height / 2.0, doubleRing.frame.size.width, doubleRing.frame.size.height);
//  doubleRing.autoresizingMask -= UIViewAutoresizingFlexibleRightMargin;
  
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
  [[self superview] bringSubviewToFront:self];
  [self magnify];
  /*
  WedgeViewComponent *touchedView = [self viewFromTouches:touches withEvent:event];
  if (touchedView != nil)
  {
    if ([touchedView shouldTrackTouches:touches withEvent:event])
    {
      [touchedView trackTouches:touches withEvent:event];
    }
    self.selectedComponentView = touchedView;
  }
  */
}

-(void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
  /*
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
   */
}

-(void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
  [self unmagnify];
  /*
  if (selectedComponentView != nil)
  {
    [selectedComponentView stopTrackingTouches];
    self.selectedComponentView = nil;
  }
   */
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  /*
  if (selectedComponentView != nil)
  {
    [selectedComponentView stopTrackingTouches];
    self.selectedComponentView = nil;
  }
   */
}

-(WedgeViewComponent *) viewFromTouches:(NSSet *) touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];	
  UIView *touchedView = [self hitTest:[touch locationInView:self] withEvent:event];
  return ([touchedView isKindOfClass:[WedgeViewComponent class]] ? (WedgeViewComponent *) touchedView : nil);
}

-(void) magnify
{
  if (!self.magnified)
  {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    
    // Set bounds to 2x.
    CGRect doubleRect = CGRectInset(self.bounds, -(self.bounds.size.width / 2.0), -(self.bounds.size.height / 2.0));
    self.bounds = doubleRect;
    
    // Any kind of magnification transform makes the edges fuzzy.
  //  CATransform3D magnifyTranslate = CATransform3DMakeTranslation(0.0, 0.0, 40.0);
  //  CATransform3D scale = CATransform3DMakeScale(2.0f, 2.0f, 1.0f);
  //  [self layer].transform = CATransform3DConcat(scale, magnifyTranslate);
     
    //[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    // self.transform = magnifyBounceTransform;
  //  self.alpha = 0.75;
  //  CGPoint myCenter = self.center;
  //  CGRect newRect = CGRectInset(self.bounds, -20.0, -20.0);
  //  newRect.origin.x = newRect.origin.y = 0.0;
  //	self.bounds = newRect;
  //  self.center = myCenter;
  //  [self setNeedsDisplay];
    [UIView commitAnimations];
    self.magnified = YES;
    
    // This should automagically magnify the subviews.
    /*
    for (WedgeViewComponent* subview in self.subviews)
    {
      [subview setNeedsDisplay];
    }
    */
  }
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	//self.transform = magnifyTransform;	
	[UIView commitAnimations];
}

-(void) unmagnify
{
  if (self.magnified)
  {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    //self.transform = normalTransform;	
  //  self.alpha = 1.0;
  //  self.frame = self.normalFrame;

  //  for (WedgeViewComponent* subview in self.subviews)
  //  {
  //    [subview unmagnify];
  //  }
    /*
    CGPoint myCenter = self.center;
    CGRect newRect = CGRectInset(self.bounds, 20.0, 20.0);
    newRect.origin.x = newRect.origin.y = 0.0;
    self.bounds = newRect;
    self.center = myCenter;
    */
    
    // Set bounds to 0.5x.
    CGRect halfRect = CGRectInset(self.bounds, (self.bounds.size.width/4.0), (self.bounds.size.height/4.0));
    self.bounds = halfRect;
    
    [UIView commitAnimations];
    self.magnified = NO;
    
  }
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

- (void)drawRect:(CGRect)rect {
  /*
  // Outline the current view.
  NSLog(@"WedgeView rect is %@", NSStringFromCGRect(self.bounds));
  
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the outline.
//  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//  CGContextStrokeRect(context, self.bounds);
  
  // Restore the context.
  CGContextRestoreGState(context);
   */
}



- (void)dealloc {
    [super dealloc];
}


@end

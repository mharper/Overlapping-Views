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
@synthesize normalTransform;
@synthesize magnifyTransform;
@synthesize magnifyBounceTransform;
@synthesize innerRadius;
@synthesize outerRadius;
@synthesize radialLength;
@synthesize strokeColor;
@synthesize fillColor;

+(CGColorRef) defaultStrokeColor
{
  return [UIColor blackColor].CGColor;
}

+(CGColorRef) defaultFillColor
{
  return [UIColor yellowColor].CGColor;
}

+(WedgeViewComponent *) wedgeWithOuterRadius:(CGFloat) outerRadius radialLength:(CGFloat) radialLength
{
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;
  WedgeViewComponent *newComponent = [[[WedgeViewComponent alloc] init] autorelease];
  newComponent.innerRadius = outerRadius - radialLength;
  newComponent.outerRadius = outerRadius;
  newComponent.radialLength = radialLength;
  newComponent.strokeColor = [WedgeViewComponent defaultStrokeColor];
  newComponent.fillColor = [WedgeViewComponent defaultFillColor];
  newComponent.bounds = CGRectMake(0, 0, outerRadius - (newComponent.innerRadius * cos(WEDGE_ANGLE/ 2.0)), 2.0 * outerRadius * sin(WEDGE_ANGLE / 2.0));
  newComponent.backgroundColor = [UIColor clearColor];
  return newComponent;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      magnified = NO;
      normalTransform = self.transform;
      magnifyTransform = CGAffineTransformMakeScale(1.5, 1.5);
      magnifyBounceTransform = CGAffineTransformMakeScale(1.75, 1.75);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    magnified = NO;
    normalTransform = self.transform;
    magnifyTransform = CGAffineTransformMakeScale(1.5, 1.5);
    magnifyBounceTransform = CGAffineTransformMakeScale(1.75, 1.75);
	}
	return self;
}

-(BOOL) shouldTrackTouches:(NSSet *) touches withEvent:(UIEvent *) event
{
  // Should only track touches if the point is inside the drawing area.
  return YES;
}

-(void) trackTouches:(NSSet *) touches withEvent:(UIEvent *) event
{
  if (!magnified)
  {
    //[self.superview bringSubviewToFront:self];
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

-(BOOL) touchInDrawingArea:(NSSet *) touches withEvent:(UIEvent *)event
{
//  UITouch *touch = [touches anyObject];	
//  CGPathContainsPoint(<#CGPathRef path#>, <#const CGAffineTransform * m#>, <#CGPoint point#>, <#_Bool eoFill#>);
  return YES;
}

-(void) magnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	self.transform = magnifyBounceTransform;
  self.alpha = 0.75;
	[UIView commitAnimations];
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
  self.alpha = 1.0;
	[UIView commitAnimations];
  self.magnified = NO;
}

-(void) drawRect:(CGRect) rect {
  
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the component path.
  CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetFillColorWithColor(context, fillColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(CGPathRef) componentDrawingPath
{
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;
  CGFloat innerX = innerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = outerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = innerRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = outerRadius * sin(WEDGE_ANGLE / 2.0);
  
  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetHorizontallyAndVertically = CGAffineTransformMakeTranslation(-(innerRadius * cos(WEDGE_ANGLE / 2.0)), self.bounds.size.height / 2.0);
  
  CGPathMoveToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, outerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, outerX, outerY, outerRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, innerX, innerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, innerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, innerX, -innerY, innerRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  
  return drawingPath;
}

- (void)dealloc {
    [super dealloc];
}


@end

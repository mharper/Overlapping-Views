//
//  WedgeViewComponent.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//
#import "WedgeViewComponent.h"
#import "WedgeView.h"

@implementation WedgeViewComponent

@synthesize magnified;
@synthesize selected;
@synthesize normalTransform;
@synthesize magnifyTransform;
@synthesize magnifyBounceTransform;
@synthesize innerRadius;
@synthesize outerRadius;
@synthesize radialLength;
@synthesize strokeColor;
@synthesize fillColor;
@synthesize selectedFillColor;
@synthesize containingWedge;
@synthesize magnifiedFrame;
@synthesize unmagnifiedFrame;
@synthesize wedgeFrame;

static CGFloat WEDGE_COMPONENT_MARGIN = 1.0;
static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;

+(CGColorRef) defaultStrokeColor
{
  return [UIColor blackColor].CGColor;
}

+(CGColorRef) defaultFillColor
{
  return [UIColor yellowColor].CGColor;
}

+(CGColorRef) defaultSelectedFillColor
{
  return [UIColor cyanColor].CGColor;
}

+(WedgeViewComponent *) wedgeWithOuterRadius:(CGFloat) outerRadius radialLength:(CGFloat) radialLength
{
  CGFloat innerRadius = outerRadius - radialLength;
  // May need simply to offset the wedgeFrame by the margin for everything to work.
  CGRect wedgeDrawingRect = CGRectMake(WEDGE_COMPONENT_MARGIN, WEDGE_COMPONENT_MARGIN,
                                    outerRadius - (innerRadius * cos(WEDGE_ANGLE/ 2.0)) /* + 2.0 * WEDGE_COMPONENT_MARGIN */, 
                                    2.0 * outerRadius * sin(WEDGE_ANGLE / 2.0) /* + 2.0 * WEDGE_COMPONENT_MARGIN */);
  CGRect wedgeViewRect = CGRectInset(wedgeDrawingRect, -2 * WEDGE_COMPONENT_MARGIN, -2 * WEDGE_COMPONENT_MARGIN);
  
  WedgeViewComponent *newComponent = [[[WedgeViewComponent alloc] initWithFrame:wedgeViewRect] autorelease];
  newComponent.wedgeFrame = wedgeDrawingRect;
  newComponent.innerRadius = innerRadius;
  newComponent.outerRadius = outerRadius;
  newComponent.radialLength = radialLength;
  newComponent.strokeColor = [WedgeViewComponent defaultStrokeColor];
  newComponent.fillColor = [WedgeViewComponent defaultFillColor];
  newComponent.selectedFillColor = [WedgeViewComponent defaultSelectedFillColor];
  newComponent.backgroundColor = [UIColor clearColor];
  CGRect frame = newComponent.frame;
  newComponent.magnifiedFrame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);
  newComponent.unmagnifiedFrame = newComponent.frame;
  // This sure didn't work.
//  newComponent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  // This is at least keeping the wedge size the same.
//  newComponent.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
//                                  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
  // This looks promising.
//  newComponent.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
//                                  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
//                                  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  // Calls drawRect: whenever the bounds change.
  newComponent.contentMode = UIViewContentModeRedraw;

  return newComponent;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      magnified = NO;
      selected = NO;
      normalTransform = self.transform;
      magnifyTransform = CGAffineTransformMakeScale(1.5, 1.5);
      magnifyBounceTransform = CGAffineTransformMakeScale(2.0, 2.0);
      self.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      /*
      self.autoresizingMask =  
        UIViewAutoresizingFlexibleLeftMargin   |
        UIViewAutoresizingFlexibleWidth        |
        UIViewAutoresizingFlexibleRightMargin  |
        UIViewAutoresizingFlexibleTopMargin    |
        UIViewAutoresizingFlexibleHeight       |
        UIViewAutoresizingFlexibleBottomMargin ;
      */
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder])
  {
    magnified = NO;
    selected = NO;
    normalTransform = self.transform;
    magnifyTransform = CGAffineTransformMakeScale(1.5, 1.5);
    magnifyBounceTransform = CGAffineTransformMakeScale(2.0, 2.0);
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
  if (! selected)
  {
    selected = YES;
    [self setNeedsDisplay];
//    if (!magnified)
//    {
      //[self.superview bringSubviewToFront:self];
//      [self magnify];
//    }
  }
  [containingWedge moveSelectionScoreViewNear:touches withEvent:event];
}

-(void) stopTrackingTouches
{
  selected = NO;
  [self setNeedsDisplay];
//  if (magnified)
//  {
//    [self unmagnify];
//    [containingWedge hideSelectionScoreView];
//  }
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
  self.alpha = 0.75;
  CGPoint inset = CGPointMake(-0.5 * self.bounds.size.width, -0.5 * self.bounds.size.height);
  self.bounds = CGRectInset(self.bounds, inset.x, inset.y);
  self.center = CGPointMake(self.center.x + inset.x / 2.0, self.center.y + inset.y / 2.0);

	[UIView commitAnimations];
  self.magnified = YES;
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView commitAnimations];
}

-(void) unmagnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
  CGPoint inset = CGPointMake((1.0 / 3.0) * self.bounds.size.width, (1.0 / 3.0) * self.bounds.size.height);
  self.bounds = CGRectInset(self.bounds, inset.x, inset.y);
  self.center = CGPointMake(self.center.x + inset.x / 2.0, self.center.y + inset.y / 2.0);
  self.alpha = 1.0;
	[UIView commitAnimations];
  self.magnified = NO;
}

-(void) drawRect:(CGRect) rect
{
  
  NSLog(@"Subview frame is now %@", NSStringFromCGRect(self.frame));
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  // Draw the component path.
  CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetFillColorWithColor(context, selected ? selectedFillColor : fillColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Outline yerself.
//  CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//  CGContextSetLineWidth(context, 1.0);
//  CGContextStrokeRect(context, rect);
  
  CGContextRestoreGState(context);
  
}

-(void) drawNormal
{
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the component path.
  CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetFillColorWithColor(context, selected ? selectedFillColor : fillColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(void) drawMagnified
{
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the component path.
  CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetFillColorWithColor(context, selected ? selectedFillColor : fillColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(CGPathRef) componentDrawingPath
{
//#error YOUR DRAWNING PROBLEM IS IN HERE, MICHAEL.
  CGRect componentDrawRect = CGRectInset(self.bounds, 2.0 * WEDGE_COMPONENT_MARGIN, 2.0 * WEDGE_COMPONENT_MARGIN);
//  CGRect componentDrawRect = self.wedgeFrame;
  
  // Calculate the effective inner and outer radius based on the size of the frame.
  self.outerRadius = componentDrawRect.size.height / (2.0 * sin(WEDGE_ANGLE / 2.0));
  self.innerRadius = (outerRadius - componentDrawRect.size.width)/ cos(WEDGE_ANGLE / 2.0);
  
  CGFloat innerX = innerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = outerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = innerRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = outerRadius * sin(WEDGE_ANGLE / 2.0);
  NSLog(@"Component drawing path: Xi = %f, Yi = %f, Xo = %f, Yo = %f\n", innerX, innerY, outerX, outerY);
  
  /*
   * Original non-scaling values:
  CGFloat innerX = innerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = outerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = innerRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = outerRadius * sin(WEDGE_ANGLE / 2.0);
  */
  
  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetToCenter = CGAffineTransformMakeTranslation(-innerRadius * cos(WEDGE_ANGLE / 2.0), componentDrawRect.size.height / 2.0);
  CGAffineTransform offsetHorizontallyAndVertically = CGAffineTransformTranslate(offsetToCenter, componentDrawRect.origin.x, componentDrawRect.origin.y);
  // Need to transform again to get the origin correct for the margin.
  
  CGPathMoveToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
//  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, outerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, outerX, outerY, outerRadius);
  CGPathAddArc(drawingPath, &offsetHorizontallyAndVertically, 0.0, 0.0, outerRadius, -(WEDGE_ANGLE / 2.0), WEDGE_ANGLE / 2.0, false);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, innerX, innerY);
//  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, innerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, innerX, -innerY, innerRadius);
  CGPathAddArc(drawingPath, &offsetHorizontallyAndVertically, 0.0, 0.0, innerRadius, WEDGE_ANGLE / 2.0, -(WEDGE_ANGLE / 2.0), true);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  
  return drawingPath;
}

-(void) didMoveToSuperview
{
  self.containingWedge = (WedgeView *) [self superview];
}


- (void)dealloc {
    [super dealloc];
}


@end

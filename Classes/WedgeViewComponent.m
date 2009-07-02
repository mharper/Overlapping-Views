//
//  WedgeViewComponent.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//
//  The problem resizing the wedges is happening on the way up to "magnified" and then back down to "unmagnified."
//  Interestingly, the 11 wedge (at 9 o'clock) seems immune, ostensibly because it is parallel to the horizontal axis.
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
  CGRect wedgeViewRect = CGRectMake(0, 0,
                                    outerRadius - (innerRadius * cos(WEDGE_ANGLE/ 2.0)) + 2.0 * WEDGE_COMPONENT_MARGIN, 
                                    2.0 * outerRadius * sin(WEDGE_ANGLE / 2.0) + 2.0 * WEDGE_COMPONENT_MARGIN);
  WedgeViewComponent *newComponent = [[[WedgeViewComponent alloc] initWithFrame:wedgeViewRect] autorelease];
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
  newComponent.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

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
    if (!magnified)
    {
      //[self.superview bringSubviewToFront:self];
      [self magnify];
    }
  }
  [containingWedge moveSelectionScoreViewNear:touches withEvent:event];
}

-(void) stopTrackingTouches
{
  selected = NO;
  [self setNeedsDisplay];
  if (magnified)
  {
    [self unmagnify];
    [containingWedge hideSelectionScoreView];
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
	// self.transform = magnifyBounceTransform;
  //self.frame = magnifiedFrame;
  self.alpha = 0.75;
	[UIView commitAnimations];
  self.magnified = YES;
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	//self.transform = magnifyTransform;	
	[UIView commitAnimations];
}

-(void) unmagnify
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	// self.transform = normalTransform;
  self.frame = unmagnifiedFrame;
  self.alpha = 1.0;
	[UIView commitAnimations];
  self.magnified = NO;
}

-(void) drawRect:(CGRect) rect
{
  if (! magnified)
  {
    CGRect frame = self.frame;
    self.magnifiedFrame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);
    self.unmagnifiedFrame = frame;
    
    [self drawNormal];
  }
  
  // Just outline yerself.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  CGContextSetLineWidth(context, 5.0);
  CGContextStrokeRect(context, rect);
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
  CGFloat innerX = innerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = outerRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = innerRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = outerRadius * sin(WEDGE_ANGLE / 2.0);
  
  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetHorizontallyAndVertically = CGAffineTransformMakeTranslation(-(innerRadius * cos(WEDGE_ANGLE / 2.0) - WEDGE_COMPONENT_MARGIN), self.bounds.size.height / 2.0);
  
  CGPathMoveToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, outerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, outerX, outerY, outerRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, innerX, innerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, innerRadius / cos(WEDGE_ANGLE / 2.0), 0.0, innerX, -innerY, innerRadius);
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

//
//  DoubleRingArcView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DoubleRingArcView.h"


@implementation DoubleRingArcView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


-(void) drawRect:(CGRect) rect {
  
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the component path.
  CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
  CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(CGPathRef) componentDrawingPath
{
  CGFloat wedgeRadius = 130.0;
  CGFloat doubleRingThickness = 9.0;
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;
  CGFloat doubleRingRadius = wedgeRadius - doubleRingThickness;
  CGFloat innerX = doubleRingRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = wedgeRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = doubleRingRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = wedgeRadius * sin(WEDGE_ANGLE / 2.0);
  
  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetHorizontallyAndVertically = CGAffineTransformMakeTranslation(-110.0, 25.0);
  CGPathMoveToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, wedgeRadius / cos(WEDGE_ANGLE / 2.0), 0.0, outerX, outerY, wedgeRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, innerX, innerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, doubleRingRadius / cos(WEDGE_ANGLE / 2.0), 0.0, innerX, -innerY, doubleRingRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);

  return drawingPath;
}

- (void)dealloc {
    [super dealloc];
}


@end

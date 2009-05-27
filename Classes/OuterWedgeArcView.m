//
//  OuterWedgeArcView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OuterWedgeArcView.h"


@implementation OuterWedgeArcView


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
  CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
  CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(CGPathRef) componentDrawingPath
{
  CGFloat outsideRadius = 120.0;
  CGFloat sectionThickness = 120.0 - (130.0 * 3.0 / 5.0);
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;
  CGFloat insideRadius = outsideRadius - sectionThickness;
  CGFloat innerX = insideRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat outerX = outsideRadius * cos(WEDGE_ANGLE / 2.0);
  CGFloat innerY = insideRadius * sin(WEDGE_ANGLE / 2.0);
  CGFloat outerY = outsideRadius * sin(WEDGE_ANGLE / 2.0);
  
  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetHorizontallyAndVertically = CGAffineTransformMakeTranslation(-75.0, 25.0);
  CGPathMoveToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, outsideRadius / cos(WEDGE_ANGLE / 2.0), 0.0, outerX, outerY, outsideRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, innerX, innerY);
  CGPathAddArcToPoint(drawingPath, &offsetHorizontallyAndVertically, insideRadius / cos(WEDGE_ANGLE / 2.0), 0.0, innerX, -innerY, insideRadius);
  CGPathAddLineToPoint(drawingPath, &offsetHorizontallyAndVertically, outerX, -outerY);
  
  return drawingPath;
}


- (void)dealloc {
    [super dealloc];
}


@end

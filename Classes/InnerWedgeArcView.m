//
//  InnerWedgeArcView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InnerWedgeArcView.h"

#import <math.h>


@implementation InnerWedgeArcView


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
  CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
  CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextFillPath(context);
  CGContextAddPath(context, [self componentDrawingPath]);
  CGContextStrokePath(context);
  
  // Restore the context.
  CGContextRestoreGState(context);
}

-(CGPathRef) componentDrawingPath
{
  CGFloat wedgeRadius = 30.0;
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;

  CGMutablePathRef drawingPath = CGPathCreateMutable();
  CGAffineTransform offsetVertically = CGAffineTransformMakeTranslation(0.0, 25.0);
  CGPathMoveToPoint(drawingPath, &offsetVertically, 0.0, 0.0);
  CGPathAddLineToPoint(drawingPath, &offsetVertically, wedgeRadius * cos(WEDGE_ANGLE / 2.0), -(wedgeRadius * sin(WEDGE_ANGLE / 2.0)));
  CGPathAddArcToPoint(drawingPath, &offsetVertically, wedgeRadius / cos(WEDGE_ANGLE / 2.0), 0.0, wedgeRadius * cos(WEDGE_ANGLE / 2.0), wedgeRadius * sin(WEDGE_ANGLE / 2.0), wedgeRadius);
  CGPathAddLineToPoint(drawingPath, &offsetVertically, 0.0, 0.0);
  
  return drawingPath;
}

- (void)dealloc {
    [super dealloc];
}


@end

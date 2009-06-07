//
//  OutlineView.m
//  Overlapping Views
//
//  Created by Michael Harper on 6/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OutlineView.h"


@implementation OutlineView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
  // Outline the current view.
  
  // Save the current context.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  // Draw the outline.
  CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
  CGContextStrokeRect(context, self.bounds);
  
  // Restore the context.
  CGContextRestoreGState(context);
}


- (void)dealloc {
    [super dealloc];
}


@end

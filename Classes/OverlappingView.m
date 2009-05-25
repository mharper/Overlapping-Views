//
//  OverlappingView.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OverlappingView.h"


@implementation OverlappingView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touch began in view %d.\n", self.tag);
  if (self.superview)
    [self.superview touchesBegan:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touch ended in view %d.\n", self.tag);
  if (self.superview)
    [self.superview touchesBegan:touches withEvent:event];
}

@end

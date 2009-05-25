//
//  WedgeView.h
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WedgeViewComponent.h"

@interface WedgeView : UIView {
  NSInteger scoreValue;             // 1..20
  CGFloat rotateAngle;              // Radians
  WedgeViewComponent* selectedComponentView;
}

+(WedgeView *) wedgeWithValue:(NSInteger) scoreValue angle:(CGFloat) radians;

@property(nonatomic) NSInteger scoreValue; 
@property(nonatomic) CGFloat rotateAngle;
@property(nonatomic, retain) WedgeViewComponent* selectedComponentView;

@end

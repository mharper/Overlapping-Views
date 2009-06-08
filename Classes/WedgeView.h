//
//  WedgeView.h
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WedgeViewComponent;

@interface WedgeView : UIView {
  NSInteger scoreValue;             // 1..20
  CGFloat rotateAngle;              // Radians
  WedgeViewComponent* selectedComponentView;
  CGAffineTransform normalTransform;
  CGAffineTransform magnifyTransform;
  CGAffineTransform magnifyBounceTransform;
  IBOutlet UILabel *selectionScoreView;
}

-(void) hideSelectionScoreView;
-(void) moveSelectionScoreViewNear:(NSSet *) touches withEvent:(UIEvent *) event;

+(WedgeView *) wedgeWithValue:(NSInteger) scoreValue angle:(CGFloat) radians boardCenter:(CGPoint) centerPoint;

@property(nonatomic) NSInteger scoreValue; 
@property(nonatomic) CGFloat rotateAngle;
@property(nonatomic, retain) WedgeViewComponent* selectedComponentView;
@property(nonatomic) CGAffineTransform normalTransform;
@property(nonatomic) CGAffineTransform magnifyTransform;
@property(nonatomic) CGAffineTransform magnifyBounceTransform;
@property(nonatomic, retain) UILabel *selectionScoreView;

@end

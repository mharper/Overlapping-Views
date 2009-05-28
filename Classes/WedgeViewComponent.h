//
//  WedgeViewComponent.h
//  Overlapping Views
//
//  Created by Michael Harper on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WedgeViewComponent : UIView {
  BOOL magnified;
  CGAffineTransform normalTransform;
  CGAffineTransform magnifyTransform;
  CGAffineTransform magnifyBounceTransform;
  CGFloat innerRadius;
  CGFloat outerRadius;
  CGFloat radialLength;
  CGColorRef strokeColor;
  CGColorRef fillColor;
}

@property(nonatomic) BOOL magnified;
@property(nonatomic) CGAffineTransform normalTransform;
@property(nonatomic) CGAffineTransform magnifyTransform;
@property(nonatomic) CGAffineTransform magnifyBounceTransform;
@property(nonatomic) CGFloat innerRadius;
@property(nonatomic) CGFloat outerRadius;
@property(nonatomic) CGFloat radialLength;
@property(nonatomic) CGColorRef strokeColor;
@property(nonatomic) CGColorRef fillColor;

-(BOOL) shouldTrackTouches:(NSSet *) touches withEvent:(UIEvent *) event;
-(void) trackTouches:(NSSet *) touches withEvent:(UIEvent *) event;
-(void) stopTrackingTouches;
-(void) magnify;
-(void) unmagnify;
-(CGPathRef) componentDrawingPath;

+(WedgeViewComponent *) wedgeWithOuterRadius:(CGFloat) outerRadius radialLength:(CGFloat) radialLength;
+(CGColorRef) defaultStrokeColor;
+(CGColorRef) defaultFillColor;

@end

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
  CGRect originalViewFrame;
  CGRect magnifiedViewFrame;
  CGAffineTransform normalTransform;
  CGAffineTransform magnifyTransform;
  CGAffineTransform magnifyBounceTransform;
}

@property(nonatomic) BOOL magnified;
@property(nonatomic) CGRect originalViewFrame;
@property(nonatomic) CGRect magnifiedViewFrame;
@property(nonatomic) CGAffineTransform normalTransform;
@property(nonatomic) CGAffineTransform magnifyTransform;
@property(nonatomic) CGAffineTransform magnifyBounceTransform;

-(void) trackTouches:(NSSet *) touches withEvent:(UIEvent *) event;
-(void) stopTrackingTouches;
-(void) magnify;
-(void) unmagnify;

@end

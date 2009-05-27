//
//  WedgeViewComponentTest.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WedgeViewComponentTest.h"
#import "WedgeViewComponent.h"


@implementation WedgeViewComponentTest

#if USE_DEPENDENT_UNIT_TEST     // all "code under test" is in the iPhone Application

#else                           // all "code under test" must be linked into the Unit Test bundle

- (void) testCreateWedgeViewComponent
{
  WedgeViewComponent* wedgeComponent = [WedgeViewComponent wedgeWithOuterRadius:100.0 radialLength:40.0];
  STAssertEquals((CGFloat) 60.0, wedgeComponent.innerRadius, @"Inner radius value %f not as expected.", wedgeComponent.innerRadius);
  STAssertEquals((CGFloat) 100.0, wedgeComponent.outerRadius, @"Outer radius value %f not as expected.", wedgeComponent.outerRadius);
  STAssertEquals((CGFloat) 40.0, wedgeComponent.radialLength, @"Radial length %f not as expected.", wedgeComponent.radialLength);
  
  // Check default stroke and fill color values.
  STAssertTrue(CGColorEqualToColor([WedgeViewComponent defaultStrokeColor], wedgeComponent.strokeColor), @"Default stroke color not as expected.");
  STAssertTrue(CGColorEqualToColor([WedgeViewComponent defaultFillColor], wedgeComponent.fillColor), @"Default fill color not as expected.");

  // Assign stroke and fill color values.
}

#endif


@end

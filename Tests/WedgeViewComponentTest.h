//
//  WedgeViewComponentTest.h
//  Overlapping Views
//
//  Created by Michael Harper on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Dependent unit tests mean unit test code depends on an application to be injected into.
//  Setting this to 0 means the unit test code is designed to be linked into an independent executable.
#define USE_DEPENDENT_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
//#import "application_headers" as required


@interface WedgeViewComponentTest : SenTestCase {

}

#if USE_DEPENDENT_UNIT_TEST
#else
- (void) testCreateWedgeViewComponent;              // simple standalone test
#endif

@end

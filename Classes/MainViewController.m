//
//  MainViewController.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize wedgeView;
@synthesize rotationAngleField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  
  CGPoint myCenter = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
  self.view.transform = CGAffineTransformMakeTranslation(myCenter.x, myCenter.y);
  
  // Load the wedges.
  static CGFloat WEDGE_ANGLE = 2.0 * M_PI / 20.0;
  for (int w = 0; w < 20; w++)
  {
    WedgeView *newWedge = [WedgeView wedgeWithValue:w angle:w * WEDGE_ANGLE];
    // newWedge.frame = CGRectMake(myCenter.x, myCenter.y, newWedge.bounds.size.width, newWedge.bounds.size.height);
    [self.view addSubview:newWedge];
    NSLog(@"Added wedge %d at (%f, %f, %f, %f)\n", w, newWedge.frame.origin.x, newWedge.frame.origin.y, newWedge.frame.size.width, newWedge.frame.size.height);
  }
  
  [super viewDidLoad];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) updateWedgeAngle:(id) sender
{
  [rotationAngleField resignFirstResponder];
  wedgeView.rotateAngle = [rotationAngleField.text floatValue];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

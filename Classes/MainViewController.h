//
//  MainViewController.h
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WedgeView.h"

@interface MainViewController : UIViewController {
  IBOutlet WedgeView *wedgeView;
  IBOutlet UITextField *rotationAngleField;
}

@property(nonatomic, retain) WedgeView *wedgeView;
@property(nonatomic, retain) UITextField *rotationAngleField;

-(IBAction) updateWedgeAngle:(id) sender;

@end

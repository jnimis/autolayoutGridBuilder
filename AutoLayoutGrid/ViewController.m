//
//  ViewController.m
//  AutoLayoutGrid
//
//  Created by John Nimis on 9/12/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import "ViewController.h"

#define GRID_IMAGE @"grid_space"
#define MID_MARGIN @0
#define LEFT_MARGIN @10
#define RIGHT_MARGIN @10
#define TOP_MARGIN @10
#define BOTTOM_MARGIN @10

@interface ViewController ()

@end

@implementation ViewController

@synthesize gridView;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)buildGridOfSize:(int)gridSize inView:(UIView*)targetView
{
    targetView.translatesAutoresizingMaskIntoConstraints = NO;

    // these metrics can be edited to suit the project
    NSDictionary *metrics = @{ @"topMargin":TOP_MARGIN, @"midMargin":MID_MARGIN, @"leftMargin":LEFT_MARGIN, @"rightMargin":RIGHT_MARGIN, @"bottomMargin":BOTTOM_MARGIN };
    
    // initialize mutable variables
    NSMutableArray *tileViews = [NSMutableArray array];  // I don't use the array of tiles yet, but this could come in handy (as a returned value, e.g.)
    NSMutableString *constraintString = [[NSMutableString alloc] init];
    NSMutableDictionary *bindings = [[NSMutableDictionary alloc] init];
    
    // start vertical constraint visual language string
    constraintString = [NSMutableString stringWithString:@"V:|-(topMargin)-"];
    
    // iterate across rows
    for (int row = 1; row <= gridSize; row ++) {
        
        // start horizontal constraint string (a new one for each row)
        NSMutableString *rowConstraint = [NSMutableString stringWithString:@"H:|-(leftMargin)-"];
        
        // iterate across columns (views within each row)
        for (int i = 1; i <= gridSize; i++) {
            
            UIImageView *thisView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GRID_IMAGE]];
            thisView.translatesAutoresizingMaskIntoConstraints = NO;
            int tileID = (((row - 1) * gridSize) + i);
            NSString *viewName = [NSString stringWithFormat:@"tileView%d", tileID];
            [tileViews addObject:thisView];
            bindings[viewName] = thisView;
            
            [thisView setContentCompressionResistancePriority:499 forAxis:UILayoutConstraintAxisHorizontal];
            
            
            // make sure the ImageView is square
            [thisView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                toItem:thisView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0]];
            
            
            // add this view to the horizontal constraint string
            [rowConstraint appendFormat:@"[%@]%@", viewName, (i < gridSize) ? @"-(midMargin)-" : @""];
            
            // add this view to the superview
            [targetView addSubview:thisView];
            
            if (i == 1) {
                // add left-most tile to vertical constraint, and align it on the left of the superview
                [constraintString appendFormat:@"[%@]%@", viewName, (row < gridSize) ? @"-(midMargin)-" : @""];
                
                [targetView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:targetView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:[[metrics objectForKey:@"leftMargin"] floatValue]]];

                
            }
            
            if (i > 1) {
                // make this view's width and height equal to that of the last view
                UIImageView* lastView = bindings[[NSString stringWithFormat:@"tileView%d", (tileID - 1)]];
                
                [targetView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:lastView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0]];
                
                [targetView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:lastView
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:0.0]];
                 }

            
        }
        
        // finish the horizontal constraint string, then add it to the view
        [rowConstraint appendString:@"-(rightMargin)-|"];
        
        [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:rowConstraint
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:metrics
                                                                             views:bindings]];
        
    }
    
    // finish the vertical constraint string, then add it to the view
    [constraintString appendFormat:@"-(bottomMargin)-|"];
    
    [targetView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:metrics
                                                                        views:bindings]
     ];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buildGrid:(id)sender {
    
    // as an example, a 3x3 grid in an IB-defined grid
    [self buildGridOfSize:5 inView:gridView];
    
}
@end

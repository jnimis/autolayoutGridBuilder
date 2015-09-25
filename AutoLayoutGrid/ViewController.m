//
//  ViewController.m
//  AutoLayoutGrid
//
//  Created by John Nimis on 9/12/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import "ViewController.h"

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

    NSDictionary *metrics = @{ @"topMargin":@10, @"midMargin":@0, @"leftMargin":@10, @"rightMargin":@10, @"bottomMargin":@10 };
    
    NSMutableArray *tileViews = [NSMutableArray array];
    NSMutableString *constraintString = [[NSMutableString alloc] init];
    NSMutableDictionary *bindings = [[NSMutableDictionary alloc] init];
    
    constraintString = [NSMutableString stringWithString:@"V:|-(topMargin)-"];
    
    NSLog(@"constraint strings:");
    
    for (int row = 1; row <= gridSize; row ++) {
        
        NSMutableString *rowConstraint = [NSMutableString stringWithString:@"H:|-(leftMargin)-"];
        
        for (int i = 1; i <= gridSize; i++) {
            
            UIImageView *thisView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid_space"]];
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
            
            
            [rowConstraint appendFormat:@"[%@]%@", viewName, (i < gridSize) ? @"-(midMargin)-" : @""];
            
            [targetView addSubview:thisView];
            
            if (i == 1) {
                // add left-most tile to vertical constraint
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
                // make this view's width equal to the last view
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
        
        [rowConstraint appendString:@"-(rightMargin)-|"];
        
        [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:rowConstraint
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:metrics
                                                                             views:bindings]];
        
    }
    
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
    
    [self buildGridOfSize:3 inView:gridView];
    
}
@end

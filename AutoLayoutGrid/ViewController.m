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
    
    /*
    UIView *gridView = [[UIView alloc] init];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    gridView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:gridView];

    [gridView addConstraint:[NSLayoutConstraint constraintWithItem:gridView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                     toItem:gridView
                                                     attribute:NSLayoutAttributeWidth
                         
                                                    multiplier:1.0 constant:0.0]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[gridView]-|"
                                                                options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(gridView)]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:gridView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:80.0]];
    
*/

    
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

- (void)build3x3Grid {
    
    int gridSize = 3;
    
    // create square-ish subview in which to nest grid (called gridView)
    UIView *gridView = [[UIView alloc] init];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    gridView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:gridView];
    
    [gridView addConstraint:[NSLayoutConstraint constraintWithItem:gridView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:gridView
                                                         attribute:NSLayoutAttributeWidth
                             
                                                        multiplier:1.0 constant:0.0]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[gridView]-|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(gridView)]];

    // this works
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:gridView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:80.0]];

    // define useful variables
    NSDictionary *metrics = @{ @"topMargin":@10, @"midMargin":@0, @"leftMargin":@10, @"rightMargin":@10, @"bottomMargin":@10 };
//    NSMutableArray *tileViews = [NSMutableArray array];
    NSMutableString *constraintString = [[NSMutableString alloc] init];
    NSMutableDictionary *bindings = [[NSMutableDictionary alloc] init];
    
    // start vertical constraint string
    constraintString = [NSMutableString stringWithString:@"V:|-(topMargin)-"];
    
    NSLog(@"constraint strings:");
    int tileID = 1;
    
    for (int row = 1; row <= gridSize; row ++) {
        // create row subview, loop through
        
        for (int i = 1; i <= gridSize; i++) {
            
            UIImageView *thisView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid_space"]];
            thisView.translatesAutoresizingMaskIntoConstraints = NO;
            NSString *viewName = [NSString stringWithFormat:@"tileView%d", tileID++];
//            [tileViews addObject:thisView];
            //            NSLog(@"view named %@",viewName);
            bindings[viewName] = thisView;
            [gridView addSubview:thisView];
            
            [thisView setContentCompressionResistancePriority:499 forAxis:UILayoutConstraintAxisHorizontal];
            [thisView setContentCompressionResistancePriority:499 forAxis:UILayoutConstraintAxisVertical];
            
            // add the first view of each column to the verical constraint
            if (i == 1) {
                [constraintString appendFormat:@"[%@]",viewName];
                
                // align first column with left of gridView
                [gridView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:gridView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:[[metrics objectForKey:@"leftMargin"] floatValue]]];

                
            }
            
            // make sure the ImageView is square
            [thisView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:thisView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0]];
            
            
            if (i > 1) {
                // make this view's width and height equal to the last view
                UIImageView* lastView = bindings[[NSString stringWithFormat:@"tileView%d", (tileID - 2)]];
                [gridView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:lastView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0]];
                
                [gridView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:lastView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1.0
                                                                     constant:0.0]];
                
                [gridView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:lastView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0.0]];
                
                [gridView addConstraint:[NSLayoutConstraint constraintWithItem:thisView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:lastView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:[[metrics objectForKey:@"midMargin"] floatValue]]];

            }
            
        }
        
    }
    
    [constraintString appendFormat:@"-|"];
    
    [gridView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:metrics
                                                                        views:bindings]
     ];
    
    NSLog(@"%@",constraintString);
    
    //    for(NSString *key in [bindings allKeys]) {
    //        NSLog(@"%@",[bindings objectForKey:key]);
    //    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buildGrid:(id)sender {
    
//    UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid_space"]];
//    [gridView addSubview:test];

    [self buildGridOfSize:3 inView:gridView];
    
}
@end

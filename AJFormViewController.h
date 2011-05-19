// Created by Alexander Johansson on 2011-05-18.
// Should be sub-classed.

#import <UIKit/UIKit.h>


@interface AJFormViewController : UIViewController {
    
    UITextField *currentField;
    
    CGSize _kbSize;
    BOOL _kbVisible;
}

// Must be overriden
-(void) validateAndReturn;


#pragma mark - setControlstates
-(void)setControlState: (NSArray*) array enabled:(BOOL) enabled setOpacity:(CGFloat) opacity;
-(void)disableControls: (NSArray*) array setOpacity: (CGFloat) opacity;
-(void)disableControls: (NSArray*) array;
-(void)enableControls: (NSArray*) array setOpacity: (CGFloat)opacity;
-(void)enableControls: (NSArray*) array;



#pragma mark - Adjust scroll to keyboard
@property (nonatomic, retain) IBOutlet UIScrollView *scroll;
@end

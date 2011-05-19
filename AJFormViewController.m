// Created by Alexander Johansson on 2011-05-18.
// Should be sub-classed.

#import "AJFormViewController.h"
@interface AJFormViewController() 
-(void) registerForKeyboardNotifications;

@end

@implementation AJFormViewController
@synthesize scroll=_scroll;

- (void)dealloc
{
    [currentField release], currentField = nil;
    self.scroll=nil;
    
    [super dealloc];
}
- (void) viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
}
#pragma mark - Good form magic


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Find the control that has the next consecutive tag number 
    UIView *nextResponder = [self.view viewWithTag:textField.tag + 1];
    
    if ([nextResponder respondsToSelector:@selector(becomeFirstResponder)]) {
        // If we found one, and it's capable of becoming first responder, 
        // tell it to become first responder.
        [nextResponder performSelector:@selector(becomeFirstResponder)];
    }
    else {
        // Otherwise we're done, resign first responder
        [textField resignFirstResponder];
        
        [self validateAndReturn];
    }
    return NO;
}
-(void)validateAndReturn {
    
    ALog(@"Subclasses of %@ has to invoke %@ method", NSStringFromClass([self class]) , NSStringFromSelector(@selector(validateAndReturn)));
}

#pragma mark - setControlstates
-(void)setControlState: (NSArray*) array enabled:(BOOL) enabled setOpacity:(CGFloat) opacity {
    
    for (UIControl *control in array) {
        control.enabled = enabled;
        control.alpha   = opacity;
    }
}

-(void)disableControls: (NSArray*) array setOpacity: (CGFloat) opacity {
    [self setControlState:array enabled:NO setOpacity:opacity];
}

-(void)disableControls: (NSArray*) array {
    [self disableControls:array setOpacity:0.7f];
}



-(void)enableControls: (NSArray*) array setOpacity: (CGFloat) opacity {
    [self setControlState:array enabled:YES setOpacity:opacity];
}

-(void)enableControls: (NSArray*) array {
    [self enableControls:array setOpacity:1.0f];
}

#pragma mark - Prevent keyboard from blocking view


-(void)adjustScrollView {
    if (!_kbVisible) {
        return;
    }
    // ...and offset the scrollview by it's height
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, _kbSize.height, 0.0);
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
    
    // Get the rectangle of the scroll view
    CGRect aRect = self.scroll.bounds;
    // ...and subtract the height of the keyboard.
    aRect.size.height -= _kbSize.height;
    
    
    if (!CGRectContainsRect(aRect, currentField.frame)) {
        
        CGPoint scrollPoint = CGPointMake(0.0, currentField.frame.origin.y);
        [self.scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Save the current field that's being edited
    [currentField release];
    currentField = [textField retain];
    [self adjustScrollView];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // Unset the current field if we stopped editing
    if (currentField == textField) {
        [currentField release];
        currentField = nil;
    }
    return YES;
}
- (void)registerForKeyboardNotifications
{
    // Register as an observer for keyboard events.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Get the size of the keyboard
    NSDictionary* info = [aNotification userInfo];
    _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _kbVisible = YES;
    [self adjustScrollView];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _kbVisible = NO;
    // Remove the scroll view offsets.
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
}

@end

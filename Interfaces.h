//
//  Interfaces.h
//  RealButtons
//
//  Created by Tanner Bennett on 2021-03-10
//  Copyright © 2021 Tanner Bennett. All rights reserved.
//

#pragma mark Imports

#import <UIKit/UIKit.h>
#import <flex.h>

#pragma mark Interfaces

@interface _UIButtonBarButtonVisualProviderIOS : NSObject
@property (readonly) UIColor *tintColor;
@property (readonly) UIImageView *backgroundImageView;
@property (readonly) UIView *contentView;

- (void)_prepareBackgroundViewFromBarButtonItem:(id)item isBackButton:(BOOL)backButton;
@end

@interface _UIButtonBarButton : UIView
@property (readonly) _UIButtonBarButtonVisualProviderIOS *visualProvider;
@end

@interface _UIModernBarButton : UIButton
- (UIColor *)_imageColorForState:(UIControlState)state;
@end


#pragma mark Macros



#define Alert(TITLE,MSG) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show];

#define UIAlertController(title, msg) [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:1]
#define UIAlertControllerAddAction(alert, title, stl, code...) [alert addAction:[UIAlertAction actionWithTitle:title style:stl handler:^(id action) code]];
#define UIAlertControllerAddCancel(alert) [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]
#define ShowAlertController(alert, from) [from presentViewController:alert animated:YES completion:nil];

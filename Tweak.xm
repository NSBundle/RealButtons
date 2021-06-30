//
//  Tweak.xm
//  RealButtons
//
//  Created by Tanner Bennett on 2021-03-10
//  Copyright © 2021 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"

#define kCornerRadius 6
// #define kCornerRadius 5.75

static UIImage * UIBackButtonImageOfColorWithSize(UIColor *color, CGSize size) {
    NSCParameterAssert(size.width >= 13 && size.height >= 13);
    UIImage *image = nil;

    const CGFloat kNoseWidthAsPercentageOfHeight = 0.52;
    CGFloat noseWidth = size.height * kNoseWidthAsPercentageOfHeight;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0); {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        // Start at top left, go down to bottom right, to to nose, go back to top left //
        
        // Initial rounded rectangle; clear the front edge where the nose will go
        UIBezierPath *rectangle = [UIBezierPath bezierPath];
        // UIBezierPath *baseRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kCornerRadius]
        // CGContextClearRect(c, CGRectMake(0, 0, noseWidth, size.height));
        
        // Top left
        [rectangle moveToPoint:CGPointMake(noseWidth, 0)];
        // Bottom left
        [rectangle addLineToPoint:CGPointMake(noseWidth, size.height)];
        [rectangle addCurveToPoint:CGPointMake(14.85, 34.51) controlPoint1:CGPointMake(17.35, size.height) controlPoint2:CGPointMake(15.94, 35.47)];
        // Nose
        [rectangle addCurveToPoint:CGPointMake(0, size.height / 2) controlPoint1:CGPointMake(4.95, 25.8) controlPoint2:CGPointMake(0, 20.3)];
        // Top left again
        [rectangle addCurveToPoint:CGPointMake(14.85, 1.49) controlPoint1:CGPointMake(0, 15.7) controlPoint2:CGPointMake(4.95, 10.2)];
        [rectangle addCurveToPoint:CGPointMake(noseWidth, 0) controlPoint1:CGPointMake(15.94, 0.53) controlPoint2:CGPointMake(17.35, 0)];
        
        [rectangle appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(noseWidth, 0, rect.size.width, rect.size.height) cornerRadius:kCornerRadius]];
        [rectangle addClip];
        
        CGContextSetFillColorWithColor(c, color.CGColor);
        CGContextFillRect(c, rect);

        image = UIGraphicsGetImageFromCurrentImageContext();
    } UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(12, noseWidth, 12, 12)];
}

static UIImage * UIImageOfColorWithSize(UIColor *color, CGSize size) {
    NSCParameterAssert(size.width >= 13 && size.height >= 13);
    UIImage *image = nil;

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0); {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kCornerRadius] addClip];

        CGContextSetFillColorWithColor(c, color.CGColor);
        CGContextFillRect(c, rect);

        image = UIGraphicsGetImageFromCurrentImageContext();
    } UIGraphicsEndImageContext();

    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
}

UIImage * RBButtonShapeImageForState(UIButton *button, UIControlState state, BOOL backButton) {
    UIColor *color = [button titleColorForState:state];
    CGSize s = [button intrinsicContentSize];
    if (button.titleLabel.text) {
        s.width += 23;
        s.height += 12;
    } else {
        s.width += 12;
        s.height += 12;
    }
    
    s.height = 35;
    // s.width = 44;
    s.width = MAX(s.width, 44);
    
    CGFloat opacity = 0.16;
    if (state == UIControlStateHighlighted) {
        opacity *= 0.4;
    }
    
    if (backButton) {
        return UIBackButtonImageOfColorWithSize([color colorWithAlphaComponent:opacity], s);
    } else {
        return UIImageOfColorWithSize([color colorWithAlphaComponent:opacity], s);
    }
}

%hook _UIButtonBarButtonVisualProviderIOS
- (id)backgroundImageForState:(UIControlState)state compact:(BOOL)compact {
    if (![self.contentView intrinsicContentSize].height) return nil;
    
    _UIModernBarButton *button = (id)self.contentView;
    
    // Weirdly necessary workarounds for strange behaviors
    state = button.enabled ? state : UIControlStateDisabled;
    if (self.tintColor) button.tintColor = self.tintColor;
    
    return RBButtonShapeImageForState(button, state, NO);
}

- (id)__backButtonBackgroundImageForState:(UIControlState)state compact:(BOOL)compact {
    if (![self.contentView intrinsicContentSize].height) return nil;
    
    _UIModernBarButton *button = (id)self.contentView;
    
    // Weirdly necessary workarounds for strange behaviors
    state = button.enabled ? state : UIControlStateDisabled;
    button.tintColor = self.tintColor;
    
    return RBButtonShapeImageForState(button, state, YES);
}
%end

// %hook UIButton
// - (UIImage *)backgroundImageForState:(UIControlState)state {
//     id image = %orig;
//     if (image) return image;
    
//     return RBButtonShapeImageForState(self, state);
// }
// %end

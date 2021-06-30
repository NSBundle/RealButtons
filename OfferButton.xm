//
//  OfferButton.xm
//  RealButtons
//  
//  Created by Tanner Bennett on 2021-03-10
//  Copyright © 2021 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"

@interface OfferButton : UIButton
@property (readonly) CAShapeLayer *outlineShape;
@end

%group StoreButtons
%hook OfferButton
- (void)layoutSubviews {
    %orig;
    
    CAShapeLayer *shape = self.outlineShape;
    shape.strokeColor = nil;
    shape.fillColor = [self.tintColor colorWithAlphaComponent:0.16].CGColor;
}
%end
%end

%ctor {
    Class buttonCls = %c(TestFlight.OfferButton); //?: %c(AppStore.OfferButton);
    
    if (buttonCls) {
        %init(StoreButtons, OfferButton=buttonCls);
    }
}

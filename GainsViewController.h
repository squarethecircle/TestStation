//
//  GainsViewController.h
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Gain : NSObject
    @property(strong,nonatomic) NSString* name;
    @property(strong,nonatomic) NSArray* value;
    @property(strong,nonatomic) NSString* code;
@end

@interface GainsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView* myView;
}
@end

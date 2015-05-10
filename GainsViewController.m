//
//  GainsViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "GainsViewController.h"
#import "GainSetViewController.h"

@implementation Gain

- (Gain*)initGain: (NSString*)givenName value: (NSArray*)preset transmit:(NSString*)givenCode
{
    self.name = givenName;
    self.value = preset;
    self.code = givenCode;
    return self;
}

@end
@interface GainsViewController ()
@property (strong,nonatomic) NSArray* tableData;
@end

@implementation GainsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect reducedSize = self.view.bounds;
    myView = [[UITableView alloc] initWithFrame:reducedSize];
    myView.dataSource = self;
    myView.delegate = self;
    Gain* rollkp = [[Gain alloc] initGain:@"ROLLKP" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)2],[NSNumber numberWithInteger:(NSInteger)0], nil] transmit:@"RKP"];
    Gain* rollkd = [[Gain alloc] initGain:@"ROLLKD" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)5], nil] transmit:@"RKD"];
    Gain* yawkpail = [[Gain alloc] initGain:@"YAWKPAIL" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)2],[NSNumber numberWithInteger:(NSInteger)5], nil] transmit:@"YKP"];
    Gain* yawkdail = [[Gain alloc] initGain:@"YAWKDAIL" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)1],[NSNumber numberWithInteger:(NSInteger)0], nil] transmit:@"YKD"];
    Gain* pitchgain = [[Gain alloc] initGain:@"PITCHGAIN" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)1],[NSNumber numberWithInteger:(NSInteger)5], nil] transmit:@"PKP"];
    Gain* pitchkd = [[Gain alloc] initGain:@"PITCHKD" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)5], nil] transmit:@"PKD"];
    Gain* rollelevmix = [[Gain alloc] initGain:@"ROLLELEVMIX" value:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)0],[NSNumber numberWithInteger:(NSInteger)1],[NSNumber numberWithInteger:(NSInteger)5], nil] transmit:@"REM"];
    self.tableData = [NSArray arrayWithObjects:rollkp,rollkd,yawkpail,yawkdail,pitchgain,pitchkd,rollelevmix, nil];

    [self.view addSubview:myView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Gain* desiredGain = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = desiredGain.name;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GainSetViewController* setGainsView = [[GainSetViewController alloc] init];
    Gain* desiredGain = self.tableData[indexPath.row];
    setGainsView.title = desiredGain.name;
    setGainsView.currentVal = desiredGain.value;
    setGainsView.code = desiredGain.code;
    [[self navigationController] pushViewController:setGainsView animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

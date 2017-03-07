//
//  PBBeCentralViewController.m
//  SmartLock
//
//  Created by A1bert on 2017/3/7.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import "PBBeCentralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PBBeCentralViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *discoverPeripherals;

@end

@implementation PBBeCentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _discoverPeripherals = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            [central scanForPeripheralsWithServices:nil options:nil];
        }
            break;

        case CBManagerStatePoweredOff:
            NSLog(@">>>>>>>CBManagerStatePoweredOff");
            break;

        case CBManagerStateResetting:
            NSLog(@">>>>>>>CBManagerStateResetting");
            break;

        case CBManagerStateUnsupported:
            NSLog(@">>>>>>>CBManagerStateUnsupported");
            break;

        case CBManagerStateUnknown:
            NSLog(@">>>>>>>CBManagerStateUnknown");
            break;

        case CBManagerStateUnauthorized:
            NSLog(@">>>>>>>CBManagerStateUnauthorized");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@", peripheral.name);
    if ([peripheral.name hasPrefix:@"SDTT"]) {
        [_discoverPeripherals addObject:peripheral];
        [central connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@">>> connect to peripheral name is %@", peripheral.name);
    [central stopScan];
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@">>> disconnect to peripheral name is %@, error is %@", peripheral.name, error.localizedDescription);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@">>> connect to peripheral failed name is %@, error is %@", peripheral.name, error.localizedDescription);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"%@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }

    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
        [peripheral readValueForCharacteristic:characteristic];
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",descriptor.UUID);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
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

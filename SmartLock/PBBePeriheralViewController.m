//
//  PBBePeriheralViewController.m
//  SmartLock
//
//  Created by A1bert on 2017/3/7.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import "PBBePeriheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *const ServiceUUID1 =  @"FFF0";
static NSString *const notiyCharacteristicUUID =  @"FFF1";
static NSString *const readwriteCharacteristicUUID =  @"FFF2";
static NSString *const ServiceUUID2 =  @"FFE0";
static NSString *const readCharacteristicUUID =  @"FFE1";
static NSString *const LocalNameKey =  @"myPeripheral";

@interface PBBePeriheralViewController ()<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (assign, nonatomic) NSInteger serviceNumber;

@end

@implementation PBBePeriheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_peripheralManager stopAdvertising];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBManagerStatePoweredOn: {
            NSLog(@"Powered On");
            [self setUp];
        }
            break;
        case CBManagerStatePoweredOff: {
            NSLog(@"Powered Off");
        }
            break;
        default:
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (!error) {
        _serviceNumber++;
    }

    if (_serviceNumber == 2) {
        [_peripheralManager startAdvertising:@{
                                               CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:ServiceUUID1], [CBUUID UUIDWithString:ServiceUUID2]],
                                               CBAdvertisementDataLocalNameKey : LocalNameKey
                                               }];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheral Manager Did Start Advertising");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {

}

- (void)setUp {
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    CBMutableCharacteristic *notiyCharacteristic =
    [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:notiyCharacteristicUUID]
                                       properties:CBCharacteristicPropertyNotify
                                            value:nil
                                      permissions:CBAttributePermissionsReadable];
    CBMutableCharacteristic *readwriteCharacteristic =
    [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:readwriteCharacteristicUUID]
                                       properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite
                                            value:nil
                                      permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    CBMutableDescriptor *readwriteCharacteristicDescription1 =
    [[CBMutableDescriptor alloc] initWithType:CBUUIDCharacteristicUserDescriptionStringUUID
                                        value:@"name"];
    [readwriteCharacteristic setDescriptors:@[readwriteCharacteristicDescription1]];
    CBMutableCharacteristic *readCharacteristic =
    [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:readCharacteristicUUID]
                                       properties:CBCharacteristicPropertyRead
                                            value:nil
                                      permissions:CBAttributePermissionsReadable];

    CBMutableService *service1 = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:ServiceUUID1] primary:YES];
    NSLog(@"%@", service1.UUID);
    [service1 setCharacteristics:@[notiyCharacteristic, readwriteCharacteristic]];

    CBMutableService *service2 = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:ServiceUUID2] primary:YES];
    NSLog(@"%@", service2.UUID);
    [service2 setCharacteristics:@[readCharacteristic]];

    [_peripheralManager addService:service1];
    [_peripheralManager addService:service2];
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

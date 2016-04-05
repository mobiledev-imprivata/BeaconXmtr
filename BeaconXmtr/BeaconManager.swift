//
//  BeaconManager.swift
//  BeaconXmtr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BeaconManager: NSObject {
    
    private let proximityUUID = NSUUID(UUIDString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    private let major: CLBeaconMajorValue = 123
    private let minor: CLBeaconMinorValue = 456
    private let identifier = NSBundle.mainBundle().bundleIdentifier!

    private var beaconRegion: CLBeaconRegion!
    private var peripheralManager: CBPeripheralManager!
    
    func startBeacon() {
        print("startBeacon")
        guard beaconRegion == nil && peripheralManager == nil else {
            print("already running")
            return
        }
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    func stopBeacon() {
        print("stopBeacon")
        guard beaconRegion != nil && peripheralManager != nil else {
            print("already stopped")
            return
        }
        peripheralManager.stopAdvertising()
        beaconRegion = nil
        peripheralManager = nil
    }

}

extension BeaconManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        if peripheral.state == .PoweredOn {
            print("PoweredOn")
            let beaconPeripheralData = (beaconRegion.peripheralDataWithMeasuredPower(nil) as NSDictionary) as! [String:AnyObject]
            peripheralManager.startAdvertising(beaconPeripheralData)
        } else if peripheral.state == .PoweredOff {
            print("PoweredOff")
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        var message = "peripheralManagerDidStartAdvertising "
        if error == nil {
            message += "ok"
        } else {
            message += "error " + error!.localizedDescription
        }
        print(message)
    }
}

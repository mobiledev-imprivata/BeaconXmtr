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
    
    fileprivate let proximityUUID = UUID(uuidString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    fileprivate let major: CLBeaconMajorValue = 123
    fileprivate let minor: CLBeaconMinorValue = 456
    fileprivate let identifier = "com.imprivata.beaconxmtr"

    fileprivate var beaconRegion: CLBeaconRegion!
    fileprivate var peripheralManager: CBPeripheralManager!
    
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
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        if peripheral.state == .poweredOn {
            print("PoweredOn")
            let beaconPeripheralData = (beaconRegion.peripheralData(withMeasuredPower: nil) as NSDictionary) as! [String:AnyObject]
            peripheralManager.startAdvertising(beaconPeripheralData)
        } else if peripheral.state == .poweredOff {
            print("PoweredOff")
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        var message = "peripheralManagerDidStartAdvertising "
        if error == nil {
            message += "ok"
        } else {
            message += "error " + error!.localizedDescription
        }
        print(message)
    }
}

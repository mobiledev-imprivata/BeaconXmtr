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
    
//    private let proximityUUID = UUID(uuidString: "CE993BE7-C940-45EB-8748-A4E60621CFBA")!
//    private let identifier = "com.imprivata.imprivataid.shotgunbeacon"
    
//    private let proximityUUID = UUID(uuidString: "785FB9F3-C262-4576-BA79-BEBAD30BB278")!
//    private let identifier = "com.imprivata.imprivataid.laserbeacon"
    
    private let proximityUUID = UUID(uuidString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    private let identifier = "com.imprivata.beaconxmtr"

    
    private let major: CLBeaconMajorValue = 123
    private let minor: CLBeaconMinorValue = 456

    private var beaconRegion: CLBeaconRegion!
    private var peripheralManager: CBPeripheralManager!
    
    private var isPoweredOn = false
    
    override init() {
        super.init()
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func startBeacon() {
        print("startBeacon")
        guard isPoweredOn else {
            print("not powered on")
            return
        }
        guard !peripheralManager.isAdvertising else {
            print("already running")
            return
        }
        let beaconPeripheralData = (beaconRegion.peripheralData(withMeasuredPower: nil) as NSDictionary) as! [String:AnyObject]
        peripheralManager.startAdvertising(beaconPeripheralData)
    }

    func stopBeacon() {
        print("stopBeacon")
        guard peripheralManager.isAdvertising else {
            print("already stopped")
            return
        }
        peripheralManager.stopAdvertising()
    }

}

extension BeaconManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        if peripheral.state == .poweredOn {
            print("poweredOn")
        } else if peripheral.state == .poweredOff {
            print("poweredOff")
            peripheralManager.stopAdvertising()
        }
        isPoweredOn = peripheral.state == .poweredOn
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

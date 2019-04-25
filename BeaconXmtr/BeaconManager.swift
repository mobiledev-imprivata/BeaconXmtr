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
    
    private let proximityUUID = UUID(uuidString: "2CAA4EDD-B1FD-411F-A02B-07393EAA6083")!
    private let identifier = "com.imprivata.beaconxmtr"
    
    private var peripheralManager: CBPeripheralManager!

    private var isPoweredOn = false
    
    override init() {
        super.init()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func startBeacon(_ major: Int) {
        log("startBeacon \(major)")
        guard isPoweredOn else {
            log("not powered on")
            return
        }
        guard !peripheralManager.isAdvertising else {
            log("already running")
            return
        }
        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: CLBeaconMajorValue(major), identifier: identifier)
        let peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }

    func stopBeacon() {
        log("stopBeacon")
        guard peripheralManager.isAdvertising else {
            log("already stopped")
            return
        }
        peripheralManager.stopAdvertising()
    }

}

extension BeaconManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        log("peripheralManagerDidUpdateState")
        if peripheral.state == .poweredOn {
            log("poweredOn")
        } else if peripheral.state == .poweredOff {
            log("poweredOff")
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
        log(message)
    }
}

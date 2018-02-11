//
//  ViewController.swift
//  BeaconXmtr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var beaconSwitch: UISwitch!
    
    let beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beaconSwitch.isOn = false
        
        startBeaconCycle()
        // switchBeacon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchChanged(_ sender: AnyObject) {
        let beaconSwitch = sender as! UISwitch
        let msg = "beacon turned " + (beaconSwitch.isOn ? "on" : "off")
        print(msg)
        switchBeacon()
    }

    private func startBeaconCycle() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            DispatchQueue.main.async {
                self.beaconSwitch.isOn = true
            }
            self.beaconManager.startBeacon()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                DispatchQueue.main.async {
                    self.beaconSwitch.isOn = false
                }
                self.beaconManager.stopBeacon()
            }
        }
    }

    private func switchBeacon() {
        if beaconSwitch.isOn {
            beaconManager.startBeacon()
        } else {
            beaconManager.stopBeacon()
        }
    }

}


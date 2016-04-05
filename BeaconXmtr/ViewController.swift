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
        
        beaconSwitch.on = true
        switchBeacon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchChanged(sender: AnyObject) {
        let beaconSwitch = sender as! UISwitch
        let msg = "beacon turned " + (beaconSwitch.on ? "on" : "off")
        print(msg)
        switchBeacon()
    }
    
    private func switchBeacon() {
        if beaconSwitch.on {
            beaconManager.startBeacon()
        } else {
            beaconManager.stopBeacon()
        }
    }

}


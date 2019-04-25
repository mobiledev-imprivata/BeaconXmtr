//
//  ViewController.swift
//  BeaconXmtr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var beaconStackView: UIStackView!

    let beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func beaconClicked(_ sender: UIButton) {
        let major = sender.tag
        flashBeacon(major)
    }
    
    private func flashBeacon(_ major: Int) {
        log("flashBeacon \(major) on")
        for subview in beaconStackView.subviews {
            if let button = subview as? UIButton {
                button.isEnabled = false
            }
        }
        beaconManager.startBeacon(major)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            log("flashBeacon \(major) off")
            self.beaconManager.stopBeacon()
            for subview in self.beaconStackView.subviews {
                if let button = subview as? UIButton {
                    button.isEnabled = true
                }
            }
        }
    }

}


//
//  Logger.swift
//  BeaconXmtr
//
//  Created by Jay Tucker on 5/9/18.
//  Copyright © 2018 Imprivata. All rights reserved.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let dt = DateFormatter()
    dt.dateFormat = "HH:mm:ss.SSS"
    return dt
}()

func log(_ message: String) {
    let timestamp = dateFormatter.string(from: Date())
    print("[\(timestamp)] \(message)")
}

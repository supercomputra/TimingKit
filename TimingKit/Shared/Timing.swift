//
//  Timing.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation


struct Timing {
    let date: Date
    let type: TimingType
    
    var timeDescription: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
    }
}

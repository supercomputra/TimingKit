//
//  DayTimings.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation


struct TimingsResult {
    let fajr: Timing
    let dhuhr: Timing
    let asr: Timing
    let maghrib: Timing
    let isha: Timing
    
    func timing(for type: TimingType) -> Timing {
        switch type {
        case .fajr:
            return fajr
        case .dhuhr:
            return dhuhr
        case .asr:
            return asr
        case .maghrib:
            return maghrib
        case .isha:
            return isha
        }
    }
}

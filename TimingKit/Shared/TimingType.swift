//
//  TimingType.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation


enum TimingType: Int, CaseIterable, CustomStringConvertible {
    case fajr
    case dhuhr
    case asr
    case maghrib
    case isha
    
    var description: String {
        switch self {
        case .fajr:
            return "Fajr"
        case .dhuhr:
            return "Dhuhr"
        case .asr:
            return "Asr"
        case .maghrib:
            return "Maghrib"
        case .isha:
            return "Isha"
        }
    }
}

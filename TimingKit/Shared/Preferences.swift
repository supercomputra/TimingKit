//
//  Preferences.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation



public struct Preferences {
    
    public static let shared: Preferences = Preferences()
    
    private let userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.supercomputra.timingkit")!
    
    private init() {}
    
    private func value<T>(forKey key: Key) -> T {
        guard let value: T = valueIfPresent(forKey: key) else {
            fatalError("Couldn't find value for key \"\(key)\" with type \"\(T.self)\"")
        }
        
        return value
    }
    
    private func valueIfPresent<T>(forKey key: Key) -> T? {
        userDefaults.value(forKey: key.rawValue) as? T
    }
    
    private func setValue(_ value: Any?, forKey key: Preferences.Key) {
        userDefaults.setValue(value, forKey: key.rawValue)
        NotificationCenter.default.post(name: .didUpdatePreferences, object: nil)
    }
    
    var corrections: [TimingType: Int] {
        var corrections: [TimingType: Int] = [:]
        for type in TimingType.allCases {
            corrections[type] = correction(for: type)
        }
        return corrections
    }
    
    func correction(for timingType: TimingType) -> Int {
        switch timingType {
        case .fajr:
            let correction: Int = valueIfPresent(forKey: .fajrCorrection) ?? 0
            return correction
        case .dhuhr:
            let correction: Int = valueIfPresent(forKey: .dhuhrCorrection) ?? 0
            return correction
        case .asr:
            let correction: Int = valueIfPresent(forKey: .asrCorrection) ?? 0
            return correction
        case .maghrib:
            let correction: Int = valueIfPresent(forKey: .maghribCorrection) ?? 0
            return correction
        case .isha:
            let correction: Int = valueIfPresent(forKey: .ishaCorrection) ?? 0
            return correction
        }
    }
    
    func setCorrection(_ correction: Int, for timingType: TimingType) {
        switch timingType {
        case .fajr:
            setValue(correction, forKey: .fajrCorrection)
        case .dhuhr:
            setValue(correction, forKey: .dhuhrCorrection)
        case .asr:
            setValue(correction, forKey: .asrCorrection)
        case .maghrib:
            setValue(correction, forKey: .maghribCorrection)
        case .isha:
            setValue(correction, forKey: .ishaCorrection)
        }
    }
}


extension Preferences {
    private enum Key: String {
        case fajrCorrection
        case dhuhrCorrection
        case asrCorrection
        case maghribCorrection
        case ishaCorrection
    }
}

extension Notification.Name {
    public static let didUpdatePreferences: NSNotification.Name = Notification.Name("didUpdatePreferences")
}

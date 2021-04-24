//
//  Timings.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation


class Timings {

    /**
     * Corrections information that wil affects the timing calculation results
     */
    var corrections: [TimingType: Int] {
        Preferences.shared.corrections
    }
    
    /**
     * Corrections information that wil affects the timing calculation results
     */
    var coordinate: Coordinate = Coordinate(0.0, 0.0)
    
    /**
     * Get timings with given date
     *
     * - Parameter date: specific date indicating the day of result
     * - Returns the timing result for the day of the given date
     */
    func timings(for date: Date) -> TimingsResult {
        // Create dummy calculations
        // Each timing will be scheduled with seconds of interval
        let interval: TimeInterval = 60.0
        
        // Create fajr starting timing
        var fajrStartingTime: Date = Date().addingTimeInterval(interval)
        if let fajrCorrection: Int = corrections[.fajr] {
            fajrStartingTime.addTimeInterval(TimeInterval(fajrCorrection * 60))
        }
        
        // Create dhuhr starting timing by adding fajrStartingTime with interval
        var dhuhrStartingTime: Date = fajrStartingTime.addingTimeInterval(interval)
        if let dhuhrCorrection: Int = corrections[.dhuhr] {
            dhuhrStartingTime.addTimeInterval(TimeInterval(dhuhrCorrection * 60))
        }
        
        // Create dhuhr starting timing by adding fajrStartingTime with interval
        var asrStartingTime: Date = dhuhrStartingTime.addingTimeInterval(interval)
        if let asrCorrection: Int = corrections[.asr] {
            asrStartingTime.addTimeInterval(TimeInterval(asrCorrection * 60))
        }
        
        // Create dhuhr starting timing by adding fajrStartingTime with interval
        var maghribStartingTime: Date = asrStartingTime.addingTimeInterval(interval)
        if let maghribCorrection: Int = corrections[.maghrib] {
            maghribStartingTime.addTimeInterval(TimeInterval(maghribCorrection * 60))
        }
        
        // Create isha starting timing by adding maghribStartingTime with interval
        var ishaStartingTime: Date = maghribStartingTime.addingTimeInterval(interval)
        if let ishaCorrection: Int = corrections[.isha] {
            ishaStartingTime.addTimeInterval(TimeInterval(ishaCorrection * 60))
        }
        
        // Create results as day timings
        let timings: TimingsResult = TimingsResult(
            fajr: Timing(date: fajrStartingTime, type: .fajr),
            dhuhr: Timing(date: dhuhrStartingTime, type: .dhuhr),
            asr: Timing(date: asrStartingTime, type: .asr),
            maghrib: Timing(date: maghribStartingTime, type: .maghrib),
            isha: Timing(date: ishaStartingTime, type: .isha)
        )
        
        return timings
    }
    
    /**
     * Returns active timings during the given date
     * This method will returns yesterday isha if time hasn't reached fajr in the same day
     */
    func activeTiming(at date: Date) -> Timing {
        let todayTimings: TimingsResult = timings(for: date)
        
        if todayTimings.isha.date.timeIntervalSince(date) <= 0 {
            return todayTimings.isha
        } else if todayTimings.maghrib.date.timeIntervalSince(date) <= 0 {
            return todayTimings.isha
        } else if todayTimings.asr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.isha
        } else if todayTimings.dhuhr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.isha
        } else if todayTimings.fajr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.fajr
        }
        
        // Returns yesterday isha if no match found
        let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let yesterdayTimings: TimingsResult = timings(for: yesterday)
        return yesterdayTimings.isha
    }
    
    /**
     * Returns upcoming timings during the given date
     * This method will returns tomorrow fajr if time has passed isha in the same day
     */
    func upcomingTiming(at date: Date) -> Timing {
        let todayTimings: TimingsResult = timings(for: date)
        
        if todayTimings.maghrib.date.timeIntervalSince(date) <= 0 {
            return todayTimings.isha
        } else if todayTimings.asr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.maghrib
        } else if todayTimings.dhuhr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.asr
        } else if todayTimings.fajr.date.timeIntervalSince(date) <= 0 {
            return todayTimings.dhuhr
        }
        
        // Returns tomorrow fajr if no match found
        let tomorrow: Date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let tomorrowTimings: TimingsResult = timings(for: tomorrow)
        return tomorrowTimings.fajr
    }
}


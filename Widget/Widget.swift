//
//  Widget.swift
//  Widget
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimingEntry {
        let timings: Timings = Timings()
        let next: Timing = timings.upcomingTiming(at: Date())
        let current: Timing = timings.activeTiming(at: Date())
        return TimingEntry(current: current, next: next)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimingEntry) -> ()) {
        let timings: Timings = Timings()
        let next: Timing = timings.upcomingTiming(at: Date())
        let current: Timing = timings.activeTiming(at: Date())
        completion(TimingEntry(current: current, next: next))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let entries: [TimingEntry] = Provider.entries()
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    static func entry() -> TimingEntry {
        let timings: Timings = Timings()
        let next: Timing = timings.upcomingTiming(at: Date())
        let current: Timing = timings.activeTiming(at: Date())
        return TimingEntry(current: current, next: next)
    }
    
    private static func entries(for date: Date = Date()) -> [TimingEntry] {
        let timings: Timings = Timings()
        var entries: [TimingEntry] = []
        
        for _ in 0...5 {
            // Get current timing date and timing name
            let previousEntry: TimingEntry? = entries.last
            let currrent: Timing = previousEntry?.next ?? timings.activeTiming(at: Date())
            
            // Get next timing
            let next: Timing = timings.upcomingTiming(at: currrent.date)
            
            // Create entry
            let entry: TimingEntry = TimingEntry(current: currrent, next: next)
            
            // Append to entries
            entries.append(entry)
        }
        
        return entries
    }
}

struct TimingEntry: TimelineEntry {
    var date: Date {
        return current.date
    }
    
    let current: Timing
    let next: Timing
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 2.0, content: {
            Text(entry.next.type.description)
                .font(.body)
            Text(entry.next.date, style: .time)
                .font(.title)
            Text("In \(entry.next.date, style: .timer)")
                .font(.caption)
        })
        .padding()
        
    }
}

@main
struct TimingWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: Provider.entry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

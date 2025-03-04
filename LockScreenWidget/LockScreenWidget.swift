import WidgetKit
import SwiftUI

//Code for a dynamically updating widget using a timeline
//This code needs to be updated as widget remains static
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
//Code needs to be updated to reflect static widget
struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LockScreenWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        //UI for each widget
        switch widgetFamily {
        case .accessoryCircular:
            VStack{
                Image(systemName: "newspaper.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

        case .accessoryRectangular:
            HStack{
                Image(systemName: "camera.fill")
                    .font(.system(size:30))
                Text("Scan\nReceipt")
                    .font(.system(size:17))
            }

        default:
            Text("Not implemented")

        }
    }
}

struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }

        //Adding Widget Families
        .supportedFamilies([.accessoryCircular,.accessoryRectangular])

        //Text when placing the widget on lockscreen
        .configurationDisplayName("Project Alpha Widgets")
        .description("Quickly scan your receipts by\nplacing a widget on your lockscreen")
    }
}

struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        //Placed 2 preview windows to view single and double space lockscreen widget
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")

        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}

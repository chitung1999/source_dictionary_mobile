import SwiftUI
import WidgetKit

struct VocabularyWord: Decodable, Equatable {
    let word: String
    let phonetic: String
    let definition: String
    let detail: String?
}

struct VocabularyEntry: TimelineEntry {
    let date: Date
    let vocabulary: VocabularyWord?
}

struct Provider: TimelineProvider {
    private let appGroup = "group.com.example.englishapp"
    private let interval: TimeInterval = 5 * 60
    private let entryCount = 12

    func placeholder(in context: Context) -> VocabularyEntry {
        VocabularyEntry(date: .now, vocabulary: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (VocabularyEntry) -> Void) {
        completion(VocabularyEntry(date: .now, vocabulary: loadWords().randomElement()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabularyEntry>) -> Void) {
        let now = Date()
        let words = loadWords()
        guard !words.isEmpty else {
            let entry = VocabularyEntry(date: now, vocabulary: nil)
            completion(Timeline(entries: [entry], policy: .after(now.addingTimeInterval(3600))))
            return
        }

        var shuffledWords = words.shuffled()
        var previous: VocabularyWord?
        let entries = (0..<entryCount).map { index in
            if shuffledWords.isEmpty {
                shuffledWords = words.shuffled()
                if shuffledWords.last == previous,
                   let differentIndex = shuffledWords.firstIndex(where: { $0 != previous }) {
                    shuffledWords.swapAt(differentIndex, shuffledWords.count - 1)
                }
            }
            let word = shuffledWords.removeLast()
            previous = word
            return VocabularyEntry(
                date: now.addingTimeInterval(Double(index) * interval),
                vocabulary: word
            )
        }
        let nextTimeline = now.addingTimeInterval(Double(entryCount) * interval)
        completion(Timeline(entries: entries, policy: .after(nextTimeline)))
    }

    private func loadWords() -> [VocabularyWord] {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroup
        ),
        let data = try? Data(contentsOf: container.appendingPathComponent("vocabulary_words.json"))
        else { return [] }

        return (try? JSONDecoder().decode([VocabularyWord].self, from: data)) ?? []
    }
}

struct VocabularyWidgetEntryView: View {
    let entry: VocabularyEntry

    @Environment(\.widgetFamily) private var family

    var body: some View {
        if let word = entry.vocabulary {
            wordView(word)
        } else if family == .accessoryCircular {
            Image(systemName: "book.fill")
                .font(.headline)
                .accessibilityLabel("Mở Dictionary để tải từ vựng")
        } else {
            Text("Mở Dictionary để tải từ vựng")
                .font(.subheadline.weight(.semibold))
        }
    }

    @ViewBuilder
    private func wordView(_ word: VocabularyWord) -> some View {
        switch family {
        case .accessoryInline:
            Text("\(word.word) · \(word.definition)")
                .fontWeight(.bold)

        case .accessoryCircular:
            VStack(spacing: 2) {
                Image(systemName: "book.fill")
                    .font(.system(size: 14, weight: .bold))
                Text(word.word)
                    .font(.system(size: 13, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
            }

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(word.word)
                        .font(.system(size: 17, weight: .heavy))
                        .layoutPriority(1)
                    Text(word.phonetic)
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(word.definition)
                    .font(.system(size: 14, weight: .bold))
                if let detail = word.detail, !detail.isEmpty {
                    Text(detail.split(whereSeparator: \.isNewline).joined(separator: " "))
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)

        default:
            Text(word.word)
        }
    }
}

struct VocabularyWidget: Widget {
    let kind = "VocabularyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VocabularyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "englishapp://vocabulary"))
        }
        .configurationDisplayName("Vocabulary")
        .description("Learn English vocabulary every day.")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    VocabularyWidget()
} timeline: {
    VocabularyEntry(
        date: .now,
        vocabulary: VocabularyWord(
            word: "Beautiful",
            phonetic: "/ˈbjuː.tɪ.fəl/",
            definition: "Xinh đẹp",
            detail: "A beautiful garden."
        )
    )
}

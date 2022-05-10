import Cocoa
import SwiftSparql

struct IdolColor: Codable {
    var label: String
    var color: String
    var brand: String?
}

// TODO: use SwiftSparql with support for async/await instead of this extension
extension Request {
    func fetch<T: Decodable>() async throws -> [T] {
        try await withUnsafeThrowingContinuation {
            fetch().onComplete(callback: $0.resume)
        }
    }
}

// guard #available(macOS 10.11, *) else { exit(1) } // does not work with Xcode 12.5
let query = Query(select: SelectQuery(where: WhereClause(
    patterns:
        subject(Var("s")).rdfTypeIsImasIdol()
        .rdfsLabel(is: Var("label"))
        .imasColor(is: Var("color"))
        .optional {$0.imasNameKana(is: Var("kana"))}
        .optional {$0.imasBrand(is: Var("brand"))}
        .triples
), order: [.by(Var("brand")), .by(Var("kana")), .by(Var("label"))]))


Task {
    let idols: [IdolColor] = try await Request(endpoint: URL(string: "https://sparql.crssnky.xyz/spql/imas/query")!, query: query).fetch()

    let list = NSColorList(name: "im@sparql")

    idols.forEach { idol in
        guard idol.color.count == 6, let hex = Int32(idol.color, radix: 16) else { return }
        let name = [idol.brand.map {"[\($0)]"}, idol.label]
            .compactMap {$0}.joined(separator: " ")
        print("setting \(idol.color) for \(name)")
        list.setColor(
            NSColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                    green: CGFloat((hex >> 8) & 0xFF) / 255,
                    blue: CGFloat((hex >> 0) & 0xFF) / 255,
                    alpha: 1),
            forKey: NSColor.Name(name))
    }
    // from the doc: Specify nil to save to the user's private colorlists directory
    try! list.write(to: nil)
    print("generated color list `\(list.name!)` with \(list.allKeys.count) colors")
    exit(0)
}

RunLoop.main.run()

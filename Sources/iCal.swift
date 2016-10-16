import Foundation

open class iCal {

    open static func loadFile(_ path: String) throws -> [Calendar] {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { throw iCalError.fileNotFound }
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { throw iCalError.encoding }

        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    open static func loadString(_ string: String) -> [Calendar] {
        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    open static func loadURL(_ url: URL) throws -> [Calendar] {
        guard let data = try? Data(contentsOf: url) else { throw iCalError.fileNotFound }
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { throw iCalError.encoding }

        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    fileprivate static func parse(_ icsContent: [String]) -> [Calendar] {
        let parser = Parser(icsContent)
        do {
            return try parser.read()
        } catch let error {
            print(error)
            return []
        }
    }

    // Convenience and Util functions

    open static func dateFromString(_ string: String) -> Date? {
        return iCal.dateFormatter.date(from: string)
    }

    open static func stringFromDate(_ date: Date) -> String {
        return iCal.dateFormatter.string(from: date)
    }

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter
    }()
}

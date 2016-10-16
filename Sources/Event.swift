import Foundation

public struct Event {
    public var subComponents = [CalendarComponent]()
    public var otherAttrs = [String:String]()

    // required
    public var uid: String
    public var dateStamp: Date!

    // optional
    // public var organizer: Organizer? = nil
    public var location: String?
    public var summary: String?
    public var eventDescription: String?
    // public var class: some enum type?
    public var startDate: Date?
    public var endDate: Date?

    public init(uid: String = UUID().uuidString, dateStamp: Date = Date()) {
        self.uid = uid
        self.dateStamp = dateStamp
    }
    
    public enum Status: String {
        case confirmed = "CONFIRMED"
        case tentative = "TENTATIVE"
        case cancelled = "CANCELLED"
    }
    public var status: Status?
    
}

extension Event: CalendarComponent {
    public mutating func addAttribute(_ attr: String, _ value: String) {
        switch attr {
        case "UID":
            uid = value
        case "DTSTAMP":
            dateStamp = iCal.dateFromString(value)
        case "DTSTART":
            startDate = iCal.dateFromString(value)
        case "DTEND":
            endDate = iCal.dateFromString(value)
        // case "ORGANIZER":
        //     organizer
        case "SUMMARY":
            summary = value
        case "DESCRIPTION":
            eventDescription = value
        case "LOCATION":
            location = value
        case "STATUS":
            status = Status(rawValue: value)
        default:
            otherAttrs[attr] = value
        }
    }

    public func toCal() -> String {
        var str = "BEGIN:VEVENT\n"

        str += "UID:\(uid)\n"

        if let dtstamp = dateStamp {
            str += "DTSTAMP:\(iCal.stringFromDate(dtstamp))\n"
        }

        if let summary = summary {
            str += "SUMMARY:\(summary)\n"
        }

        if let descr = eventDescription {
            str += "DESCRIPTION:\(descr)\n"
        }

        if let dtstart = startDate {
            str += "DTSTART:\(iCal.stringFromDate(dtstart))\n"
        }

        if let dtend = endDate {
            str += "DTEND:\(iCal.stringFromDate(dtend))\n"
        }
        
        if let loc = location {
            str += "LOCATION:\(loc)"
        }
        
        if let status = status {
            str += "STATUS: \(status.rawValue)"
        }

        for (key, val) in otherAttrs {
            str += "\(key):\(val)\n"
        }

        for component in subComponents {
            str += "\(component.toCal())\n"
        }

        str += "END:VEVENT"
        return str
    }
}

extension Event: Equatable {}

public func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.uid == rhs.uid
}

extension Event: CustomStringConvertible {
    public var description: String {
        return "\(iCal.stringFromDate(dateStamp)): \(summary ?? "")"
    }
}

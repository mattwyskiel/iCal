public struct Calendar {
    public var subComponents = [CalendarComponent]()
    public var otherAttrs = [String:String]()

    public init(withComponents components: [CalendarComponent]? = nil) {
        if let components = components {
            self.subComponents = components
        }
    }
}

extension Calendar: ICSElement {
    public mutating func addAttribute(_ attr: String, _ value: String) {
        switch attr {
        default:
            otherAttrs[attr] = value
        }
    }

    public func toCal() -> String {
        var str = "BEGIN:VCALENDAR\n"

        for (key, val) in otherAttrs {
            str += "\(key):\(val)\n"
        }

        for component in subComponents {
            str += "\(component.toCal())\n"
        }

        str += "END:VCALENDAR"
        return str
    }
}

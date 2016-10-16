public protocol IcsElement {
    var subComponents: [CalendarComponent] { get set }
    var otherAttrs: [String:String] { get set }

    mutating func addAttribute(_ attr: String, _ value: String)
    mutating func append(_ component: CalendarComponent?)

    func toCal() -> String
}

extension IcsElement {
    public mutating func append(_ component: CalendarComponent?) {
        if let component = component {
            subComponents.append(component)
        }
    }
}

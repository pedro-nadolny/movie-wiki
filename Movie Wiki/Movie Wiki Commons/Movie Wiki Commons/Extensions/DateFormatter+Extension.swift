import Foundation

extension DateFormatter {
    public static var yyyyMMdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }
}

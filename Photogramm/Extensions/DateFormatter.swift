//
//  DateFormatter.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import Foundation

extension DateFormatter {
    
    enum Formats: String {
        case shortDateShortYearFormat = "dd.MM.yy"
        case shortDateLongYearFormat = "dd.MM.yyyy"
        case hourAndMinutesFormat = "HH:mm"
        case shortDateShortYearFormatWithHourAndMinutes = "dd.MM.yyyy HH:mm"
        case shortMonthFormat = "dd MMM yyyy"
    }
    
    func daysBetweenDate(fromDate: Date, toDate: Date?) -> Int? {
        guard
            let toDate = toDate,
            let days = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day else {
            return nil
        }
        return days
    }
    
    func getFormattedDate(date: Date?, format: Formats) -> String? {
        guard let date = date else {
            return nil
        }
        let dateformat = DateFormatter()
        dateformat.locale = Locale(identifier: "ru")
        dateformat.dateFormat = format.rawValue
        return dateformat.string(from: date)
    }
}

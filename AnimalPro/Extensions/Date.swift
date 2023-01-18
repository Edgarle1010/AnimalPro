//
//  Date.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 17/01/23.
//

import Foundation

extension DateFormatter {
    static var formate: DateFormatter {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.dateStyle = .long
        return dateFormatter
    }
}

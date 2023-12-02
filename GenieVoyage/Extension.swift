//
//  Extension.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 25.11.2023.
//

import Foundation
import UIKit

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

extension UIView {
    static func loadNib<T>(withOwner: Any? = nil) -> T
        where T: UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        guard let view = nib.instantiate(withOwner: withOwner, options: nil).first as? T else {
            fatalError("Could not load view")
        }
        return view
    }
}

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    var formatted: String {
        return Date.formatter.string(from: self)
    }
}

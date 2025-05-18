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
    func formattedDateWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "E dd/MM"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        return dateFormater.string(from: self)
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func toString(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIButton {
    func darkGrayButtonStyle() {
        self.backgroundColor = .darkGray
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel?.textColor = .white
        self.titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.layer.cornerRadius = 8
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func bigBlackButtonStyle(text: String) {
        self.backgroundColor = .black
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.titleLabel?.textAlignment = .center
        self.setTitle(text, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func handlePressDown() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func handlePressUp() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    var itineraryCategory: ItineraryItemCategory {
        switch self.tag {
        case 0: return .transport
        case 1: return .transfer
        case 2: return .hotel
        case 3: return .point
        case 4: return .food
        default: return .point
        }
    }
}

extension UIImage {
    func resizedImage(named name: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
    
extension DestinationCategory {
    func icon() -> UIImage? {
        switch self {
        case .food: return UIImage(systemName: "fork.knife")
        case .attraction: return UIImage(systemName: "star")
        case .hotel: return UIImage(systemName: "bed.double")
        case .transport: return UIImage(systemName: "car")
        case .shopping: return UIImage(systemName: "bag")
        }
    }
}

extension UITextField {
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color
            ]
        )
    }
}

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        guard hexSanitized.count == 6 else {
            self.init(white: 0.5, alpha: 1.0) 
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}




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
    
    func formattedDay() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM"
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
    
    func getStartMinutes(time: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let date = formatter.date(from: time) else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else { return nil }
        
        let startMinutes = hour * 60 + minute
        return startMinutes
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
    
    func mapsButton(image: String) {
        self.setImage(UIImage(systemName: image), for: .normal)
        self.backgroundColor = .gray
        self.tintColor = .white
        self.alpha = 0.7
        self.layer.cornerRadius = 28
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
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
    
    var itineraryCategory: EventCategory {
        switch self.tag {
        case 0: return .transport
        case 1: return .transfer
        case 2: return .hotel
        case 3: return .point
        case 4: return .food
        default: return .point
        }
    }
    
    func fileButton(systemName: String) {
        self.backgroundColor = .white
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: systemName, withConfiguration: configuration)
        self.setImage(image, for: .normal)
        self.tintColor = .black
        self.clipsToBounds = true
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
    
    static func resizedSystemImage(named name: String, scale: CGFloat) -> UIImage? {
        guard let image = UIImage(systemName: name) else { return nil }
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage?.withRenderingMode(.alwaysTemplate)
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

extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

extension UIViewController {
    func presentDeletionConfirmation(title: String = "Delete event?",
                                     message: String = "This action cannot be undone.",
                                     confirmTitle: String = "Delete",
                                     cancelTitle: String = "Cancel",
                                     onConfirm: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive) { _ in
            onConfirm()
        })
        
        self.present(alert, animated: true)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


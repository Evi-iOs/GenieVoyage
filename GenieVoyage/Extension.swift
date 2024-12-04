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

extension UIButton {
    
        func applyPaperStyle(withText text: String, textureImageName: String? = nil) {
            self.setTitle(text, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            self.setTitleColor(.black, for: .normal)
            
            self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            self.layer.cornerRadius = 10
            

            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 4
            
            if let textureImageName = textureImageName, let textureImage = UIImage(named: textureImageName) {
                self.layer.contents = textureImage.cgImage
                self.layer.contentsGravity = .resizeAspectFill
            }
            
            self.addTarget(self, action: #selector(handlePressDown), for: .touchDown)
            self.addTarget(self, action: #selector(handlePressUp), for: [.touchUpInside, .touchDragExit])
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
    }

}

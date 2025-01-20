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
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
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
        self.heightAnchor.constraint(equalToConstant: 52).isActive = true
        self.titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
        
    func applyPaperStyle(withText text: String, textureImageName: String? = nil) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.setTitleColor(.gray, for: .normal)
        
        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        if let textureImageName = textureImageName, let textureImage = UIImage(named: textureImageName) {
            self.layer.contents = textureImage.cgImage
            self.layer.contentsGravity = .resizeAspectFill
        }
        
        self.addTarget(self, action: #selector(handlePressDown), for: .touchDown)
        self.addTarget(self, action: #selector(handlePressUp), for: [.touchUpInside, .touchDragExit])
    }
    
    func applyPaperStyleWithGloss(withText text: String, textureImageName: String? = nil){
        self.applyPaperStyle(withText: text, textureImageName: textureImageName)
        addGlossEffect()
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
    
    private func addGlossEffect() {
        let glossLayer = CAGradientLayer()
        glossLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width,
            height: self.bounds.height * 0.4
        )
        glossLayer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        glossLayer.cornerRadius = self.layer.cornerRadius
        glossLayer.masksToBounds = true
        
        self.layer.addSublayer(glossLayer)
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



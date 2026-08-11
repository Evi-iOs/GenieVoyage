//
//  TimelineCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.07.2026.
//

import UIKit

final class TimelineCell: UIView {
    
    init(iconSystemName: String, iconTintColor: UIColor = .black, time: String, title: String, subtitle: String, isLast: Bool) {
        super.init(frame: .zero)
        build(iconSystemName: iconSystemName, iconTintColor: iconTintColor, time: time, title: title, subtitle: subtitle, isLast: isLast)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func build(iconSystemName: String, iconTintColor: UIColor, time: String, title: String, subtitle: String, isLast: Bool) {
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor.white
        iconBg.layer.cornerRadius = 16
        iconBg.layer.borderWidth = 1
        iconBg.layer.borderColor = UIColor(hex: "E2E8F0").cgColor
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: iconSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        iv.tintColor = iconTintColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iv)
        NSLayoutConstraint.activate([iv.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
                                     iv.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
                                     iv.widthAnchor.constraint(equalToConstant: 16),
                                     iv.heightAnchor.constraint(equalToConstant: 16)])
        
        let line = UIView()
        line.backgroundColor = UIColor(hex: "E2E8F0")
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        let left = UIView()
        left.translatesAutoresizingMaskIntoConstraints = false
        left.widthAnchor.constraint(equalToConstant: 32).isActive = true
        left.addSubview(iconBg)
        left.addSubview(line)
        
        NSLayoutConstraint.activate([
            iconBg.topAnchor.constraint(equalTo: left.topAnchor, constant: 18),
            iconBg.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            line.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 6),
            line.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            line.bottomAnchor.constraint(equalTo: left.bottomAnchor)
        ])
        
        func lbl(_ txt: String, font: UIFont, color: UIColor, lines: Int = 1) -> UILabel {
            let l = UILabel(); l.text = txt; l.font = font; l.textColor = color; l.numberOfLines = lines
            return l
        }
        
        let timeLbl  = lbl(time, font: UIFont.systemFont(ofSize: 15, weight: .bold), color: UIColor(hex: "64748B"))
        let titleLbl = lbl(title, font: UIFont.systemFont(ofSize: 18, weight: .semibold), color: UIColor(hex: "0F172A"))
        let descLbl  = lbl(subtitle, font: UIFont.systemFont(ofSize: 16), color: UIColor(hex: "64748B"), lines: 0)
        
        let right = UIStackView(arrangedSubviews: [timeLbl, titleLbl, descLbl])
        right.axis = .vertical; right.spacing = 4
        right.translatesAutoresizingMaskIntoConstraints = false
        
        let row = UIStackView(arrangedSubviews: [left, right])
        row.axis = .horizontal; row.spacing = 12; row.alignment = .top
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor),
            row.leadingAnchor.constraint(equalTo: leadingAnchor),
            row.trailingAnchor.constraint(equalTo: trailingAnchor),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isLast ? -8 : -24),
            left.heightAnchor.constraint(greaterThanOrEqualTo: row.heightAnchor)
        ])
    }
}


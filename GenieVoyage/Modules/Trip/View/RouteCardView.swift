//
//  RouteCardView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 08.07.2026.
//

import UIKit

final class RouteCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "F1F5F9")
        layer.cornerRadius = 16
        layer.borderWidth = 1; layer.borderColor = UIColor(hex: "E2E8F0").cgColor

        let mapIV = UIImageView(image: UIImage(systemName: "map",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)))
        mapIV.tintColor = UIColor(hex: "0F172A")
        mapIV.setContentHuggingPriority(.required, for: .horizontal)

        let title = UILabel(); title.text = "Route Overview"
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        title.textColor = UIColor(hex: "0F172A")

        let leftStack = UIStackView(arrangedSubviews: [mapIV, title])
        leftStack.spacing = 6; leftStack.alignment = .center

        let expand = UILabel()
        expand.attributedText = NSAttributedString(string: "EXPAND MAP", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(hex: "64748B"), .kern: 1.0])

        let header = UIStackView(arrangedSubviews: [leftStack, expand])
        header.distribution = .equalSpacing; header.alignment = .center
        header.translatesAutoresizingMaskIntoConstraints = false

        let map = MapPlaceholderView()
        map.layer.cornerRadius = 10; map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false

        addSubview(header); addSubview(map)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            map.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            map.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            map.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            map.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}



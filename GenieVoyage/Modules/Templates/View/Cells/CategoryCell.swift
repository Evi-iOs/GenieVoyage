//
//  CategoryCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.03.2026.
//

import UIKit

final class CategoryCell: UICollectionViewCell {

    static let reuseID = "CategoryCell"

    private let iconBg = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconBg.layer.cornerRadius = 18
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconBg)
        iconBg.addSubview(iconView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconBg.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconBg.widthAnchor.constraint(equalToConstant: 56),
            iconBg.heightAnchor.constraint(equalToConstant: 56),
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 25),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(icon: String, title: String, isSelected: Bool) {
        let dark = AppTheme.Colors.primaryDarkBlue
        iconBg.backgroundColor = isSelected ? dark : AppTheme.Colors.backgroundGray
        let cfg = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        iconView.image = UIImage(systemName: icon, withConfiguration: cfg)
        iconView.tintColor = isSelected ? .white : AppTheme.Colors.primaryDarkBlue
        titleLabel.text = title
        titleLabel.textColor = isSelected ? dark : AppTheme.Colors.textGray
    }
}

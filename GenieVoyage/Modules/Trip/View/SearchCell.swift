//
//  SearchCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 18.03.2026.
//

import UIKit

final class SearchCell: UICollectionViewCell {

    private let containerView = UIView()
    private let iconView = UIImageView()
    private let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureUI() {

        contentView.addSubview(containerView)

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 16

        iconView.image = UIImage(systemName: "magnifyingglass")
        iconView.tintColor = .secondaryLabel

        textField.placeholder = "Search destinations..."
        textField.borderStyle = .none

        containerView.addSubview(iconView)
        containerView.addSubview(textField)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

//
//  MyTripCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 26.07.2025.
//

import UIKit

final class MyTripCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with trip: TripModel) {
        titleLabel.text = trip.title
        dateLabel.text = trip.startDate.formattedDate()
    }

    private func setup() {
        contentView.backgroundColor = AppTheme.Colors.backgroundGray
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 17)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}


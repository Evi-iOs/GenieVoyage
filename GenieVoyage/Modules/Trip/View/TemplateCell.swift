//
//  TemplateCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 26.07.2025.
//

import UIKit

final class TemplateCell: UICollectionViewCell {

    private let cardView = UIView()
    private let imageView = UIImageView()

    private let gradientLayer = CAGradientLayer()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let heartButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    private func configureUI() {
        contentView.addSubview(cardView)

        cardView.layer.cornerRadius = 20
        cardView.backgroundColor = .systemBackground

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20

        cardView.addSubview(imageView)

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.5, 1.0]

        imageView.layer.addSublayer(gradientLayer)

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        imageView.addSubview(textStack)

        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .black
        heartButton.backgroundColor = .white
        heartButton.layer.cornerRadius = 18

        cardView.addSubview(heartButton)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            textStack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),

            heartButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            heartButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            heartButton.widthAnchor.constraint(equalToConstant: 36),
            heartButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(with template: TripTemplate) {

        imageView.image = UIImage(named: template.imageName)

        titleLabel.text = template.title
        subtitleLabel.text = template.subtitle
    }
}

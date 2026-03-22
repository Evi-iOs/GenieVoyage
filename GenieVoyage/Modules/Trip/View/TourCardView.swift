//
//  TourCardView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 19.03.2026.
//

import UIKit

class TourCardView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .white
        b.layer.cornerRadius = 18
        b.tintColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 19, weight: .semibold)
        l.textColor = .label
        return l
    }()
    
    private let locationLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.textColor = .systemGray
        return l
    }()
    
    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .black
        return l
    }()
    
    private let starIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star"))
        iv.tintColor = UIColor(red: 1, green: 0.75, blue: 0.1, alpha: 1)
        iv.widthAnchor.constraint(equalToConstant: 17).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 17).isActive = true
        return iv
    }()
    
    private let fromLabel: UILabel = {
        let l = UILabel()
        l.text = "NUMBER OF DAYS"
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .systemGray
        l.letterSpacing(1)
        return l
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .label
        return l
    }()

    private let pinIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        iv.tintColor = AppTheme.Colors.primaryDarkBlue
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return iv
    }()

    init(tour: TourItem) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        // Image gradient overlay
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.2).cgColor]
        gradient.cornerRadius = 16

        imageView.backgroundColor = generatePlaceholderColor(for: tour.id)
        addLabel(to: imageView, text: tour.title)

        favoriteButton.setImage(
            UIImage(systemName: tour.isFavorite ? "heart.fill" : "heart",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)),
            for: .normal)

        titleLabel.text = tour.title
        locationLabel.text = tour.location
        ratingLabel.text = "\(tour.rating)"
        priceLabel.text = tour.price

        // Layout
        addSubview(imageView)
        imageView.addSubview(favoriteButton)
        let locationStack = UIStackView(arrangedSubviews: [pinIcon, locationLabel])
        locationStack.spacing = 4
        locationStack.alignment = .center
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, locationStack])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        let ratingStack = UIStackView(arrangedSubviews: [starIcon, ratingLabel])
        ratingStack.spacing = 3
        ratingStack.alignment = .center
        let topRow = UIStackView(arrangedSubviews: [titleStack, ratingStack])
        topRow.distribution = .equalSpacing
        topRow.alignment = .top
        let bottomRow = UIStackView(arrangedSubviews: [fromLabel, priceLabel])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 2
        let infoStack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        infoStack.axis = .vertical
        infoStack.spacing = 12
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoStack)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 256),

            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36),

            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }

    private func generatePlaceholderColor(for id: Int) -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.4, green: 0.7, blue: 0.85, alpha: 1),
            UIColor(red: 0.5, green: 0.55, blue: 0.65, alpha: 1),
            UIColor(red: 0.35, green: 0.55, blue: 0.7, alpha: 1)
        ]
        return colors[(id - 1) % colors.count]
    }

    private func addLabel(to view: UIView, text: String) {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .white.withAlphaComponent(0.8)
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(l)
        NSLayoutConstraint.activate([
            l.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            l.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            l.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            l.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}








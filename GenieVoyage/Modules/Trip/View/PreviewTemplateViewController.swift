//
//  PreviewTemplateViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 11.02.2026.
//

import UIKit

final class PreviewTemplateViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()

    private let infoStack = UIStackView()

    private let aboutTitleLabel = UILabel()
    private let aboutTextLabel = UILabel()

    private let stagesTitleLabel = UILabel()
    private let stagesCollection: UICollectionView

    private let detailsTitleLabel = UILabel()
    private let detailsStack = UIStackView()
    
    private let template: TripTemplate

    init(template: TripTemplate) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 160, height: 150)

        stagesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.template = template
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        configureContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: template.imageName)

        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)

        imageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(imageView)

        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        imageView.addSubview(titleLabel)

        infoStack.axis = .vertical
        infoStack.spacing = 24
        contentView.addSubview(infoStack)

        aboutTitleLabel.text = "About the trip"
        aboutTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        aboutTextLabel.font = .systemFont(ofSize: 16)
        aboutTextLabel.textColor = .secondaryLabel
        aboutTextLabel.numberOfLines = 0

        stagesTitleLabel.text = "Stages of the journey"
        stagesTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        stagesCollection.backgroundColor = .clear
        stagesCollection.showsHorizontalScrollIndicator = false
        stagesCollection.register(StageCell.self, forCellWithReuseIdentifier: "StageCell")
        stagesCollection.dataSource = self

        detailsTitleLabel.text = "Details"
        detailsTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        detailsStack.axis = .vertical
        detailsStack.spacing = 16

        infoStack.addArrangedSubview(aboutTitleLabel)
        infoStack.addArrangedSubview(aboutTextLabel)
        infoStack.addArrangedSubview(stagesTitleLabel)
        infoStack.addArrangedSubview(stagesCollection)
        infoStack.addArrangedSubview(detailsTitleLabel)
        infoStack.addArrangedSubview(detailsStack)
    }

    private func layoutUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        stagesCollection.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 240),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),

            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            stagesCollection.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func configureContent() {
        titleLabel.text = template.title
        aboutTextLabel.text = template.subtitle

        addDetailRow(icon: "calendar", title: "Duration", value: "\(template.days.count) days")
        addDetailRow(icon: "mappin.and.ellipse", title: "Number of locations", value: "\(template.steps.count) unique locations")
    }

    private func addDetailRow(icon: String, title: String, value: String) {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .label
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title

        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLabel.text = value

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(valueLabel)

        row.addArrangedSubview(iconView)
        row.addArrangedSubview(textStack)

        detailsStack.addArrangedSubview(row)
    }
}

extension PreviewTemplateViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return template.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StageCell", for: indexPath) as! StageCell
        cell.configure(
            title: "Day \(indexPath.item + 1)",
            subtitle: "\(template.steps[indexPath.item].subtitle) tasks)",
            imageName: template.steps[indexPath.item].imageName
        )
        return cell
    }
}

final class StageCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4

        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .secondaryLabel

        subtitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        subtitleLabel.numberOfLines = 2

        stack.axis = .vertical
        stack.spacing = 4

        contentView.addSubview(imageView)
        contentView.addSubview(stack)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 90),

            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String, subtitle: String, imageName: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = UIImage(named: imageName)
    }
}

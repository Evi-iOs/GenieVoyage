//
//  ItineraryDayCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 17.01.2025.
//

import UIKit

final class ItineraryEventCell: UICollectionViewCell {
    static let identifier = "ItineraryItemCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            timeLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 8),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            separator.heightAnchor.constraint(equalToConstant: 0.2),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with time: String, event: ItineraryEventModel?) {
            timeLabel.text = time
            if let event = event {
                iconImageView.image = event.icon
                iconImageView.isHidden = false
            } else {
                iconImageView.isHidden = true
            }
        }
}

// MARK: - UIDragInteractionDelegate
extension ItineraryEventCell: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = iconImageView.image else { return [] }
        let provider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = self // Сохраняем ссылку на ячейку
        return [dragItem]
    }
}

// MARK: - UIDropInteractionDelegate
extension ItineraryEventCell: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let cell = interaction.view as? ItineraryEventCell else { return }
        
        session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage], let image = images.first else { return }
            DispatchQueue.main.async {
                cell.iconImageView.image = image
                cell.iconImageView.isHidden = false
            }
        }
    }
}

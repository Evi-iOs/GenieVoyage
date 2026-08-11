//
//  SegmentControllCollectionViewCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 14.03.2025.
//

import UIKit

class SegmentCell: UICollectionViewCell {
    static let identifier = "SegmentCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            
            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            underlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, isSelected: Bool) {
        titleLabel.text = text
        titleLabel.textColor = isSelected ? .black : .gray
        underlineView.isHidden = !isSelected
    }
}

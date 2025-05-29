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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            underlineView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            underlineView.heightAnchor.constraint(equalToConstant: 3)
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

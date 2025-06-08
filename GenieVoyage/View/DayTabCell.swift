//
//  DayTabCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 06.06.2025.
//

import UIKit

class DayTabCell: UICollectionViewCell {
    
    static let identifier = "DayTabCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .black : .systemGray5
            titleLabel.textColor = isSelected ? .white : .label
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

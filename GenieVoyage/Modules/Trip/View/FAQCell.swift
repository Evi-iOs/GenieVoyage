//
//  FAQTableViewCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 07.08.2026.
//

import UIKit

final class FAQCell: UITableViewCell {
    static let reuseID = "FAQCell"
    
    private let questionLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 18)
        l.textColor = UIColor(hex: "0F172A")
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let answerLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = AppTheme.Colors.textGray
        l.numberOfLines = 0
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let chevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.tintColor = UIColor(hex: "CBD5E1")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var collapsedHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(questionLabel)
        contentView.addSubview(chevron)
        contentView.addSubview(answerLabel)
        
        collapsedHeightConstraint = answerLabel.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
            
            chevron.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.widthAnchor.constraint(equalToConstant: 14),
            chevron.heightAnchor.constraint(equalToConstant: 14),
            
            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 6),
            answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(question: String, answer: String, isExpanded: Bool) {
        questionLabel.text = question
        answerLabel.text = answer
        collapsedHeightConstraint.isActive = !isExpanded
        chevron.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi - 0.001) : .identity
    }
}

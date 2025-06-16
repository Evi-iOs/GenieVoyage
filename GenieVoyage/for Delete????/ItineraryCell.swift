//
//  ItineraryCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.12.2024.
//

import UIKit

class ItineraryCell: UITableViewCell {
    
    private let dayLabel = UILabel()
    private let eventStackView = UIStackView()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        dayLabel.font = .boldSystemFont(ofSize: 16)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        eventStackView.axis = .vertical
        eventStackView.spacing = 8
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.addSubview(eventStackView)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            eventStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            eventStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            eventStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            eventStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])
    }
    
//    func configure(with dayPlan: DayPlan) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dayLabel.text = "Day: \(dateFormatter.string(from: dayPlan.date))"
//        
//        eventStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear existing events
//        if dayPlan.events.isEmpty {
//            let noEventLabel = UILabel()
//            noEventLabel.text = "No events for this day."
//            noEventLabel.textColor = .gray
//            noEventLabel.font = .italicSystemFont(ofSize: 14)
//            eventStackView.addArrangedSubview(noEventLabel)
//        } else {
//            dayPlan.events.forEach { event in
//                let eventLabel = UILabel()
//                eventLabel.text = "- \(event.title) at \(DateFormatter.localizedString(from: event.time, dateStyle: .none, timeStyle: .short))"
//                eventStackView.addArrangedSubview(eventLabel)
//            }
//        }
//    }
}

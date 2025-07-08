//
//  TransportSegmentControl.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 07.07.2025.
//

import UIKit
import MapKit

final class TransportSegmentedControl: UIView {
    
    private let options: [(icon: String, type: MKDirectionsTransportType)] = [
        ("car.fill", .automobile),
        ("figure.walk", .walking),
        ("tram.fill", .transit)
    ]
    
    private let mainButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private var isExpanded = false
    
    var selectedType: MKDirectionsTransportType = .automobile {
        didSet {
            updateMainButton()
        }
    }
    
    var onSelect: ((MKDirectionsTransportType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        setupMainButton()
        updateMainButton()
    }
    
    private func setupMainButton() {
        configure(button: mainButton, icon: "car.fill")
        mainButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        stackView.addArrangedSubview(mainButton)
    }
    
    private func updateMainButton() {
        let selected = options.first(where: { $0.type == selectedType })?.icon ?? "car.fill"
        mainButton.setImage(UIImage(systemName: selected), for: .normal)
        updateOptionButtons()
    }
    
    private func updateOptionButtons() {
        stackView.arrangedSubviews
            .dropFirst()
            .forEach { $0.removeFromSuperview() }
        
        guard isExpanded else { return }
        
        for option in options where option.type != selectedType {
            let button = UIButton(type: .system)
            configure(button: button, icon: option.icon)
            button.tag = Int(option.type.rawValue)
            button.addTarget(self, action: #selector(selectTransport(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func configure(button: UIButton, icon: String) {
        let image = UIImage(systemName: icon)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.backgroundColor = .gray
        button.alpha = 0.7
    }
    
    @objc private func toggleMenu() {
        isExpanded.toggle()
        updateOptionButtons()
        
        let buttons = stackView.arrangedSubviews.dropFirst()
        buttons.forEach {
            $0.alpha = isExpanded ? 0 : 1
            $0.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) {
            buttons.forEach {
                $0.alpha = self.isExpanded ? 1 : 0
            }
        } completion: { _ in
            if !self.isExpanded {
                buttons.forEach { $0.isHidden = true }
            }
        }
    }
    
    @objc private func selectTransport(_ sender: UIButton) {
        guard let selected = options.first(where: { Int($0.type.rawValue) == sender.tag }) else { return }
        selectedType = selected.type
        onSelect?(selected.type)
        toggleMenu()
    }
}


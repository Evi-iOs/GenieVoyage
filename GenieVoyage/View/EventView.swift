//
//  EventView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 24.05.2025.
//

import UIKit

final class EventView: UIView {
    
    var event: ItineraryEventModel {
        didSet {
            updateContent()
        }
    }
    
    var onMove: ((CGFloat) -> Void)?
    var onResize: ((CGFloat) -> Void)?
    var onMoveEnd: (() -> Void)?
    var onResizeEnd: (() -> Void)?
    var onTap: (() -> Void)?
    
    var topConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    private let resizeHandle = UIView()
    
    init(event: ItineraryEventModel) {
        self.event = event
        super.init(frame: .zero)
        setupView()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachConstraints(to container: UIView, top: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        topConstraint = topAnchor.constraint(equalTo: container.topAnchor, constant: top)
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        
        NSLayoutConstraint.activate([
            topConstraint!,
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 60),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            heightConstraint!
        ])
    }
    
    func setLayout(top: CGFloat, height: CGFloat, animated: Bool = false) {
        topConstraint?.constant = top
        heightConstraint?.constant = height
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            superview?.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        backgroundColor = event.category.color.withAlphaComponent(0.7)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        resizeHandle.translatesAutoresizingMaskIntoConstraints = false
        resizeHandle.backgroundColor = .white
        resizeHandle.layer.cornerRadius = 3
        addSubview(resizeHandle)
        
        NSLayoutConstraint.activate([
            resizeHandle.heightAnchor.constraint(equalToConstant: 3),
            resizeHandle.widthAnchor.constraint(equalToConstant: 50),
            resizeHandle.centerXAnchor.constraint(equalTo: centerXAnchor),
            resizeHandle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        
        updateContent()
    }
    
    private func updateContent() {
        subviews
            .filter { $0 != resizeHandle }
            .forEach { $0.removeFromSuperview() }
        
        let iconView = UIImageView(image: event.icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = event.locationName ?? "Event"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        
        let hStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            hStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
        
        let resizePan = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        resizeHandle.addGestureRecognizer(resizePan)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        isUserInteractionEnabled = true
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            onMove?(translation.y)
            gesture.setTranslation(.zero, in: self.superview)
        case .ended, .cancelled:
            onMoveEnd?()
        default:
            break
        }
    }
    
    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            onResize?(translation.y)
            gesture.setTranslation(.zero, in: self.superview)
        case .ended, .cancelled:
            onResizeEnd?()
        default:
            break
        }
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

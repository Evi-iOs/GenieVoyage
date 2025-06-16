//
//  PointEventEditorView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 28.05.2025.
//

import UIKit

class PointEventEditorView: UIView {
    private let viewModel: PointEventEditorViewModel
    private let locationTextField = UITextField()

    init(viewModel: PointEventEditorViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        locationTextField.placeholder = "Place name"
        locationTextField.addTarget(self, action: #selector(locationChanged), for: .editingChanged)
        locationTextField.borderStyle = .roundedRect

        addSubview(locationTextField)
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            locationTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    @objc private func locationChanged() {
        viewModel.locationName = locationTextField.text
    }
}


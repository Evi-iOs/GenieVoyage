//
//  OnboardingViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 07.02.2026.
//

import Foundation
import UIKit

final class OnboardingViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let gradientView = UIView()
    private let titleLabel = UILabel()
    private let button = UIButton(type: .system)
    private let stack = UIStackView()
    
    var onStartTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black

        backgroundImageView.image = UIImage(named: "Airborne Takeoff-2")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)

        titleLabel.text = "START\nYOUR JOURNEY\nNOW"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.numberOfLines = 0

        button.setTitle("Get started", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(button)

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])

        addGradient()
    }

    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradient.locations = [0.3, 1.0]
        gradient.frame = view.bounds
        gradientView.layer.addSublayer(gradient)
    }
    
    @objc private func startTapped() {
        onStartTapped?()
    }
}

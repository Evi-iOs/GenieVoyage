//
//  PersonalInfoViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import UIKit

final class PersonalInfoViewController: UIViewController {
    
    private let viewModel: PersonalInfoViewModel
    
    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let formCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var nameField = makeField(placeholder: "Full Name", keyboard: .default)
    private lazy var emailField = makeField(placeholder: "Email", keyboard: .emailAddress)
    
    private lazy var saveButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Save", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = AppTheme.Colors.primaryDarkBlue
        b.layer.cornerRadius = 18
        b.layer.shadowColor = UIColor(red: 0.08, green: 0.18, blue: 0.35, alpha: 0.45).cgColor
        b.layer.shadowOffset = CGSize(width: 0, height: 6)
        b.layer.shadowRadius = 14
        b.layer.shadowOpacity = 1
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Personal Information"
        view.backgroundColor = AppTheme.Colors.backgroundGray
        nameField.text = viewModel.name
        emailField.text = viewModel.email
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func buildLayout() {
        let nameLabel = sectionLabel("NAME")
        let emailLabel = sectionLabel("EMAIL")
        let sep = UIView()
        sep.backgroundColor = UIColor(hex: "F1F5F9")
        sep.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, nameField, sep, emailLabel, emailField].forEach { formCard.addSubview($0) }
        view.addSubview(formCard)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            formCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            formCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            formCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: formCard.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            sep.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            sep.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            sep.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -16),
            sep.heightAnchor.constraint(equalToConstant: 1),
            
            emailLabel.topAnchor.constraint(equalTo: sep.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            emailField.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            emailField.bottomAnchor.constraint(equalTo: formCard.bottomAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: formCard.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func sectionLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: AppTheme.Colors.textGray,
            .kern: 1.0
        ])
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }
    
    private func makeField(placeholder: String, keyboard: UIKeyboardType) -> UITextField {
        let f = UITextField()
        f.placeholder = placeholder
        f.keyboardType = keyboard
        f.autocapitalizationType = keyboard == .emailAddress ? .none : .words
        f.autocorrectionType = .no
        f.font = .systemFont(ofSize: 17)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }
    
    @objc private func saveTapped() {
        let result = viewModel.save(name: nameField.text ?? "", email: emailField.text ?? "")
        switch result {
        case .success:
            navigationController?.popViewController(animated: true)
        case .failure(.emptyName):
            showAlert("Name can't be empty.")
        case .failure(.invalidEmail):
            showAlert("Please enter a valid email address.")
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

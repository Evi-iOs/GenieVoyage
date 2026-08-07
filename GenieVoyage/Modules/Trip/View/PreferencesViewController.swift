//
//  PreferencesViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import UIKit

final class PreferencesViewController: UIViewController {
    
    private let viewModel: PreferencesViewModel
    
    init(viewModel: PreferencesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let card: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var currencyValueLabel = UILabel()
    private lazy var unitsSegment = UISegmentedControl(items: DistanceUnit.allCases.map { $0.displayName })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Preferences"
        view.backgroundColor = AppTheme.Colors.backgroundGray
        buildLayout()
        populate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func populate() {
        currencyValueLabel.text = viewModel.currency
        unitsSegment.selectedSegmentIndex = DistanceUnit.allCases.firstIndex(of: viewModel.distanceUnit) ?? 0
    }
    
    private func buildLayout() {
        view.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Currency row
        let currencyRow = UIView()
        let currencyTitle = rowTitle("Currency")
        currencyValueLabel.font = .systemFont(ofSize: 17)
        currencyValueLabel.textColor = AppTheme.Colors.textGray
        currencyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor(hex: "CBD5E1")
        chevron.translatesAutoresizingMaskIntoConstraints = false
        [currencyTitle, currencyValueLabel, chevron].forEach { currencyRow.addSubview($0) }
        currencyRow.translatesAutoresizingMaskIntoConstraints = false
        currencyRow.isUserInteractionEnabled = true
        currencyRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currencyTapped)))
        
        // Units row
        let unitsRow = UIView()
        let unitsTitle = rowTitle("Distance Units")
        unitsSegment.translatesAutoresizingMaskIntoConstraints = false
        unitsSegment.addTarget(self, action: #selector(unitsChanged), for: .valueChanged)
        [unitsTitle, unitsSegment].forEach { unitsRow.addSubview($0) }
        unitsRow.translatesAutoresizingMaskIntoConstraints = false
        
        // Notifications row
        let notifRow = UIView()
        let notifTitle = rowTitle("Notifications")
        [notifTitle].forEach { notifRow.addSubview($0) }
        notifRow.translatesAutoresizingMaskIntoConstraints = false
        
        let sep1 = separator()
        let sep2 = separator()
        
        [currencyRow, sep1, unitsRow, sep2, notifRow].forEach { card.addSubview($0) }
        
        NSLayoutConstraint.activate([
            currencyRow.topAnchor.constraint(equalTo: card.topAnchor),
            currencyRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            currencyRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            currencyRow.heightAnchor.constraint(equalToConstant: 56),
            currencyTitle.leadingAnchor.constraint(equalTo: currencyRow.leadingAnchor, constant: 16),
            currencyTitle.centerYAnchor.constraint(equalTo: currencyRow.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: currencyRow.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: currencyRow.centerYAnchor),
            currencyValueLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
            currencyValueLabel.centerYAnchor.constraint(equalTo: currencyRow.centerYAnchor),
            
            sep1.topAnchor.constraint(equalTo: currencyRow.bottomAnchor),
            sep1.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            sep1.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            sep1.heightAnchor.constraint(equalToConstant: 1),
            
            unitsRow.topAnchor.constraint(equalTo: sep1.bottomAnchor),
            unitsRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            unitsRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            unitsRow.heightAnchor.constraint(equalToConstant: 64),
            unitsTitle.topAnchor.constraint(equalTo: unitsRow.topAnchor, constant: 10),
            unitsTitle.leadingAnchor.constraint(equalTo: unitsRow.leadingAnchor, constant: 16),
            unitsSegment.topAnchor.constraint(equalTo: unitsTitle.bottomAnchor, constant: 8),
            unitsSegment.leadingAnchor.constraint(equalTo: unitsRow.leadingAnchor, constant: 16),
            unitsSegment.trailingAnchor.constraint(equalTo: unitsRow.trailingAnchor, constant: -16),
            
            sep2.topAnchor.constraint(equalTo: unitsRow.bottomAnchor, constant: 16),
            sep2.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            sep2.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            sep2.heightAnchor.constraint(equalToConstant: 1),
            
            notifRow.topAnchor.constraint(equalTo: sep2.bottomAnchor),
            notifRow.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            notifRow.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            notifRow.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            notifRow.heightAnchor.constraint(equalToConstant: 56),
            notifTitle.leadingAnchor.constraint(equalTo: notifRow.leadingAnchor, constant: 16),
            notifTitle.centerYAnchor.constraint(equalTo: notifRow.centerYAnchor)
        ])
    }
    
    private func rowTitle(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .boldSystemFont(ofSize: 17)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }
    
    private func separator() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "F1F5F9")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    @objc private func currencyTapped() {
        let alert = UIAlertController(title: "Currency", message: nil, preferredStyle: .actionSheet)
        for code in PreferencesViewModel.currencies {
            alert.addAction(UIAlertAction(title: code, style: .default) { [weak self] _ in
                self?.viewModel.updateCurrency(code)
                self?.currencyValueLabel.text = code
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = currencyValueLabel
        }
        present(alert, animated: true)
    }
    
    @objc private func unitsChanged() {
        let unit = DistanceUnit.allCases[unitsSegment.selectedSegmentIndex]
        viewModel.updateDistanceUnit(unit)
    }
}

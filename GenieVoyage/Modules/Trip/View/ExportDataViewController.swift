//
//  ExportDataViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import UIKit

final class ExportDataViewController: UIViewController {
    
    private let viewModel: ExportDataViewModel
    
    init(viewModel: ExportDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "doc.richtext"))
        iv.tintColor = UIColor(hex: "0F172A")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.text = "Export a PDF report of all your trips and ticket counts."
        l.font = .systemFont(ofSize: 15)
        l.textColor = AppTheme.Colors.textGray
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var exportButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Generate PDF Report", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.backgroundColor = UIColor(hex: "0F172A")
        b.layer.cornerRadius = 26
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(exportTapped), for: .touchUpInside)
        return b
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .medium)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Export Data"
        view.backgroundColor = AppTheme.Colors.backgroundGray
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func buildLayout() {
        [iconView, infoLabel, exportButton, spinner].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 64),
            iconView.heightAnchor.constraint(equalToConstant: 64),
            
            infoLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            exportButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32),
            exportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exportButton.heightAnchor.constraint(equalToConstant: 52),
            
            spinner.centerXAnchor.constraint(equalTo: exportButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: exportButton.centerYAnchor)
        ])
    }
    
    @objc private func exportTapped() {
        exportButton.isEnabled = false
        exportButton.setTitle("", for: .normal)
        spinner.startAnimating()
        
        Task {
            let url = await viewModel.generateReport()
            spinner.stopAnimating()
            exportButton.isEnabled = true
            exportButton.setTitle("Generate PDF Report", for: .normal)
            
            guard let url else {
                showAlert("Couldn't generate the report. Please try again.")
                return
            }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityVC, animated: true)
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Export Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

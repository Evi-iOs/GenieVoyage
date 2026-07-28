//
//  ProfileViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 10.07.2025.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    var onPersonalInfoTapped: (() -> Void)?
    var onPreferencesTapped: (() -> Void)?
    var onExportDataTapped: (() -> Void)?
    var onHelpTapped: (() -> Void)?
    var onPrivacyPolicyTapped: (() -> Void)?
    var onTermsTapped: (() -> Void)?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = AppTheme.Colors.backgroundGray
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.Colors.backgroundGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Profile"
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(hex: "0F172A")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Avatar
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48
        iv.backgroundColor = UIColor(hex: "CBD5E1")
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor(hex: "0F172A")
        b.layer.cornerRadius = 14
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.white.cgColor
        let cfg = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        b.setImage(UIImage(systemName: "pencil", withConfiguration: cfg), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(editAvatarTapped), for: .touchUpInside)
        return b
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textColor = UIColor(hex: "0F172A")
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Stats
    
    private let statsCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let statsSectionLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString(string: "MY STATS", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .bold),
            .foregroundColor: AppTheme.Colors.textGray,
            .kern: 1.5
        ])
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private var tripsValueLabel: UILabel?
    private var daysValueLabel: UILabel?
    private var ticketsValueLabel: UILabel?
    
    // MARK: - Menu
    
    private let menuCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private enum MenuAction {
        case personalInfo, preferences, exportData, help
    }
    
    private let menuItems: [(icon: String, title: String, action: MenuAction)] = [
        ("person.crop.circle", "Personal Information", .personalInfo),
        ("slider.horizontal.3", "Preferences", .preferences),
        ("square.and.arrow.up", "Export Data", .exportData),
        ("questionmark.circle", "Help & Support", .help)
    ]
    
    // MARK: - Data & About
    
    private let dataCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var deleteAllDataButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Delete All Data", for: .normal)
        b.setTitleColor(.systemRed, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.contentHorizontalAlignment = .left
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(deleteAllDataTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var privacyPolicyButton = makeLinkButton(title: "Privacy Policy", action: #selector(privacyPolicyTapped))
    private lazy var termsButton = makeLinkButton(title: "Terms of Use", action: #selector(termsTapped))
    
    private let versionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = AppTheme.Colors.textGray
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.Colors.backgroundGray
        navigationController?.setNavigationBarHidden(true, animated: false)
        buildLayout()
        populate()
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        nameLabel.addGestureRecognizer(nameTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.loadStats()
        }
    }
        
    private func buildLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Avatar container
        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        avatarContainer.addSubview(editAvatarButton)
        avatarContainer.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            avatarContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 96),
            avatarImageView.heightAnchor.constraint(equalToConstant: 96),
            
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 2),
            editAvatarButton.widthAnchor.constraint(equalToConstant: 28),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])
        
        // Stats
        contentView.addSubview(statsSectionLabel)
        NSLayoutConstraint.activate([
            statsSectionLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 28),
            statsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        contentView.addSubview(statsCard)
        NSLayoutConstraint.activate([
            statsCard.topAnchor.constraint(equalTo: statsSectionLabel.bottomAnchor, constant: 10),
            statsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsCard.heightAnchor.constraint(equalToConstant: 88)
        ])
        buildStatsCard()
        
        // Menu card
        contentView.addSubview(menuCard)
        NSLayoutConstraint.activate([
            menuCard.topAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: 20),
            menuCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            menuCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        buildMenuCard()
        
        // Data & About card
        contentView.addSubview(dataCard)
        NSLayoutConstraint.activate([
            dataCard.topAnchor.constraint(equalTo: menuCard.bottomAnchor, constant: 20),
            dataCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        buildDataCard()
        
        // Version
        contentView.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: dataCard.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func buildStatsCard() {
        let tripsVal = UILabel()
        let daysVal = UILabel()
        let ticketsVal = UILabel()
        tripsValueLabel = tripsVal
        daysValueLabel = daysVal
        ticketsValueLabel = ticketsVal
        
        let col1 = makeStatCol(valueLabel: tripsVal, caption: "TRIPS")
        let col2 = makeStatCol(valueLabel: daysVal, caption: "DAYS TRAVELED")
        let col3 = makeStatCol(valueLabel: ticketsVal, caption: "TICKETS")
        let div1 = vDiv()
        let div2 = vDiv()
        
        [col1, div1, col2, div2, col3].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            statsCard.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            col1.topAnchor.constraint(equalTo: statsCard.topAnchor),
            col1.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),
            col1.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor),
            
            div1.centerYAnchor.constraint(equalTo: statsCard.centerYAnchor),
            div1.leadingAnchor.constraint(equalTo: col1.trailingAnchor),
            
            col2.topAnchor.constraint(equalTo: statsCard.topAnchor),
            col2.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),
            col2.leadingAnchor.constraint(equalTo: div1.trailingAnchor),
            col2.widthAnchor.constraint(equalTo: col1.widthAnchor),
            
            div2.centerYAnchor.constraint(equalTo: statsCard.centerYAnchor),
            div2.leadingAnchor.constraint(equalTo: col2.trailingAnchor),
            
            col3.topAnchor.constraint(equalTo: statsCard.topAnchor),
            col3.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),
            col3.leadingAnchor.constraint(equalTo: div2.trailingAnchor),
            col3.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor),
            col3.widthAnchor.constraint(equalTo: col1.widthAnchor)
        ])
    }

    private func vDiv() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "CBD5E1")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 1).isActive = true
        v.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return v
    }
    
    private func buildMenuCard() {
        var lastView: UIView? = nil
        
        for (i, item) in menuItems.enumerated() {
            let row = makeMenuRow(icon: item.icon, title: item.title)
            row.tag = i
            menuCard.addSubview(row)
            
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: menuCard.leadingAnchor),
                row.trailingAnchor.constraint(equalTo: menuCard.trailingAnchor),
                row.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            if let prev = lastView {
                row.topAnchor.constraint(equalTo: prev.bottomAnchor).isActive = true
            } else {
                row.topAnchor.constraint(equalTo: menuCard.topAnchor).isActive = true
            }
            
            if i == menuItems.count - 1 {
                row.bottomAnchor.constraint(equalTo: menuCard.bottomAnchor).isActive = true
            } else {
                let sep = UIView()
                sep.backgroundColor = UIColor(hex: "F1F5F9")
                sep.translatesAutoresizingMaskIntoConstraints = false
                menuCard.addSubview(sep)
                NSLayoutConstraint.activate([
                    sep.topAnchor.constraint(equalTo: row.bottomAnchor),
                    sep.leadingAnchor.constraint(equalTo: menuCard.leadingAnchor, constant: 56),
                    sep.trailingAnchor.constraint(equalTo: menuCard.trailingAnchor, constant: -16),
                    sep.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
            
            lastView = row
        }
    }
    
    private func buildDataCard() {
        let privacySep = UIView()
        let termsSep = UIView()
        [privacySep, termsSep].forEach {
            $0.backgroundColor = UIColor(hex: "F1F5F9")
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [deleteAllDataButton, privacySep, privacyPolicyButton, termsSep, termsButton].forEach {
            dataCard.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            deleteAllDataButton.topAnchor.constraint(equalTo: dataCard.topAnchor),
            deleteAllDataButton.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor),
            deleteAllDataButton.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor),
            deleteAllDataButton.heightAnchor.constraint(equalToConstant: 52),
            
            privacySep.topAnchor.constraint(equalTo: deleteAllDataButton.bottomAnchor),
            privacySep.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor, constant: 16),
            privacySep.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor, constant: -16),
            privacySep.heightAnchor.constraint(equalToConstant: 1),
            
            privacyPolicyButton.topAnchor.constraint(equalTo: privacySep.bottomAnchor),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 52),
            
            termsSep.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor),
            termsSep.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor, constant: 16),
            termsSep.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor, constant: -16),
            termsSep.heightAnchor.constraint(equalToConstant: 1),
            
            termsButton.topAnchor.constraint(equalTo: termsSep.bottomAnchor),
            termsButton.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor),
            termsButton.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor),
            termsButton.heightAnchor.constraint(equalToConstant: 52),
            termsButton.bottomAnchor.constraint(equalTo: dataCard.bottomAnchor)
        ])
    }
    
    // MARK: - Populate
    
    private func populate() {
        nameLabel.text = viewModel.userName
        avatarImageView.image = viewModel.avatarImage
        if viewModel.avatarImage == nil {
            avatarImageView.backgroundColor = UIColor(hex: "94A3B8")
        }
        
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        versionLabel.attributedText = NSAttributedString(string: "VERSION \(bundleVersion) (\(build))", attributes: [
            .kern: 1.0
        ])
        
        updateStatsLabels()
        viewModel.onStatsUpdated = { [weak self] in
            self?.updateStatsLabels()
        }
    }
    
    private func updateStatsLabels() {
        tripsValueLabel?.text = "\(viewModel.tripsCount)"
        daysValueLabel?.text = "\(viewModel.daysTraveled)"
        ticketsValueLabel?.text = "\(viewModel.ticketsCount)"
    }
    
    // MARK: - Factory
    
    private func makeStatCol(valueLabel: UILabel, caption: String) -> UIView {
        valueLabel.font = .systemFont(ofSize: 26, weight: .bold)
        valueLabel.textColor = UIColor(hex: "0F172A")
        valueLabel.textAlignment = .center
        valueLabel.text = "0"
        
        let capLbl = UILabel()
        capLbl.attributedText = NSAttributedString(string: caption, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
            .foregroundColor: AppTheme.Colors.textGray,
            .kern: 0.8
        ])
        capLbl.textAlignment = .center
        capLbl.numberOfLines = 1
        capLbl.adjustsFontSizeToFitWidth = true
        
        let stack = UIStackView(arrangedSubviews: [valueLabel, capLbl])
        stack.axis = .vertical; stack.spacing = 4; stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -4)
        ])
        return container
    }
    
    private func makeMenuRow(icon: String, title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = true
        
        let iconIV = UIImageView()
        let cfg = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        iconIV.image = UIImage(systemName: icon, withConfiguration: cfg)
        iconIV.tintColor = AppTheme.Colors.textGray
        iconIV.contentMode = .scaleAspectFit
        iconIV.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = .boldSystemFont(ofSize: 17)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let chevron = UIImageView()
        chevron.image = UIImage(systemName: "chevron.right",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))
        chevron.tintColor = UIColor(hex: "CBD5E1")
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconIV)
        container.addSubview(titleLbl)
        container.addSubview(chevron)
        NSLayoutConstraint.activate([
            iconIV.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconIV.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconIV.widthAnchor.constraint(equalToConstant: 24),
            iconIV.heightAnchor.constraint(equalToConstant: 24),
            
            titleLbl.leadingAnchor.constraint(equalTo: iconIV.trailingAnchor, constant: 14),
            titleLbl.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuRowTapped(_:)))
        container.addGestureRecognizer(tap)
        
        return container
    }
    
    private func makeLinkButton(title: String, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(UIColor(hex: "0F172A"), for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 17)
        b.contentHorizontalAlignment = .left
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }
    
    // MARK: - Actions
    
    @objc private func editAvatarTapped() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized || status == .limited {
            presentPhotoPicker()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.presentPhotoPicker()
                    }
                }
            }
        }
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func nameLabelTapped() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] tf in
            tf.text = self?.viewModel.userName
            tf.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let text = alert?.textFields?.first?.text else { return }
            self?.viewModel.updateName(text)
            self?.nameLabel.text = self?.viewModel.userName
        })
        present(alert, animated: true)
    }
    
    @objc private func deleteAllDataTapped() {
        let alert = UIAlertController(
            title: "Delete All Data?",
            message: "This will permanently delete all your trips, events, and tickets. This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            Task {
                await self?.viewModel.deleteAllData()
            }
        })
        present(alert, animated: true)
    }
    
    @objc private func privacyPolicyTapped() {
        onPrivacyPolicyTapped?()
    }
    
    @objc private func termsTapped() {
        onTermsTapped?()
    }
    
    @objc private func menuRowTapped(_ gesture: UITapGestureRecognizer) {
        guard let v = gesture.view else { return }
        UIView.animate(withDuration: 0.1, animations: { v.alpha = 0.5 }) { _ in
            UIView.animate(withDuration: 0.15) { v.alpha = 1 }
        }
        
        switch menuItems[v.tag].action {
        case .personalInfo: onPersonalInfoTapped?()
        case .preferences: onPreferencesTapped?()
        case .exportData: onExportDataTapped?()
        case .help: onHelpTapped?()
        }
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self?.viewModel.updateAvatar(image)
                self?.avatarImageView.image = image
            }
        }
    }
}

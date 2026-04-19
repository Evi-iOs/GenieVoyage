//
//  ProfileViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 10.07.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = UIColor(hex: "F1F5F9")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "F1F5F9")
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
    
    private let settingsButton: UIButton = {
        let b = UIButton(type: .system)
        let cfg = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        b.setImage(UIImage(systemName: "gearshape", withConfiguration: cfg), for: .normal)
        b.tintColor = UIColor(hex: "0F172A")
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
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
    
    private let editAvatarButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor(hex: "0F172A")
        b.layer.cornerRadius = 14
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.white.cgColor
        let cfg = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        b.setImage(UIImage(systemName: "pencil", withConfiguration: cfg), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textColor = UIColor(hex: "0F172A")
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let emailLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor(hex: "64748B")
        l.textAlignment = .center
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
            .font: UIFont.systemFont(ofSize: 11, weight: .bold),
            .foregroundColor: UIColor(hex: "94A3B8"),
            .kern: 1.5
        ])
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Menu
    
    private let menuCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let menuItems: [(icon: String, title: String)] = [
        ("person.crop.circle", "Personal Information"),
        ("bell", "Notifications"),
        ("shield", "Security"),
        ("questionmark.circle","Help & Support")
    ]
    
    // MARK: - Logout
    
    private let logoutButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Log Out", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(hex: "0F172A")
        b.layer.cornerRadius = 18
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(ProfileViewController.self, action: #selector(logoutTapped), for: .touchUpInside)
        return b
    }()
    
    private let versionLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString(string: "TRAVEL APP VERSION 2.4.0", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor(hex: "94A3B8"),
            .kern: 1.2
        ])
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F1F5F9")
        navigationController?.setNavigationBarHidden(true, animated: false)
        buildLayout()
        populate()
    }
    
    // MARK: - Layout
    
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
        
        // Nav bar
        contentView.addSubview(titleLabel)
        contentView.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 36),
            settingsButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // Avatar container
        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        avatarContainer.addSubview(editAvatarButton)
        avatarContainer.addSubview(nameLabel)
        avatarContainer.addSubview(emailLabel)
        
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
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: -20),
            emailLabel.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])
        
        // Stats section label
        contentView.addSubview(statsSectionLabel)
        NSLayoutConstraint.activate([
            statsSectionLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 28),
            statsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        // Stats card
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
        
        // Logout
        contentView.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: menuCard.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Version
        contentView.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func buildStatsCard() {
        let stats: [(value: String, label: String)] = [
            ("24", "TRIPS"),
            ("12", "COUNTRIES"),
            ("458", "PHOTOS")
        ]
        
        let col1 = makeStatCol(value: stats[0].value, label: stats[0].label)
        let col2 = makeStatCol(value: stats[1].value, label: stats[1].label)
        let col3 = makeStatCol(value: stats[2].value, label: stats[2].label)
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
            
            // div1
            div1.centerYAnchor.constraint(equalTo: statsCard.centerYAnchor),
            div1.leadingAnchor.constraint(equalTo: col1.trailingAnchor),
            
            col2.topAnchor.constraint(equalTo: statsCard.topAnchor),
            col2.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor),
            col2.leadingAnchor.constraint(equalTo: div1.trailingAnchor),
            col2.widthAnchor.constraint(equalTo: col1.widthAnchor),
            
            // div2
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
                // Separator
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
    
    // MARK: - Populate
    
    private func populate() {
        nameLabel.text  = "Julian Anderson"
        emailLabel.text = "julian.travels@icloud.com"
        avatarImageView.backgroundColor = UIColor(hex: "94A3B8")
    }
    
    // MARK: - Factory
    
    private func makeStatCol(value: String, label: String) -> UIView {
        let valLbl = UILabel()
        valLbl.text = value
        valLbl.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        valLbl.textColor = UIColor(hex: "0F172A")
        valLbl.textAlignment = .center
        
        let capLbl = UILabel()
        capLbl.attributedText = NSAttributedString(string: label, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
            .foregroundColor: UIColor(hex: "94A3B8"),
            .kern: 0.8
        ])
        capLbl.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [valLbl, capLbl])
        stack.axis = .vertical; stack.spacing = 4; stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
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
        iconIV.tintColor = UIColor(hex: "64748B")
        iconIV.contentMode = .scaleAspectFit
        iconIV.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLbl.textColor = UIColor(hex: "0F172A")
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
        
        // Tap highlight
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuRowTapped(_:)))
        container.addGestureRecognizer(tap)
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func logoutTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.logoutButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.15) { self.logoutButton.transform = .identity }
        }
    }
    
    @objc private func menuRowTapped(_ gesture: UITapGestureRecognizer) {
        guard let v = gesture.view else { return }
        UIView.animate(withDuration: 0.1, animations: { v.alpha = 0.5 }) { _ in
            UIView.animate(withDuration: 0.15) { v.alpha = 1 }
        }
    }
}

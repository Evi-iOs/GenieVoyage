//
//  CustomTabBarView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 19.03.2026.
//

import UIKit
import Foundation

struct TabBarItem {
    let icon: String
    let title: String
    let tag: Int
}

final class CustomTabBarView: UIView {

    private let items: [TabBarItem] = [
        TabBarItem(icon: "safari", title: "EXPLORE", tag: 0),
        TabBarItem(icon: "heart", title: "SAVED", tag: 1),
        TabBarItem(icon: "", title: "", tag: -1),  // FAB placeholder
        TabBarItem(icon: "ticket", title: "TICKETS", tag: 3),
        TabBarItem(icon: "person", title: "PROFILE", tag: 4)
    ]

    var onTabSelected: ((Int) -> Void)?
    var onFABTap: (() -> Void)?

    private(set) var selectedTag: Int = 0

    private var tabItemViews: [UIView] = []
    private var tabIconViews: [UIImageView] = []
    private var tabLabelViews: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var fabButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = AppTheme.Colors.primary
        button.layer.cornerRadius = AppTheme.TabBarLayout.fabSize / 2
        button.tintColor = .white
        let cfg = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: "plus", withConfiguration: cfg), for: .normal)
        // Shadow
        AppTheme.Shadow.apply(button.layer, style: .accent)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setup() {
        backgroundColor = .clear
        clipsToBounds = false

        setupBackground()
        setupTabItems()
        setupFAB()
        updateSelection(tag: 0, animated: false)
    }

    private func setupBackground() {
        addSubview(backgroundView)
        backgroundView.addSubview(separatorView)

        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: -3)
        backgroundView.layer.shadowRadius = 12
        backgroundView.layer.shadowOpacity = 0.06
        backgroundView.layer.masksToBounds = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            separatorView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupTabItems() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 43)
        ])

        for item in items {
            let container = UIView()
            container.clipsToBounds = false

            if item.tag == -1 {
                stack.addArrangedSubview(container)
                continue
            }

            let cfg = UIImage.SymbolConfiguration(pointSize: AppTheme.TabBarLayout.iconSize, weight: .medium)
            let iv = UIImageView(image: UIImage(systemName: item.icon, withConfiguration: cfg))
            iv.contentMode = .scaleAspectFit
            iv.tintColor = AppTheme.Colors.primary
            iv.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = item.title
            label.font = AppTheme.Fonts.overline
            label.textColor = AppTheme.Colors.tabInactive
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false

            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            container.addGestureRecognizer(tap)
            container.tag = item.tag
            container.isUserInteractionEnabled = true

            container.addSubview(iv)
            container.addSubview(label)

            NSLayoutConstraint.activate([
                iv.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                iv.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
                iv.widthAnchor.constraint(equalToConstant: AppTheme.TabBarLayout.iconSize + 2),
                iv.heightAnchor.constraint(equalToConstant: AppTheme.TabBarLayout.iconSize + 2),

                label.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 4),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])

            tabItemViews.append(container)
            tabIconViews.append(iv)
            tabLabelViews.append(label)

            stack.addArrangedSubview(container)
        }
    }

    private func setupFAB() {
        addSubview(fabButton)
        NSLayoutConstraint.activate([
            fabButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fabButton.topAnchor.constraint(equalTo: topAnchor, constant: AppTheme.TabBarLayout.fabOffset),
            fabButton.widthAnchor.constraint(equalToConstant: AppTheme.TabBarLayout.fabSize),
            fabButton.heightAnchor.constraint(equalToConstant: AppTheme.TabBarLayout.fabSize)
        ])
        fabButton.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func tabTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        updateSelection(tag: tag, animated: true)
        onTabSelected?(tag)
    }

    @objc private func fabTapped() {
        animateFAB()
        onFABTap?()
    }

    // MARK: - Selection

    func updateSelection(tag: Int, animated: Bool) {
        selectedTag = tag
        let duration = animated ? 0.22 : 0.0

        for (index, container) in tabItemViews.enumerated() {
            let isSelected = container.tag == tag
            let iv = tabIconViews[index]
            let lbl = tabLabelViews[index]

            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5) {
                iv.tintColor  = isSelected ? AppTheme.Colors.tabActive : AppTheme.Colors.tabInactive
                lbl.textColor = isSelected ? AppTheme.Colors.tabActive : AppTheme.Colors.tabInactive
                iv.transform  = isSelected
                    ? CGAffineTransform(scaleX: 1.12, y: 1.12)
                    : .identity
            }
        }
    }

    // MARK: - FAB Animation
    
    private func animateFAB() {
        UIView.animate(withDuration: 0.08, animations: {
            self.fabButton.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        }) { _ in
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.8
            ) {
                self.fabButton.transform = .identity
            }
        }
    }

    private var isFABOpen = false

    func toggleFABState() {
        isFABOpen.toggle()
        let angle: CGFloat = isFABOpen ? .pi / 4 : 0
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0.5) {
            self.fabButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}

final class CustomTabBarController: UITabBarController {
    
    var onFABTap: (() -> Void)?
    
    private lazy var customBar: CustomTabBarView = {
        let v = CustomTabBarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var customBarBottomConstraint: NSLayoutConstraint?
    private let customBarHeight: CGFloat = 88
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNativeTabBar()
        embedCustomBar()
        bindCustomBar()
    }
    
    private func hideNativeTabBar() {
        tabBar.isHidden = true
        additionalSafeAreaInsets.bottom = customBarHeight
    }
    
    private func embedCustomBar() {
        view.addSubview(customBar)
        
        let bottom = customBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        customBarBottomConstraint = bottom
        
        NSLayoutConstraint.activate([
            customBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customBar.heightAnchor.constraint(equalToConstant: customBarHeight),
            bottom
        ])
    }
    
    private func bindCustomBar() {
        customBar.onTabSelected = { [weak self] tag in
            guard let self else { return }
            let index = tag < 2 ? tag : tag - 1
            self.selectedIndex = index
        }
        
        customBar.onFABTap = { [weak self] in
            self?.onFABTap?()
            self?.customBar.toggleFABState()
        }
    }
    
    func setCustomTabBar(hidden: Bool, animated: Bool) {
        let offset: CGFloat = hidden ? customBarHeight : 0
        customBarBottomConstraint?.constant = offset
        
        UIView.animate(withDuration: animated ? 0.3 : 0,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.customBar.alpha = hidden ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
}

//
//  TripStartViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.02.2026.
//

import UIKit

class TemplateListViewController: UIViewController {
    
    var onTemplateSelected: ((TripTemplate) -> Void)?
    
    private var templates: [TripTemplate]
    
    init(templates: [TripTemplate]) {
        self.templates = templates
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let categories = [
        ("beach",   "Beach",    "beach.umbrella"),
        ("mountain","Mountain", "mountain.2"),
        ("city",    "City",     "building.2"),
        ("forest",  "Forest",   "leaf"),
        ("desert",  "Desert",   "sun.max")
    ]
    
    private var selectedCategoryIndex = 0
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // Header
    private let headerView = UIView()
    private let exploreLabel: UILabel = {
        let l = UILabel()
        l.text = "EXPLORE THE WORLD"
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .systemGray
        l.letterSpacing(1.5)
        return l
    }()
    private let discoverLabel: UILabel = {
        let l = UILabel()
        l.text = "Discover"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .label
        return l
    }()
    private let notificationButton: UIButton = {
        let b = UIButton(type: .system)
        let img = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        b.setImage(img, for: .normal)
        b.tintColor = .label
        return b
    }()
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.red
        iv.layer.cornerRadius = 18
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return iv
    }()
    
    // Search
    private let searchContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.Colors.backgroundGray
        v.layer.cornerRadius = 14
        return v
    }()
    private let searchIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = AppTheme.Colors.textGray
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return iv
    }()
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search destinations..."
        tf.font = .systemFont(ofSize: 18)
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        return tf
    }()
    private let filterButton: UIButton = {
        let b = UIButton(type: .system)
        let img = UIImage(systemName: "slider.horizontal.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        b.setImage(img, for: .normal)
        b.tintColor = .label
        return b
    }()
    
    // Category collection
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 62, height: 80)
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        layout.sectionInset = .zero
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // Featured Tours
    private let featuredLabel: UILabel = {
        let l = UILabel()
        l.text = "Featured Tours"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = .label
        return l
    }()
    
    private let viewAllButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("View All", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.tintColor = UIColor(red: 0.08, green: 0.18, blue: 0.35, alpha: 1)
        return b
    }()
    
    private let toursStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 28
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        buildTourCards()
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        // Scroll
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
        
        // Header
        let headerStack = UIStackView(arrangedSubviews: [notificationButton, avatarImageView])
        headerStack.spacing = 12
        headerStack.alignment = .center
        
        let titleStack = UIStackView(arrangedSubviews: [exploreLabel, discoverLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 2
        
        let topBarStack = UIStackView(arrangedSubviews: [titleStack, headerStack])
        topBarStack.alignment = .center
        topBarStack.distribution = .equalSpacing
        topBarStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Search
        let searchStack = UIStackView(arrangedSubviews: [searchIconView, searchTextField, filterButton])
        searchStack.spacing = 10
        searchStack.alignment = .center
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchStack)
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchStack.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 16),
            searchStack.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -16),
            searchStack.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchStack.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16)
        ])
        
        // Featured header
        let featuredStack = UIStackView(arrangedSubviews: [featuredLabel, viewAllButton])
        featuredStack.distribution = .equalSpacing
        featuredStack.alignment = .center
        featuredStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topBarStack)
        contentView.addSubview(searchContainerView)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(featuredStack)
        contentView.addSubview(toursStackView)
        
        NSLayoutConstraint.activate([
            topBarStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topBarStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topBarStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            searchContainerView.topAnchor.constraint(equalTo: topBarStack.bottomAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryCollectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            featuredStack.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 24),
            featuredStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuredStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            toursStackView.topAnchor.constraint(equalTo: featuredStack.bottomAnchor, constant: 16),
            toursStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            toursStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            toursStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
    
    private func buildTourCards() {
        for (index, tour) in templates.enumerated() {
            let card = TourCardView(tour: tour)
            card.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(tourTapped(_:)))
            card.addGestureRecognizer(tap)
            card.isUserInteractionEnabled = true
            toursStackView.addArrangedSubview(card)
        }
    }
    
    // MARK: - Actions
    
    @objc private func tourTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag, index < templates.count else { return }
        let tour = templates[index]
        
        onTemplateSelected?(tour)
    }
}

    // MARK: - UICollectionView DataSource / Delegate

    extension TemplateListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            categories.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
            let cat = categories[indexPath.item]
            cell.configure(icon: cat.2, title: cat.1, isSelected: indexPath.item == selectedCategoryIndex)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedCategoryIndex = indexPath.item
            collectionView.reloadData()
        }
    }


  

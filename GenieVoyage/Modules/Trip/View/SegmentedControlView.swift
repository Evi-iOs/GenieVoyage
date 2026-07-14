//
//  SegmentControlView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 14.03.2025.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func didSelectSegment(at index: Int)
}

class SegmentedControlView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: SegmentedControlDelegate?
    private var items: [String]
    private var selectedIndex: Int = 0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SegmentCell.self, forCellWithReuseIdentifier: SegmentCell.identifier)
        return collectionView
    }()
    
    private let bottomDivider: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#EDEDED")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(collectionView)
        addSubview(bottomDivider)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func updateItems(_ newItems: [String], selectedIndex: Int = 0) {
        self.items = newItems
        self.selectedIndex = selectedIndex
        collectionView.reloadData()

        guard items.count > 0, selectedIndex < items.count else { return }

        let indexPath = IndexPath(item: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentCell.identifier, for: indexPath) as? SegmentCell else {
            return UICollectionViewCell()
        }
        cell.configure(text: items[indexPath.row], isSelected: indexPath.row == selectedIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectSegment(at: indexPath.row)
        delegate?.didSelectSegment(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = bounds.width / 3
        return CGSize(width: itemWidth, height: bounds.height)
    }

    func selectSegment(at index: Int) {
        selectedIndex = index
        collectionView.reloadData()

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (bounds.width / 3) / 2 
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}


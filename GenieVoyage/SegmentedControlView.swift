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
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SegmentCell.self, forCellWithReuseIdentifier: SegmentCell.identifier)
        return collectionView
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

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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


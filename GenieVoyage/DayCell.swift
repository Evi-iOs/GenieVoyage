//
//  DayCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.01.2025.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private var itineraryItems: [ItineraryEventModel] = []
    private var highlightedIndexPath: IndexPath?
    
    var viewModel: DayViewModel? {
        didSet {
            viewModel?.onUpdate = { [weak self] in
                self?.itineraryCollectionView.reloadData()
            }
            itineraryCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itineraryCollectionView)
        
        backgroundColor = .white
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            itineraryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            itineraryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itineraryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itineraryCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        itineraryCollectionView.showsVerticalScrollIndicator = false
        itineraryCollectionView.register(ItineraryEventCell.self, forCellWithReuseIdentifier: "ItineraryItemCell")
        itineraryCollectionView.addInteraction(UIDropInteraction(delegate: self))
        itineraryCollectionView.dataSource = self
        itineraryCollectionView.delegate = self
    }
    
    private let itineraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hours.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItineraryItemCell", for: indexPath) as! ItineraryEventCell
        let time = viewModel?.hours[indexPath.item] ?? ""
        let event = viewModel?.events.first(where: { $0.time == time })
        cell.configure(with: time, event: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

//MARK: Drag & drop icons
extension DayCell: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.items.first?.localObject is ItineraryEventModel
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        clearHighlight()
        
        guard let event = session.items.first?.localObject as? ItineraryEventModel else { return }
        
        let dropPoint = session.location(in: itineraryCollectionView)
        guard let indexPath = itineraryCollectionView.indexPathForItem(at: dropPoint) else { return }
        
        let timeSlot = viewModel?.hours[indexPath.item] ?? ""
        
        if viewModel?.hasEvent(at: timeSlot) == true {
            if let cell = itineraryCollectionView.cellForItem(at: indexPath) {
                viewModel?.shake(cell: cell)
            }
            viewModel?.showOccupiedSlotAlert()
            return
        }
        
        var newEvent = event
        newEvent = ItineraryEventModel(
            id: UUID(),
            category: event.category,
            icon: event.icon,
            time: timeSlot,
            duration: event.duration,
            location: event.location
        )
        viewModel?.addEvent(newEvent)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        clearHighlight()
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: itineraryCollectionView)
        guard let indexPath = itineraryCollectionView.indexPathForItem(at: dropLocation) else {
            clearHighlight()
            return UIDropProposal(operation: .cancel)
        }
        
        if indexPath == highlightedIndexPath {
            return UIDropProposal(operation: .copy)
        }
        
        clearHighlight()
        
        if let cell = itineraryCollectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            }
        }
        
        highlightedIndexPath = indexPath
        
        return UIDropProposal(operation: .copy)
    }
    
    private func clearHighlight() {
        if let indexPath = highlightedIndexPath,
           let cell = itineraryCollectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.contentView.backgroundColor = .clear
            }
        }
        highlightedIndexPath = nil
    }
}


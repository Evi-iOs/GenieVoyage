//
//  DayCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.01.2025.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    weak var dayCellDelegate: DayCellDelegate?
    
    private let titleLabel = UILabel()
    private var itineraryItems: [ItineraryEventModel] = []
    private var highlightedIndexPath: IndexPath?
    
    private var lastOffsetY: CGFloat = 0

    var viewModel: DayViewModel? {
        didSet {
            viewModel?.onUpdate = { [weak self] in
                self?.itineraryCollectionView.reloadData()
                self?.renderEventsOverlay()
            }
            
            itineraryCollectionView.reloadData()
            DispatchQueue.main.async {
                //self.scrollToStartHour()
            }
        }
    }
    
    private let eventOverlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itineraryCollectionView)
        itineraryCollectionView.addSubview(eventOverlayView)
       // itineraryCollectionView.bringSubviewToFront(eventOverlayView)
        itineraryCollectionView.addInteraction(UIDropInteraction(delegate: self))
        
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
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            itineraryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            itineraryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itineraryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itineraryCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            eventOverlayView.leadingAnchor.constraint(equalTo: itineraryCollectionView.leadingAnchor),
            eventOverlayView.trailingAnchor.constraint(equalTo: itineraryCollectionView.trailingAnchor),
            eventOverlayView.topAnchor.constraint(equalTo: itineraryCollectionView.topAnchor),
            eventOverlayView.bottomAnchor.constraint(equalTo: itineraryCollectionView.bottomAnchor)
        ])
        
        itineraryCollectionView.showsVerticalScrollIndicator = false
        itineraryCollectionView.register(ItineraryEventCell.self, forCellWithReuseIdentifier: "ItineraryItemCell")
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
    
    private func scrollToStartHour() {
        guard let hours = viewModel?.hours, let index = hours.firstIndex(of: "08:00"),
              itineraryCollectionView.numberOfItems(inSection: 0) > index else { return }
        
        let indexPath = IndexPath(item: index, section: 0)
        itineraryCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let scrollingUp = currentOffsetY < lastOffsetY
        dayCellDelegate?.dayCellDidScroll(upward: scrollingUp)
        lastOffsetY = currentOffsetY
    }
    
    func renderEventsOverlay() {
        eventOverlayView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let viewModel = viewModel else { return }
        
        for event in viewModel.events {
            let eventView = createEventView(for: event)
            eventView.translatesAutoresizingMaskIntoConstraints = false
            eventOverlayView.addSubview(eventView)
            eventOverlayView.bringSubviewToFront(eventView)
            
            let topOffset = CGFloat(event.startMinutes) / 15.0 * 20.0
            let height = CGFloat(event.duration) / 15.0 * 20.0

            NSLayoutConstraint.activate([
                eventView.topAnchor.constraint(equalTo: eventOverlayView.topAnchor, constant: topOffset),
                eventView.leadingAnchor.constraint(equalTo: eventOverlayView.leadingAnchor, constant: 60),
                eventView.trailingAnchor.constraint(equalTo: eventOverlayView.trailingAnchor, constant: -8),
                eventView.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
    func createEventView(for event: ItineraryEventModel) -> UIView {
        let container = UIView()
        container.backgroundColor = event.category.color.withAlphaComponent(0.5)
        container.layer.cornerRadius = 8
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        container.clipsToBounds = false
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: event.icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = event.locationName ?? "Event"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1

        let hStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            hStack.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -4)
        ])

        return container
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
        
        if let event = session.items.first?.localObject as? ItineraryEventModel {
            dayCellDelegate?.dayCell(self, didDropEventWith: event.category, at: timeSlot)
        }
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




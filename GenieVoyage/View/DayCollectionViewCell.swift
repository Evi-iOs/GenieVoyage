//
//  DayCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.01.2025.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    weak var dayCellDelegate: DayCellDelegate?
    
    static let reuseIdentifier = "ItineraryItemCell"
    
    private var itineraryItems: [EventModel] = []
    private var highlightedIndexPath: IndexPath?
    
    private var lastOffsetY: CGFloat = 0
        
    var viewModel: DayViewModel? {
        didSet {
            viewModel?.onUpdate = { [weak self] in
                guard let self = self else { return }
                self.itineraryCollectionView.reloadData()
                DispatchQueue.main.async {
                    self.itineraryCollectionView.layoutIfNeeded()
                    
                    self.eventContainerView.frame = CGRect(x: 0, y: 0, width: self.itineraryCollectionView.bounds.width, height: self.itineraryCollectionView.contentSize.height)
                    
                    self.renderEventsOverlay()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eventContainerView.frame = CGRect(x: 0, y: 0, width: itineraryCollectionView.frame.width, height: itineraryCollectionView.contentSize.height)
    }
    
    private let eventContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = true
        view.clipsToBounds = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itineraryCollectionView)
        itineraryCollectionView.addSubview(eventContainerView)
        itineraryCollectionView.bringSubviewToFront(eventContainerView)
        itineraryCollectionView.addInteraction(UIDropInteraction(delegate: self))
        
        backgroundColor = .white
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        itineraryCollectionView.addGestureRecognizer(longPressGesture)
        
        NSLayoutConstraint.activate([
            itineraryCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            itineraryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itineraryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itineraryCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        itineraryCollectionView.showsVerticalScrollIndicator = false
        itineraryCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
        itineraryCollectionView.dataSource = self
        itineraryCollectionView.delegate = self
    }
    
    private let itineraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
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
        eventContainerView.subviews.forEach { $0.removeFromSuperview() }
        guard let viewModel = viewModel else { return }
        for event in viewModel.events {
            let eventView = createEventView(for: event)
            eventContainerView.addSubview(eventView)
        }
    }
    
    func createEventView(for event: EventModel) -> EventView {
        let eventView = EventView(event: event)
        
        let yPosition = CGFloat(event.startMinutes) * minuteHeight
        let height = CGFloat(event.duration) * minuteHeight
        
        eventContainerView.addSubview(eventView)
        eventView.attachConstraints(to: eventContainerView, top: yPosition, height: height)
        
        eventView.onMove = { [weak eventView] deltaY in
            guard let eventView = eventView else { return }
            if let top = eventView.topConstraint {
                top.constant += deltaY
            }
        }
        
        eventView.onMoveEnd = { [weak self, weak eventView] in
            guard let self = self, let eventView = eventView, let viewModel = viewModel, let top = eventView.topConstraint else { return }
            
            let newY = top.constant
            let newStartMinutes = Int(round(newY / minuteHeight))
            let deltaMinutes = newStartMinutes - event.startMinutes
            
            guard deltaMinutes != 0 else {
                eventView.setLayout(top: CGFloat(event.startMinutes) * minuteHeight, height: CGFloat(event.duration) * minuteHeight, animated: true)
                return
            }
            
            viewModel.moveEvent(event.id, byMinutes: deltaMinutes)
            self.renderEventsOverlay()
        }
        
        eventView.onResize = { [weak eventView] deltaY in
            guard let eventView = eventView else { return }
            if let height = eventView.heightConstraint {
                let newHeight = max(height.constant + deltaY, minuteHeight * 15)
                height.constant = newHeight
            }
        }
        
        eventView.onResizeEnd = { [weak self, weak eventView] in
            guard let self = self, let eventView = eventView, let viewModel = viewModel else { return }
            
            guard let height = eventView.heightConstraint else { return }
            let newDuration = Int(round(height.constant / minuteHeight))
            
            guard newDuration != event.duration else {
                eventView.setLayout(top: CGFloat(event.startMinutes) * minuteHeight, height: CGFloat(event.duration) * minuteHeight, animated: true)
                return
            }
            
            viewModel.resizeEvent(event.id, toMinutes: newDuration)
            self.renderEventsOverlay()
        }
        
        eventView.onTap = { [weak self] in
            guard let self = self else { return }
            self.dayCellDelegate?.dayCell(self, didRequestOpenEvent: event)
        }
        return eventView
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        let point = gesture.location(in: itineraryCollectionView)

        guard let indexPath = itineraryCollectionView.indexPathForItem(at: point),
              let viewModel = viewModel else { return }

        let hourString = viewModel.hours[indexPath.item]
        
        let components = hourString.split(separator: ":").compactMap { Int($0) }
        let startMinutes = components[0] * 60 + components[1]
        
        dayCellDelegate?.dayCell(self, didRequestAddEventAt: startMinutes)
    }

}

extension DayCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hours.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as! EventCollectionViewCell
        let time = viewModel?.hours[indexPath.item] ?? ""
        cell.configure(with: time)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height: CGFloat = minuteHeight * 60
        return CGSize(width: width, height: height)
    }
}

//MARK: Drag & drop icons
extension DayCollectionViewCell: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.items.first?.localObject is EventModel
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
        
        if let event = session.items.first?.localObject as? EventModel {
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




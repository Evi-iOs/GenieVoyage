//
//  DayCell.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.01.2025.
//

import UIKit

class DayCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let titleLabel = UILabel()
    private var itineraryCollectionView: UICollectionView!
    private var itineraryItems: [ItineraryItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: frame.width - 20, height: 50)
        layout.minimumLineSpacing = 8
        
        itineraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        itineraryCollectionView.backgroundColor = .clear
        itineraryCollectionView.showsVerticalScrollIndicator = false
        itineraryCollectionView.dataSource = self
        itineraryCollectionView.delegate = self
        itineraryCollectionView.register(ItineraryItemCell.self, forCellWithReuseIdentifier: "ItineraryItemCell")
        itineraryCollectionView.addInteraction(UIDropInteraction(delegate: self))

        contentView.addSubview(itineraryCollectionView)
        itineraryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itineraryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            itineraryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itineraryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itineraryCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: TripDay) {
        titleLabel.text = "Weather +15°C"
        itineraryItems = day.itineraryItems
        itineraryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itineraryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItineraryItemCell", for: indexPath) as! ItineraryItemCell
        cell.configure(with: itineraryItems[indexPath.item])
        return cell
    }
}

//MARK: Drag & drop icons
extension DayCell: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: itineraryCollectionView)
        
        // Сбрасываем подсветку у всех видимых ячеек
        for cell in itineraryCollectionView.visibleCells {
            cell.contentView.backgroundColor = .white
        }
        
        // Определяем, над какой ячейкой находится курсор
        if let indexPath = itineraryCollectionView.indexPathForItem(at: dropLocation),
           let cell = itineraryCollectionView.cellForItem(at: indexPath) as? ItineraryItemCell {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3) // Подсветка активной ячейки
        }
        
        return UIDropProposal(operation: .move) // Разрешаем перемещение
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let dropLocation = session.location(in: itineraryCollectionView)
        
        guard let indexPath = itineraryCollectionView.indexPathForItem(at: dropLocation),
              let cell = itineraryCollectionView.cellForItem(at: indexPath) as? ItineraryItemCell else { return }
        
        // Достаём переданный imageView
        if let dragItem = session.items.first,
           let draggedImageView = dragItem.localObject as? UIImageView {
            
            // Добавляем imageView в ячейку
            let newImageView = UIImageView(image: draggedImageView.image)
            newImageView.frame = draggedImageView.frame
            cell.contentView.addSubview(newImageView)
            draggedImageView.center = CGPoint(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.midY)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        let dropLocation = session.location(in: itineraryCollectionView)
        if let indexPath = itineraryCollectionView.indexPathForItem(at: dropLocation),
           let cell = itineraryCollectionView.cellForItem(at: indexPath) as? ItineraryItemCell {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3) // Подсвечиваем
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        for cell in itineraryCollectionView.visibleCells {
            cell.contentView.backgroundColor = .white // Убираем подсветку
        }
    }
}


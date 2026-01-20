//
//  TripListViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 09.06.2025.
//

import UIKit
import Combine

final class TripListViewController: UIViewController {
    
    var onTripSelected: ((TripModel) -> Void)?
    var startPlanningSelected: (() -> Void)?

    enum Section: Int, CaseIterable {
        case templates
        case myTrips
    }

    private let viewModel: TripListViewModel
    private var templates: [TripTemplate] = TripTemplate.sampleTemplates()
    private var myTrips: [TripModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TripListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trips"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrip))
        navigationController?.navigationBar.tintColor = .darkGray
        setupCollectionView()
        bindViewModel()
        loadMyTrips()
    }
    
    private func bindViewModel() {
        viewModel.$trips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trips in
                self?.myTrips = trips
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }

            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            headerItem.pinToVisibleBounds = false

            switch sectionType {
            case .templates:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(200)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 7, bottom: 12, trailing: 7)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [item])
                group.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = .init(top: 0, leading: 16, bottom: 32, trailing: 16)
                section.boundarySupplementaryItems = [headerItem]
                return section

            case .myTrips:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160)), subitems: [item])
                group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 32, trailing: 16)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TemplateCell.self, forCellWithReuseIdentifier: "TemplateCell")
        collectionView.register(MyTripCell.self, forCellWithReuseIdentifier: "MyTripCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func addTrip() {
        self.startPlanningSelected?()
    }
    
    func addNewTrip(trip: TripModel) {
        if myTrips.contains(where: { $0.id == trip.id }) {
            if let index = myTrips.firstIndex(where: { $0.id == trip.id }) {
                myTrips[index] = trip
            }
        } else {
            myTrips.append(trip)
            Task {
                await self.viewModel.addTrip(trip)
            }
        }
        collectionView.reloadData()
    }
    
    func reloadTrips() {
        collectionView.reloadData()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point),
              let section = Section(rawValue: indexPath.section),
              section == .myTrips else {
            return
        }
        
        let trip = myTrips[indexPath.item]
        
        let alert = UIAlertController(title: "Delete Trip",
                                      message: "Are you sure you want to delete \"\(trip.title)\"?",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            Task {
                await self?.viewModel.removeTrip(trip)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func loadMyTrips() {
        Task {
            await viewModel.loadTrips()
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension TripListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .templates: return templates.count
        case .myTrips: return myTrips.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .templates:
            guard indexPath.item < templates.count,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCell", for: indexPath) as? TemplateCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: templates[indexPath.item])
            return cell

        case .myTrips:
            guard indexPath.item < myTrips.count,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyTripCell", for: indexPath) as? MyTripCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: myTrips[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .templates:
            _ = templates[indexPath.item]
            break
        case .myTrips:
            let trip = myTrips[indexPath.item]
            onTripSelected?(trip)
            break
        default:
            break
        }
    }

    // MARK: - Headers

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: "HeaderView",
                                                                      for: indexPath) as! HeaderView
        switch Section(rawValue: indexPath.section) {
        case .templates:
            header.title = "Templates for You"
        case .myTrips:
            header.title = "My Trips"
        default:
            break
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

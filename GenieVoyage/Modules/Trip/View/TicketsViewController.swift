//
//  TicketsViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 20.04.2026.
//

import UIKit

struct TicketFileDisplayItem {
    let file: TicketFileModel
    let sourceLabel: String?
}

final class TicketsViewController: UIViewController, FilePickerPresentable {
    
    var onAddFile: ((URL) -> Void)?
    
    private let viewModel: TicketsViewModel

    init(viewModel: TicketsViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .systemBackground
           navigationController?.setNavigationBarHidden(true, animated: false)
           tableView.dataSource = self
           tableView.delegate = self
           bindViewModel()
           setupLayout()
           setupActions()
       }
    
    private var ticketFiles: [TicketFileModel] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            Task { await viewModel.loadFiles() }
        }
    
    private func bindViewModel() {
            viewModel.onItemsUpdated = { [weak self] in
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
        
    private func updateEmptyState() {
        let isEmpty = viewModel.numberOfItems == 0
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        tableViewHeightConstraint.constant = isEmpty ? 0 : CGFloat(viewModel.numberOfItems) * TicketFileCell.rowHeight
        
        guard isEmpty else { return }
        
        if viewModel.isSearchActive {
            emptyStateIconView.image = UIImage(
                systemName: "magnifyingglass",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 52, weight: .light)
            )
            emptyStateTitleLabel.text = "No results"
            emptyStateSubtitleLabel.text = "Try a different search term"
            emptyStateUploadButton.isHidden = true
        } else {
            emptyStateIconView.image = UIImage(
                systemName: "doc.badge.plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 52, weight: .light)
            )
            emptyStateTitleLabel.text = "No tickets yet"
            emptyStateSubtitleLabel.text = "Add your flight, hotel confirmation\nor personal documents"
            emptyStateUploadButton.isHidden = false
        }
    }
    
    private var displayItems: [TicketFileDisplayItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }
    
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
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Tickets"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .label
        return l
    }()
    
    private let addButton: UIButton = {
        let b = UIButton(type: .system)
        let cfg = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        b.setImage(UIImage(systemName: "plus", withConfiguration: cfg), for: .normal)
        b.tintColor = .label
        return b
    }()
    
    private let searchContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.Colors.backgroundGray
        v.layer.cornerRadius = 14
        v.translatesAutoresizingMaskIntoConstraints = false
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
        tf.placeholder = "Find a trip or document..."
        tf.font = .systemFont(ofSize: 18)
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        return tf
    }()
    
    private let clearButton: UIButton = {
        let b = UIButton(type: .system)
        let cfg = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        b.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: cfg), for: .normal)
        b.tintColor = AppTheme.Colors.textGray
        b.isHidden = true
        return b
    }()
    
    private let emptyStateView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let emptyStateIconView: UIImageView = {
            let iv = UIImageView()
            let cfg = UIImage.SymbolConfiguration(pointSize: 52, weight: .light)
            iv.image = UIImage(systemName: "doc.badge.plus", withConfiguration: cfg)
            iv.tintColor = AppTheme.Colors.textGray
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        private let emptyStateTitleLabel: UILabel = {
            let l = UILabel()
            l.font = .systemFont(ofSize: 20, weight: .semibold)
            l.textColor = .label
            l.textAlignment = .center
            return l
        }()
        
        private let emptyStateSubtitleLabel: UILabel = {
            let l = UILabel()
            l.font = .systemFont(ofSize: 15)
            l.textColor = AppTheme.Colors.textGray
            l.textAlignment = .center
            l.numberOfLines = 2
            return l
        }()
        
        private let emptyStateUploadButton: UIButton = {
            let b = UIButton(type: .system)
            b.setTitle("Upload PDF", for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            b.setTitleColor(.white, for: .normal)
            b.backgroundColor = AppTheme.Colors.primaryDarkBlue
            b.layer.cornerRadius = 16
            b.translatesAutoresizingMaskIntoConstraints = false
            return b
        }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.register(TicketFileCell.self, forCellReuseIdentifier: TicketFileCell.reuseID)
        return tv
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private func setupLayout() {
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
        
        let navStack = UIStackView(arrangedSubviews: [titleLabel, addButton])
        navStack.distribution = .equalSpacing
        navStack.alignment = .center
        navStack.translatesAutoresizingMaskIntoConstraints = false
        
        let searchStack = UIStackView(arrangedSubviews: [searchIconView, searchTextField, clearButton])
        searchStack.spacing = 10
        searchStack.alignment = .center
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchStack)
        NSLayoutConstraint.activate([
            searchStack.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 16),
            searchStack.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -16),
            searchStack.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchStack.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16)
        ])
        
        buildEmptyState()
        
        contentView.addSubview(navStack)
        contentView.addSubview(searchContainerView)
        contentView.addSubview(tableView)
        contentView.addSubview(emptyStateView)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            navStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            navStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            navStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            searchContainerView.topAnchor.constraint(equalTo: navStack.bottomAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emptyStateView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 60),
            emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func buildEmptyState() {
        emptyStateTitleLabel.text = "No tickets yet"
        emptyStateSubtitleLabel.text = "Add your flight, hotel confirmation\nor personal documents"
        emptyStateUploadButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            emptyStateIconView,
            emptyStateTitleLabel,
            emptyStateSubtitleLabel,
            emptyStateUploadButton
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.setCustomSpacing(24, after: emptyStateSubtitleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.addSubview(stack)
        NSLayoutConstraint.activate([
            emptyStateIconView.heightAnchor.constraint(equalToConstant: 72),
            stack.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
            stack.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: emptyStateView.leadingAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: emptyStateView.trailingAnchor),
            emptyStateUploadButton.heightAnchor.constraint(equalToConstant: 50),
            emptyStateUploadButton.widthAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    // MARK: - Actions
       
       @objc private func addTapped() {
           presentFilePicker { [weak self] url in
               guard let self else { return }
               Task { await self.viewModel.addFile(from: url) }
           }
       }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearSearchTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
    }
    
    @objc private func searchChanged() {
        let text = searchTextField.text ?? ""
        clearButton.isHidden = text.isEmpty
        viewModel.updateSearch(query: text)
    }

    @objc private func clearSearchTapped() {
        searchTextField.text = ""
        clearButton.isHidden = true
        searchTextField.resignFirstResponder()
        viewModel.clearSearch()
    }
}

// MARK: - UITableViewDataSource / Delegate

extension TicketsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TicketFileCell.reuseID, for: indexPath) as! TicketFileCell
        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item.file, sourceLabel: item.sourceLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TicketFileCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedPDFURL = viewModel.fileURL(at: indexPath.row)
        showPDFPreview()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else { return }
            Task {
                await self.viewModel.deleteFile(at: indexPath.row)
                completion(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - TicketFileCell

final class TicketFileCell: UITableViewCell {
    
    static let reuseID = "TicketFileCell"
    static let rowHeight: CGFloat = 68
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.Colors.backgroundGray
        v.layer.cornerRadius = 14
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppTheme.Colors.primaryDarkBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let sourceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = AppTheme.Colors.textGray
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let chevronView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = AppTheme.Colors.textGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        sourceLabel.text = nil
        iconView.image = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(sourceLabel)
        cardView.addSubview(chevronView)
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, sourceLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            textStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: chevronView.leadingAnchor, constant: -8),
            
            chevronView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            chevronView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 14),
            chevronView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configure(with file: TicketFileModel, sourceLabel: String?) {
        nameLabel.text = file.fileName
        let cfg = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let symbolName = file.fileType == "pdf" ? "doc.text.fill" : "photo.fill"
        iconView.image = UIImage(systemName: symbolName, withConfiguration: cfg)
        
        if let label = sourceLabel {
            self.sourceLabel.text = label
            self.sourceLabel.isHidden = false
        } else {
            self.sourceLabel.isHidden = true
        }
    }
}

//
//  TemplateListViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 05.07.2026.
//

import Foundation

final class TemplateListViewModel {
    
    private let categories: [(key: String, title: String, iconName: String)] = [
        ("beach",   "Beach",    "beach.umbrella"),
        ("mountain","Mountain", "mountain.2"),
        ("city",    "City",     "building.2"),
        ("forest",  "Forest",   "leaf"),
        ("desert",  "Desert",   "sun.max")
    ]
    
    private var categoryTemplates: [TripTemplate]
    
    private(set) var displayTemplates: [TripTemplate] {
        didSet { onTemplatesUpdated?() }
    }
    
    private(set) var selectedCategoryIndex: Int = 0
    private var searchQuery: String = ""
    
    var onTemplatesUpdated: (() -> Void)?
    
    init(templates: [TripTemplate] = TripTemplate.allTemplates) {
        self.categoryTemplates = templates
        self.displayTemplates = templates
    }
    
    // MARK: - Categories
    
    var numberOfCategories: Int { categories.count }
    
    func category(at index: Int) -> (title: String, iconName: String) {
        (categories[index].title, categories[index].iconName)
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        index == selectedCategoryIndex
    }
    
    func selectCategory(at index: Int) {
        selectedCategoryIndex = index
        let key = categories[index].key
        categoryTemplates = TripTemplate.templates(for: key)
        applySearch()
    }
    
    func selectAllCategories() {
        selectedCategoryIndex = -1
        categoryTemplates = TripTemplate.allTemplates
        applySearch()
    }
    
    // MARK: - Search
    
    func updateSearch(query: String) {
        searchQuery = query
        applySearch()
    }
    
    func clearSearch() {
        searchQuery = ""
        applySearch()
    }
    
    var isSearchActive: Bool {
        !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func applySearch() {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            displayTemplates = categoryTemplates
        } else {
            displayTemplates = categoryTemplates.filter { template in
                template.title.localizedCaseInsensitiveContains(trimmed) ||
                template.subtitle.localizedCaseInsensitiveContains(trimmed) ||
                template.locationName.localizedCaseInsensitiveContains(trimmed) ||
                template.durationLabel.localizedCaseInsensitiveContains(trimmed)
            }
        }
    }
    
    // MARK: - Access for VC
    
    var numberOfTemplates: Int { displayTemplates.count }
    
    func template(at index: Int) -> TripTemplate {
        displayTemplates[index]
    }
}

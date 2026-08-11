//
//  HelpSupportViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import UIKit

import MessageUI

final class HelpSupportViewController: UIViewController {
    
    private struct FAQItem {
        let question: String
        let answer: String
    }
    
    private let supportEmail = "support@genievoyage.com"
    
    private let faqItems: [FAQItem] = [
        FAQItem(question: "How do I create a trip?",
                answer: "Tap the + button on the Trips tab, then fill in your destination and dates, or start from a template."),
        FAQItem(question: "Can I attach tickets and documents?",
                answer: "Yes — open any trip, go to Tickets & Files, and tap the + button to add a photo or document."),
        FAQItem(question: "How do I delete my data?",
                answer: "Go to Profile → Delete All Data. This permanently removes all trips, events, and tickets."),
        FAQItem(question: "Is my data backed up?",
                answer: "Your data is stored locally on this device. We recommend keeping regular device backups."),
        FAQItem(question: "Can I use the app offline?",
                answer: "Yes — all your trips, events, and tickets are stored locally, so you can view and edit them without an internet connection.")
    ]
    
    private var expandedIndexPaths: Set<IndexPath> = []
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = AppTheme.Colors.backgroundGray
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 60
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Help & Support"
        view.backgroundColor = AppTheme.Colors.backgroundGray
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FAQCell.self, forCellReuseIdentifier: FAQCell.reuseID)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseID)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func openMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.setToRecipients([supportEmail])
            composer.setSubject("Support Request")
            composer.mailComposeDelegate = self
            present(composer, animated: true)
        } else if let url = URL(string: "mailto:\(supportEmail)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let alert = UIAlertController(
                title: "No Mail Account",
                message: "Please set up a Mail account on this device, or reach us directly at \(supportEmail).",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension HelpSupportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? faqItems.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "FAQ" : "Contact"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FAQCell.reuseID, for: indexPath) as! FAQCell
            let item = faqItems[indexPath.row]
            cell.configure(question: item.question, answer: item.answer, isExpanded: expandedIndexPaths.contains(indexPath))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath) as! ContactCell
            cell.configure(title: "Email Support", subtitle: supportEmail)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if expandedIndexPaths.contains(indexPath) {
                expandedIndexPaths.remove(indexPath)
            } else {
                expandedIndexPaths.insert(indexPath)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            openMailComposer()
        }
    }
}

extension HelpSupportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

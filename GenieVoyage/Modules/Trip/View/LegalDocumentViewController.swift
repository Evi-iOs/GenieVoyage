//
//  LegalDocumentViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import UIKit

final class LegalDocumentViewController: UIViewController {
    
    private let docTitle: String
    private let content: String
    
    init(title: String, content: String) {
        self.docTitle = title
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 15)
        tv.textColor = UIColor(hex: "334155")
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = docTitle
        view.backgroundColor = .white
        textView.text = content
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

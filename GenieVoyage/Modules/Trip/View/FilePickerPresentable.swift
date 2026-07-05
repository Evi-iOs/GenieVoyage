//
//  FilePickerPresentable.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 13.05.2026.
//

import UIKit
import UniformTypeIdentifiers
import PhotosUI
import QuickLook

typealias FilePickerCompletion = (URL) -> Void

protocol FilePickerPresentable: UIViewController {
    func presentFilePicker(completion: @escaping FilePickerCompletion)
}

private enum FilePickerKeys {
    static var helper: UInt8 = 0
}

extension FilePickerPresentable {
    
    private var filePickerHelper: FilePickerHelper {
        if let existing = objc_getAssociatedObject(self, &FilePickerKeys.helper) as? FilePickerHelper {
            return existing
        }
        let helper = FilePickerHelper()
        objc_setAssociatedObject(self, &FilePickerKeys.helper, helper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return helper
    }
    
    var selectedPDFURL: URL? {
        get { filePickerHelper.selectedPDFURL }
        set { filePickerHelper.selectedPDFURL = newValue }
    }
    
    func presentFilePicker(completion: @escaping FilePickerCompletion) {
        filePickerHelper.completion = completion
        filePickerHelper.presentingViewController = self
        
        let alert = UIAlertController(title: "Add document", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Files", style: .default) { [weak self] _ in
            self?.filePickerHelper.presentDocumentPicker(from: self!)
        })
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
            self?.filePickerHelper.presentPhotoPicker(from: self!)
        })
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.filePickerHelper.presentCamera(from: self!)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad support
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    func showPDFPreview() {
        let previewController = QLPreviewController()
        previewController.dataSource = filePickerHelper
        present(previewController, animated: true)
    }
}

final class FilePickerHelper: NSObject, UIDocumentPickerDelegate, QLPreviewControllerDataSource, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var completion: FilePickerCompletion?
    var selectedPDFURL: URL?
    weak var presentingViewController: UIViewController?

    // MARK: - Files

    func presentDocumentPicker(from viewController: UIViewController) {
        let types: [UTType] = [.pdf, .image, .png, .jpeg]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        viewController.present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        let started = url.startAccessingSecurityScopedResource()
        completion?(url)
        completion = nil
        if started {
            url.stopAccessingSecurityScopedResource()
        }
    }

    // MARK: - Photo Library (PHPicker)

    func presentPhotoPicker(from viewController: UIViewController) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        viewController.present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self?.saveImageAndComplete(image)
            }
        }
    }

    // MARK: - Camera

    func presentCamera(from viewController: UIViewController) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        viewController.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        saveImageAndComplete(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Helpers

    private func saveImageAndComplete(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        let filename = "photo_\(UUID().uuidString).jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            completion?(url)
            completion = nil
        } catch {
            print("Failed to save picked photo: \(error)")
        }
    }

    // MARK: - QuickLook

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        selectedPDFURL == nil ? 0 : 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let pdfURL = selectedPDFURL else {
            fatalError("Expected non-nil selectedPDFURL")
        }
        return pdfURL as NSURL
    }
}

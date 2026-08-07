//
//  PDFReportGenerator.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import Foundation
import UIKit

// PDFReportGenerator.swift
// NOTE: adjust `trip.title` / `trip.destination` to whatever property your Trip model
// actually exposes for the trip name — I don't have that model's definition.
enum PDFReportGenerator {
    static func generate(trips: [TripModel], ticketsCount: Int) -> URL? {
        let pdfMeta = [kCGPDFContextCreator: "TravelApp", kCGPDFContextTitle: "Travel Data Export"]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMeta as [String: Any]
        
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 48
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("TravelDataExport-\(Int(Date().timeIntervalSince1970)).pdf")
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                var y: CGFloat = margin
                
                let titleAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 24)]
                "Travel Data Export".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
                y += 34
                
                let subAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.gray]
                "Generated \(dateFormatter.string(from: Date()))".draw(at: CGPoint(x: margin, y: y), withAttributes: subAttrs)
                y += 30
                
                let summaryAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
                "\(trips.count) trips  •  \(ticketsCount) tickets/files".draw(at: CGPoint(x: margin, y: y), withAttributes: summaryAttrs)
                y += 36
                
                let headerAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
                "Trips".draw(at: CGPoint(x: margin, y: y), withAttributes: headerAttrs)
                y += 26
                
                let rowAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
                for trip in trips {
                    if y > pageHeight - margin - 40 {
                        context.beginPage()
                        y = margin
                    }
                    let name = trip.title
                    let dates = "\(dateFormatter.string(from: trip.startDate)) – \(dateFormatter.string(from: trip.endDate))"
                    "\(name)".draw(at: CGPoint(x: margin, y: y), withAttributes: rowAttrs)
                    y += 16
                    dates.draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.gray])
                    y += 22
                }
            }
            return url
        } catch {
            print("PDF export failed: \(error)")
            return nil
        }
    }
}

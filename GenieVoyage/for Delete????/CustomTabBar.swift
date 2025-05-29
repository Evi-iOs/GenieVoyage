//
//  CustomTabBar.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 25.04.2025.
//

import UIKit

class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in subviews {
            if let imageView = subview.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                imageView.frame.size = CGSize(width: 35, height: 35)
                imageView.center = CGPoint(x: subview.bounds.midX, y: subview.bounds.midY)
            }
        }
    }
}

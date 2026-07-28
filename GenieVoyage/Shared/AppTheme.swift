//
//  AppTheme.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 19.03.2026.
//

import Foundation
import UIKit

enum AppTheme {

     enum TabBarLayout {
        static let height: CGFloat = 88
        static let fabSize: CGFloat = 56
        static let fabOffset: CGFloat = -14
        static let iconSize: CGFloat = 23
        static let labelFont = UIFont.systemFont(ofSize: 10, weight: .medium)
    }

    // MARK: - Colors

    enum Colors {
        // Primary
        static let primaryDarkBlue = UIColor(hex: "0F172A")   // основной тёмный
        static let accent         = UIColor(hex: "3B82F6")   // акцент (синий)
        static let accentDark     = UIColor(hex: "1D4ED8")

        // Background
        static let backgroundGray = UIColor(white: 0.97, alpha: 1)
        static let surface        = UIColor.white
        static let grayFill  = UIColor(hex: "64748B")

        // Text
        static let textPrimary    = UIColor(hex: "0F172A")
        static let textSecondary  = UIColor(hex: "64748B")
        static let textGray       = UIColor.systemGray
        static let textOnDark     = UIColor.white

        // Status
        static let success        = UIColor(hex: "22C55E")
        static let warning        = UIColor(hex: "F59E0B")
        static let error          = UIColor(hex: "EF4444")

        // Border
        static let border         = UIColor(hex: "E2E8F0")
        static let borderStrong   = UIColor(hex: "CBD5E1")

        // Tab bar
        static let tabActive      = UIColor(hex: "0F172A")
        static let tabInactive    = UIColor(hex: "94A3B8")
    }

    // MARK: - Typography

    enum Fonts {
        // Display
        static let largeTitle  = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1      = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2      = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let title3      = UIFont.systemFont(ofSize: 20, weight: .semibold)

        // Body
        static let bodyLarge   = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let body        = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let bodySmall   = UIFont.systemFont(ofSize: 13, weight: .regular)

        // Labels
        static let labelLarge  = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let label       = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let labelSmall  = UIFont.systemFont(ofSize: 11, weight: .medium)

        // Caption
        static let caption     = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let captionBold = UIFont.systemFont(ofSize: 12, weight: .semibold)
        static let overline    = UIFont.systemFont(ofSize: 10, weight: .semibold)  // uppercase labels
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs:  CGFloat = 4
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum Radius {
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 12
        static let lg:  CGFloat = 16
        static let xl:  CGFloat = 24
        static let pill: CGFloat = 999
    }

    // MARK: - Shadows

    enum Shadow {
        static func apply(_ layer: CALayer, style: ShadowStyle) {
            layer.shadowColor   = style.color
            layer.shadowOffset  = style.offset
            layer.shadowRadius  = style.radius
            layer.shadowOpacity = style.opacity
            layer.masksToBounds = false
        }

        enum ShadowStyle {
            case sm, md, lg, accent

            var color: CGColor {
                switch self {
                case .accent: return UIColor(hex: "0F172A").withAlphaComponent(0.3).cgColor
                default:      return UIColor.black.cgColor
                }
            }
            var offset: CGSize {
                switch self {
                case .sm:     return CGSize(width: 0, height: 2)
                case .md:     return CGSize(width: 0, height: 4)
                case .lg:     return CGSize(width: 0, height: 8)
                case .accent: return CGSize(width: 0, height: 6)
                }
            }
            var radius: CGFloat {
                switch self {
                case .sm:     return 4
                case .md:     return 8
                case .lg:     return 16
                case .accent: return 14
                }
            }
            var opacity: Float {
                switch self {
                case .sm:     return 0.05
                case .md:     return 0.08
                case .lg:     return 0.12
                case .accent: return 0.40
                }
            }
        }
    }
}

// MARK: - UIView Theme Helpers

extension UIView {
    func applyCardStyle(radius: CGFloat = AppTheme.Radius.lg) {
        backgroundColor    = AppTheme.Colors.surface
        layer.cornerRadius = radius
        AppTheme.Shadow.apply(layer, style: .md)
    }
}

extension UILabel {
    func applyStyle(_ font: UIFont, color: UIColor = AppTheme.Colors.textPrimary) {
        self.font      = font
        self.textColor = color
    }
}

extension UIButton {
    /// Основная кнопка — тёмный фон, белый текст
    func applyPrimaryStyle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font  = AppTheme.Fonts.labelLarge
        setTitleColor(AppTheme.Colors.textOnDark, for: .normal)
        backgroundColor = AppTheme.Colors.primaryDarkBlue
        layer.cornerRadius = AppTheme.Radius.md
        AppTheme.Shadow.apply(layer, style: .accent)
    }

    /// Вторичная кнопка — обводка, прозрачный фон
    func applySecondaryStyle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font  = AppTheme.Fonts.labelLarge
        setTitleColor(AppTheme.Colors.primaryDarkBlue, for: .normal)
        backgroundColor   = .clear
        layer.cornerRadius = AppTheme.Radius.md
        layer.borderWidth  = 1.5
        layer.borderColor  = AppTheme.Colors.borderStrong.cgColor
    }
}

//
//  MapPlaceholderView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 30.03.2026.
//


import UIKit

final class MapPlaceholderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "D4EAD8")
    }
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        // Фон
        UIColor(hex: "D4EAD8").setFill()
        ctx.fill(rect)

        // Сетка
        UIColor.white.withAlphaComponent(0.6).setStroke()
        ctx.setLineWidth(0.5)
        var x: CGFloat = 0
        while x < rect.width { ctx.move(to: CGPoint(x: x, y: 0)); ctx.addLine(to: CGPoint(x: x, y: rect.height)); x += 20 }
        var y: CGFloat = 0
        while y < rect.height { ctx.move(to: CGPoint(x: 0, y: y)); ctx.addLine(to: CGPoint(x: rect.width, y: y)); y += 20 }
        ctx.strokePath()

        // Маршрут
        UIColor(hex: "0F172A").withAlphaComponent(0.5).setStroke()
        ctx.setLineWidth(2)
        ctx.setLineDash(phase: 0, lengths: [6, 4])
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.width * 0.15, y: rect.height * 0.7))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.85, y: rect.height * 0.3),
            control1: CGPoint(x: rect.width * 0.35, y: rect.height * 0.5),
            control2: CGPoint(x: rect.width * 0.6,  y: rect.height * 0.2)
        )
        ctx.addPath(path)
        ctx.strokePath()

        // Точки маршрута
        ctx.setLineDash(phase: 0, lengths: [])
        let pins = [
            CGPoint(x: rect.width * 0.15, y: rect.height * 0.7),
            CGPoint(x: rect.width * 0.5,  y: rect.height * 0.42),
            CGPoint(x: rect.width * 0.85, y: rect.height * 0.3)
        ]
        for pin in pins {
            UIColor(hex: "0F172A").setFill()
            ctx.fillEllipse(in: CGRect(x: pin.x - 5, y: pin.y - 5, width: 10, height: 10))
            UIColor.white.setFill()
            ctx.fillEllipse(in: CGRect(x: pin.x - 2.5, y: pin.y - 2.5, width: 5, height: 5))
        }

        // Центральная синяя точка (текущая позиция)
        UIColor(hex: "3B82F6").setFill()
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        ctx.fillEllipse(in: CGRect(x: center.x - 6, y: center.y - 6, width: 12, height: 12))
        UIColor.white.setFill()
        ctx.fillEllipse(in: CGRect(x: center.x - 3, y: center.y - 3, width: 6, height: 6))
    }
}

//
//  PreviewTemplateViewController.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 11.02.2026.
//

import UIKit

final class PreviewTemplateViewController: UIViewController {

    private let trip: TripTemplate
    private var selectedDayIndex = 0

    private let heroBaseHeight: CGFloat = 450
    private var heroHeightConstraint: NSLayoutConstraint!
    private var heroTopConstraint: NSLayoutConstraint!

    init(trip: TripTemplate) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        sv.backgroundColor = UIColor(hex: "F1F5F9")
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "F1F5F9")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(hex: "1A3550")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let heroGradient: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.clear.cgColor,
                    UIColor(hex: "0F172A").withAlphaComponent(0.0).cgColor,
                    UIColor(hex: "0F172A").withAlphaComponent(0.5).cgColor]
        g.locations = [0.25, 0.55, 1.0]
        return g
    }()

    private let locationBadge: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let locationLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let heroTitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        l.textColor = .white
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let heroSubtitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        l.textColor = UIColor.white.withAlphaComponent(0.80)
        l.numberOfLines = 3
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let navContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var backBtn = makeCircleButton("chevron.left")
    private lazy var favButton = makeCircleButton(trip.isFavorite ? "heart.fill" : "heart", tint: trip.isFavorite ? UIColor(hex: "EF4444") : UIColor(hex: "0F172A"))

    private let card: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let ratingCol = StatCol()
    private let durationCol = StatCol()
    private let levelCol = StatCol()

    // Days
    private lazy var daysScroll: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let daysStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal; sv.spacing = 8; sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // Timeline
    private let timelineTitleLbl: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(hex: "0F172A")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timelineStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical; sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    //
    private let routeCard = RouteCardView()

    private lazy var addTripButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Add Trip", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = AppTheme.Colors.primaryDarkBlue
        b.layer.cornerRadius = 18
        b.layer.shadowColor = UIColor(red: 0.08, green: 0.18, blue: 0.35, alpha: 0.45).cgColor
        b.layer.shadowOffset = CGSize(width: 0, height: 6)
        b.layer.shadowRadius = 14
        b.layer.shadowOpacity = 1
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(addTripButtonTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F1F5F9")
        navigationController?.setNavigationBarHidden(true, animated: false)
        buildLayout()
        heroGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: heroBaseHeight)
        populate()
    }
    
    private func buildLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        contentView.addSubview(heroImageView)
        heroImageView.layer.addSublayer(heroGradient)

        heroTopConstraint = heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        heroHeightConstraint = heroImageView.heightAnchor.constraint(equalToConstant: heroBaseHeight)
        NSLayoutConstraint.activate([
            heroTopConstraint,
            heroHeightConstraint,
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // Badge inside hero
        let pinIV = UIImageView(image: UIImage(systemName: "mappin.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)))
        pinIV.tintColor = .white
        pinIV.setContentHuggingPriority(.required, for: .horizontal)
        let badgeRow = UIStackView(arrangedSubviews: [pinIV, locationLabel])
        badgeRow.spacing = 4; badgeRow.alignment = .center
        badgeRow.translatesAutoresizingMaskIntoConstraints = false
        locationBadge.addSubview(badgeRow)
        NSLayoutConstraint.activate([
            badgeRow.topAnchor.constraint(equalTo: locationBadge.topAnchor, constant: 5),
            badgeRow.bottomAnchor.constraint(equalTo: locationBadge.bottomAnchor, constant: -5),
            badgeRow.leadingAnchor.constraint(equalTo: locationBadge.leadingAnchor, constant: 10),
            badgeRow.trailingAnchor.constraint(equalTo: locationBadge.trailingAnchor, constant: -10)
        ])
        [locationBadge, heroTitleLabel, heroSubtitleLabel].forEach { heroImageView.addSubview($0) }
        NSLayoutConstraint.activate([
            locationBadge.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 18),
            locationBadge.bottomAnchor.constraint(equalTo: heroTitleLabel.topAnchor, constant: -10),
            heroTitleLabel.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 18),
            heroTitleLabel.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -18),
            heroTitleLabel.bottomAnchor.constraint(equalTo: heroSubtitleLabel.topAnchor, constant: -6),
            heroSubtitleLabel.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 18),
            heroSubtitleLabel.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -18),
            heroSubtitleLabel.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -28)
        ])

        contentView.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: heroImageView.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Stats
        let ld = vDiv(); let rd = vDiv()
        let statsRow = UIStackView(arrangedSubviews: [ratingCol, ld, durationCol, rd, levelCol])
        statsRow.distribution = .equalSpacing; statsRow.alignment = .center
        statsRow.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(statsRow)
        NSLayoutConstraint.activate([
            statsRow.topAnchor.constraint(equalTo: card.topAnchor, constant: 32),
            statsRow.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 28),
            statsRow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),
            statsRow.heightAnchor.constraint(equalToConstant: 52)
        ])

        let s1 = hLine()
        card.addSubview(s1)
        pin(s1, to: card, top: statsRow, topPad: 20)

        // Days header
        let tripDaysLbl = makeSectionLabel("Trip Days")
        let selectLbl   = makeTagLabel("SELECT DAY")
        let daysHdr     = hStack(tripDaysLbl, selectLbl)
        daysHdr.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(daysHdr)
        NSLayoutConstraint.activate([
            daysHdr.topAnchor.constraint(equalTo: s1.bottomAnchor, constant: 20),
            daysHdr.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            daysHdr.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])

        // Days scroll
        daysScroll.addSubview(daysStack)
        card.addSubview(daysScroll)
        NSLayoutConstraint.activate([
            daysScroll.topAnchor.constraint(equalTo: daysHdr.bottomAnchor, constant: 14),
            daysScroll.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            daysScroll.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            daysScroll.heightAnchor.constraint(equalToConstant: 68),
            daysStack.topAnchor.constraint(equalTo: daysScroll.topAnchor),
            daysStack.bottomAnchor.constraint(equalTo: daysScroll.bottomAnchor),
            daysStack.leadingAnchor.constraint(equalTo: daysScroll.leadingAnchor),
            daysStack.trailingAnchor.constraint(equalTo: daysScroll.trailingAnchor),
            daysStack.heightAnchor.constraint(equalTo: daysScroll.heightAnchor)
        ])

        // Sep 2
        let s2 = hLine()
        card.addSubview(s2)
        NSLayoutConstraint.activate([
            s2.topAnchor.constraint(equalTo: daysScroll.bottomAnchor, constant: 20),
            s2.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            s2.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])

        // Timeline header
        card.addSubview(timelineTitleLbl)
        NSLayoutConstraint.activate([
            timelineTitleLbl.topAnchor.constraint(equalTo: s2.bottomAnchor, constant: 20),
            timelineTitleLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            timelineTitleLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])

        // Timeline
        card.addSubview(timelineStack)
        NSLayoutConstraint.activate([
            timelineStack.topAnchor.constraint(equalTo: timelineTitleLbl.bottomAnchor, constant: 20),
            timelineStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            timelineStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])

        // Route
        routeCard.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(routeCard)
        NSLayoutConstraint.activate([
            routeCard.topAnchor.constraint(equalTo: timelineStack.bottomAnchor, constant: 28),
            routeCard.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            routeCard.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            routeCard.heightAnchor.constraint(equalToConstant: 200),
            routeCard.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -130)
        ])

        // Bottom
        card.addSubview(addTripButton)
        NSLayoutConstraint.activate([
            addTripButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            addTripButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            addTripButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -35),
            addTripButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(navContainer)
        [backBtn, favButton].forEach { navContainer.addSubview($0) }
        NSLayoutConstraint.activate([
            navContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navContainer.heightAnchor.constraint(equalToConstant: 50),
            backBtn.leadingAnchor.constraint(equalTo: navContainer.leadingAnchor, constant: 16),
            backBtn.centerYAnchor.constraint(equalTo: navContainer.centerYAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),
            favButton.trailingAnchor.constraint(equalTo: navContainer.trailingAnchor, constant: -16),
            favButton.centerYAnchor.constraint(equalTo: navContainer.centerYAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 36),
            favButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        favButton.addTarget(self, action: #selector(favTapped), for: .touchUpInside)
    }

    // MARK: - Populate

    private func populate() {
        heroTitleLabel.text = trip.title
        heroSubtitleLabel.text = trip.subtitle
        locationLabel.text = trip.locationName.uppercased()
        heroImageView.image = UIImage(named: trip.imageName)

        ratingCol.set(caption: "RATING",   value: "\(trip.rating) ★", amber: true)
        durationCol.set(caption: "DURATION", value: trip.durationLabel)
        levelCol.set(caption: "LEVEL",     value: trip.levelLabel)

        trip.days.enumerated().forEach { i, day in
            let pill = DayPill(number: day.date.description.count, selected: i == 0)
            pill.tag = i
            pill.addTarget(self, action: #selector(dayTapped(_:)), for: .touchUpInside)
            daysStack.addArrangedSubview(pill)
        }

        timelineTitleLbl.text = "Day 01 Timeline"
        trip.steps.enumerated().forEach { i, step in
            timelineStack.addArrangedSubview(
                TimelineCell(step: step, isLast: i == trip.steps.count - 1))
        }
    }

    // MARK: - Actions

    @objc private func backTapped() { navigationController?.popViewController(animated: true) }

    @objc private func favTapped() {
        UIView.animate(withDuration: 0.12, animations: { self.favButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3) }) { _ in
            UIView.animate(withDuration: 0.15) { self.favButton.transform = .identity }
        }
        favButton.setImage(UIImage(systemName: "heart.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)), for: .normal)
        favButton.tintColor = UIColor(hex: "EF4444")
    }

    @objc private func dayTapped(_ s: UIButton) {
        selectedDayIndex = s.tag
        daysStack.arrangedSubviews.compactMap { $0 as? DayPill }.forEach { $0.setOn($0.tag == selectedDayIndex) }
        timelineTitleLbl.text = "Day \(String(format: "%02d", selectedDayIndex + 1)) Timeline"
    }

    @objc private func addTripButtonTapped() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.addTripButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97) }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5) { self.addTripButton.transform = .identity }
        }
    }

    // MARK: - Factory

    private func makeCircleButton(_ icon: String, tint: UIColor = UIColor(hex: "0F172A")) -> UIButton {
        let b = UIButton(type: .custom)
        let cfg = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        b.setImage(UIImage(systemName: icon, withConfiguration: cfg), for: .normal)
        b.tintColor = tint; b.backgroundColor = .white
        b.layer.cornerRadius = 18
        b.layer.shadowColor = UIColor.black.cgColor; b.layer.shadowOpacity = 0.10
        b.layer.shadowOffset = CGSize(width: 0, height: 3); b.layer.shadowRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }

    private func hLine() -> UIView {
        let v = UIView(); v.backgroundColor = UIColor(hex: "E8ECF0")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true; return v
    }

    private func vDiv() -> UIView {
        let v = UIView(); v.backgroundColor = UIColor(hex: "E8ECF0")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 1).isActive = true
        v.heightAnchor.constraint(equalToConstant: 32).isActive = true; return v
    }

    private func makeSectionLabel(_ t: String) -> UILabel {
        let l = UILabel(); l.text = t
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(hex: "0F172A"); return l
    }

    private func makeTagLabel(_ t: String) -> UILabel {
        let l = UILabel()
        l.attributedText = NSAttributedString(string: t, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(hex: "64748B"), .kern: 1.2]); return l
    }

    private func hStack(_ l: UIView, _ r: UIView) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [l, r])
        sv.distribution = .equalSpacing; sv.alignment = .center; return sv
    }

    private func pin(_ v: UIView, to parent: UIView, top anchor: UIView, topPad: CGFloat) {
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: anchor.bottomAnchor, constant: topPad),
            v.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension PreviewTemplateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let y = scrollView.contentOffset.y

        if y < 0 {
            heroHeightConstraint.constant = heroBaseHeight + abs(y)
            heroTopConstraint.constant = y
        } else {
            heroHeightConstraint.constant = heroBaseHeight
            heroTopConstraint.constant = 0
        }
        
        CATransaction.begin()
            CATransaction.setDisableActions(true)
            heroGradient.frame = CGRect(
                x: 0,
                y: heroImageView.bounds.height - heroBaseHeight,
                width: heroImageView.bounds.width,
                height: heroBaseHeight
            )
            CATransaction.commit()
    }
}

// MARK: - StatCol

final class StatCol: UIView {
    private let cap = UILabel()
    private let val = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        cap.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        cap.textColor = UIColor(hex: "94A3B8"); cap.textAlignment = .center
        val.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        val.textColor = UIColor(hex: "0F172A"); val.textAlignment = .center
        let sv = UIStackView(arrangedSubviews: [cap, val])
        sv.axis = .vertical; sv.spacing = 4; sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: topAnchor), sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor), sv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    func set(caption: String, value: String, amber: Bool = false) {
        cap.text = caption
        if amber {
            val.attributedText = NSAttributedString(string: value, attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: UIColor(hex: "0F172A")
            ])
            // color the star
            let m = NSMutableAttributedString(string: value, attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: UIColor(hex: "0F172A")])
            if let r = value.range(of: "★") {
                let ns = NSRange(r, in: value)
                m.addAttribute(.foregroundColor, value: UIColor(hex: "F59E0B"), range: ns)
            }
            val.attributedText = m
        } else { val.text = value }
    }
}

// MARK: - DayPill

final class DayPill: UIButton {
    private weak var dayLbl: UILabel?
    private weak var numLbl: UILabel?

    init(number: Int, selected: Bool) {
        super.init(frame: .zero)
        layer.cornerRadius = 12
        widthAnchor.constraint(equalToConstant: 54).isActive = true
        heightAnchor.constraint(equalToConstant: 62).isActive = true

        let d = UILabel(); d.text = "DAY"
        d.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        d.textAlignment = .center; d.isUserInteractionEnabled = false; dayLbl = d

        let n = UILabel(); n.text = String(format: "%02d", number)
        n.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        n.textAlignment = .center; n.isUserInteractionEnabled = false; numLbl = n

        let sv = UIStackView(arrangedSubviews: [d, n])
        sv.axis = .vertical; sv.spacing = 0; sv.alignment = .center
        sv.isUserInteractionEnabled = false; sv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sv)
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        setOn(selected)
    }
    required init?(coder: NSCoder) { fatalError() }

    func setOn(_ on: Bool) {
        let dark = UIColor(hex: "0F172A")
        backgroundColor   = on ? dark : .white
        layer.borderWidth = on ? 0 : 1
        layer.borderColor = UIColor(hex: "E2E8F0").cgColor
        layer.shadowColor = dark.cgColor
        layer.shadowOpacity = on ? 0.2 : 0
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowRadius  = 10
        dayLbl?.textColor   = on ? UIColor.white.withAlphaComponent(0.55) : UIColor(hex: "94A3B8")
        numLbl?.textColor   = on ? .white : UIColor(hex: "0F172A")
    }
}

// MARK: - TimelineCell

final class TimelineCell: UIView {
    init(step: TripStep, isLast: Bool) {
        super.init(frame: .zero); build(step, isLast)
    }
    required init?(coder: NSCoder) { fatalError() }

    private func build(_ step: TripStep, _ isLast: Bool) {
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor.white
        iconBg.layer.cornerRadius = 16
        iconBg.layer.borderWidth = 1
        iconBg.layer.borderColor = UIColor(hex: "E2E8F0").cgColor
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBg.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let iv = UIImageView()
        iv.image = UIImage(systemName: step.icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iv)
        NSLayoutConstraint.activate([iv.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
                                     iv.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
                                     iv.widthAnchor.constraint(equalToConstant: 16),
                                     iv.heightAnchor.constraint(equalToConstant: 16)])

        let line = UIView();
        line.backgroundColor = UIColor(hex: "E2E8F0")
        line.isHidden = false
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalToConstant: 1.5).isActive = true

        let left = UIView()
        left.translatesAutoresizingMaskIntoConstraints = false
        left.widthAnchor.constraint(equalToConstant: 32).isActive = true
        left.addSubview(iconBg)
        left.addSubview(line)
        
        NSLayoutConstraint.activate([
            iconBg.topAnchor.constraint(equalTo: left.topAnchor, constant: 18),
            iconBg.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            line.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 6),
            line.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            line.bottomAnchor.constraint(equalTo: left.bottomAnchor)
        ])

        func lbl(_ txt: String, font: UIFont, color: UIColor, lines: Int = 1) -> UILabel {
            let l = UILabel(); l.text = txt; l.font = font; l.textColor = color; l.numberOfLines = lines
            return l
        }

        let time  = lbl(step.time, font: UIFont.systemFont(ofSize: 13, weight: .bold), color: UIColor(hex: "94A3B8"))
        let title = lbl(step.title, font: UIFont.systemFont(ofSize: 18, weight: .semibold), color: UIColor(hex: "0F172A"))
        let desc  = lbl(step.subtitle, font: UIFont.systemFont(ofSize: 14), color: UIColor(hex: "64748B"), lines: 0)

        var views: [UIView] = [time, title, desc]

        if step.hasImage {
            let img = UIImageView()
            img.backgroundColor = UIColor(hex: "2A5480"); img.layer.cornerRadius = 12; img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
            img.image = UIImage(named: step.imageName ?? "")
            img.translatesAutoresizingMaskIntoConstraints = false
            img.heightAnchor.constraint(equalToConstant: 150).isActive = true
            views.append(img)
        }

        let right = UIStackView(arrangedSubviews: views)
        right.axis = .vertical; right.spacing = 4
        if step.hasImage { right.setCustomSpacing(10, after: desc) }
        right.translatesAutoresizingMaskIntoConstraints = false

        let row = UIStackView(arrangedSubviews: [left, right])
        row.axis = .horizontal; row.spacing = 12; row.alignment = .top
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor),
            row.leadingAnchor.constraint(equalTo: leadingAnchor),
            row.trailingAnchor.constraint(equalTo: trailingAnchor),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isLast ? -8 : -24),
            left.heightAnchor.constraint(greaterThanOrEqualTo: row.heightAnchor)
        ])
    }
}

// MARK: - RouteCardView

final class RouteCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "F1F5F9")
        layer.cornerRadius = 16
        layer.borderWidth = 1; layer.borderColor = UIColor(hex: "E2E8F0").cgColor

        let mapIV = UIImageView(image: UIImage(systemName: "map",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)))
        mapIV.tintColor = UIColor(hex: "0F172A")
        mapIV.setContentHuggingPriority(.required, for: .horizontal)

        let title = UILabel(); title.text = "Route Overview"
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        title.textColor = UIColor(hex: "0F172A")

        let leftStack = UIStackView(arrangedSubviews: [mapIV, title])
        leftStack.spacing = 6; leftStack.alignment = .center

        let expand = UILabel()
        expand.attributedText = NSAttributedString(string: "EXPAND MAP", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(hex: "64748B"), .kern: 1.0])

        let header = UIStackView(arrangedSubviews: [leftStack, expand])
        header.distribution = .equalSpacing; header.alignment = .center
        header.translatesAutoresizingMaskIntoConstraints = false

        let map = MapPlaceholderView()
        map.layer.cornerRadius = 10; map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false

        addSubview(header); addSubview(map)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            map.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            map.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            map.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            map.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}



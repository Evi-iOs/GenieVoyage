//
//  CreateTripView.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.12.2023.
//

import UIKit
import RxCocoa
import RxSwift

class CreateTripView: UIView {

    private let disposeBag = DisposeBag()

    @IBOutlet weak var dateTrip: UIDatePicker!
    
    @IBAction func createNewTripAction(_ sender: UIButton) {
        sender.rx.controlEvent(.touchUpInside)
            .subscribe (onNext: { [weak self] _ in
                self?.viewModel.createNewTripDidTap?()
            }).disposed(by: disposeBag)
    }
    
    @IBAction func returnTripPickerAction(_ sender: UIDatePicker) {
        sender.rx.date
            .bind(to: viewModel.returnTrip)
            .disposed(by: disposeBag)
    }
    
    @IBAction func dateTripPickerAction(_ picker: UIDatePicker) {
        picker.rx.date
            .bind(to: viewModel.dateTrip)
            .disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    weak var viewModel: CreateNewTripViewModel! {
        didSet {
            configure(with: viewModel)
        }
    }
    
    private func configure(with viewModel: CreateNewTripViewModel) {
        
    }
}

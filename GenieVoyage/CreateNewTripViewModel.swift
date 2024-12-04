//
//  CreateNewTripViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 01.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

class CreateNewTripViewModel {
    
    private let disposeBag = DisposeBag()
    
    let dateTrip = PublishSubject<Date>()
    let returnTrip = PublishSubject<Date?>()
   // let destination = PublishSubject<String>()
//    let transferDate = PublishSubject<Date?>()
//    let returnTransferDate = PublishSubject<Date?>()
//    let lodgingName = PublishSubject<String?>()
//    let hotelArrivalDate = PublishSubject<Date?>()
//    let hotelDepartureDate = PublishSubject<Date?>()
    
    
    var createNewTripDidTap: (()->())?
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        Observable.combineLatest(dateTrip, returnTrip)
            .subscribe(onNext: { [weak self] dateTrip, returnTrip in
//                self?.coreDataManager.createNewTrip(id: UUID(), dateTrip: dateTrip, returnTrip: returnTrip, destination: "test", transferDate: nil, returnTransferDate: nil, lodginName: nil, hotelArrivalDate: nil, hotelDepatureDate: nil)
//                
            })
            .disposed(by: disposeBag)
        
//        Observable.combineLatest(dateTrip, returnTrip, destination, transferDate, returnTransferDate, lodgingName, hotelArrivalDate, hotelDepartureDate)
//            .subscribe(onNext: { [weak self] dateTrip, returnTrip, destination, transferDate, returnTransferDate, lodgingName, hotelArrivalDate, hotelDepartureDate in
//                self?.coreDataManager.createNewTrip(id: UUID(), dateTrip: dateTrip, returnTrip: returnTrip, destination: destination, transferDate: transferDate, returnTransferDate: returnTransferDate, lodginName: lodgingName, hotelArrivalDate: hotelArrivalDate, hotelDepatureDate: hotelDepartureDate)
//            })
//            .disposed(by: disposeBag)
        
    }
}

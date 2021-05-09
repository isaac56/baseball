//
//  RoomsUseCase.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation
import Combine

class RoomsUseCase {
    let apiRequestManager = APIRequestManager()
    
    func start(url: URL, to assign: RoomsViewModel) -> AnyPublisher<RoomResponse, Error> {
        return apiRequestManager.fetch(url: url, method: .get)
    }
}

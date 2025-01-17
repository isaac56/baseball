//
//  RoomsUseCase.swift
//  BaseballApp
//
//  Created by Song on 2021/05/05.
//

import Foundation

class RoomsUseCase {
    let apiRequestManager = APIRequestManager()
    
    func start(url: URL) {
        apiRequestManager.fetchRooms(url: url, method: .get)
    }
}

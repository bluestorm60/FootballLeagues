//
//  LoadingUseCase.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation

protocol LoadingUseCase{
    var loadingPublisher: Published<LoadingState>.Publisher { get }
}

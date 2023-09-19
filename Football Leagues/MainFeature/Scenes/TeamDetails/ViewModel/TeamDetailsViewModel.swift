//
//  TeamDetailsViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 17/09/2023.
//

import Foundation
import Combine

//MARK: - Input Protocol
protocol TeamDetailsViewModelInput{
    func viewWillAppear()
    func getHeaderData() -> CommonLeagueModel
    func getCompetitionName() -> String
    func numberOfRowsInSection() -> Int
    func cellForRow(_ indexPath: IndexPath) -> TeamMatchesCellViewModel
    func heightForRow() -> CGFloat
}

//MARK: - Output Protocol
protocol TeamDetailsViewModelOutput{
    var listPublisher: Published<[TeamMatchesCellViewModel]>.Publisher { get }
    var loadingPublisher: Published<LoadingState>.Publisher { get }
    var errorMsgPublisher: Published<String?>.Publisher { get }
}


typealias TeamDetailsViewModelProtocols = TeamDetailsViewModelInput & TeamDetailsViewModelOutput

final class TeamDetailsViewModel: TeamDetailsViewModelProtocols{
    
    @Published private var list: [TeamMatchesCellViewModel] = []
    @Published private var loading: LoadingState = .none
    @Published private var errorMsg: String?

    private let useCase: TeamsMatchsUseCase
    private var cancellables = Set<AnyCancellable>()
    private var item: TeamsUIModel.TeamUIModel
    private var cellHeight: CGFloat {
        return 126.0
    }
    
    //MARK: - Outputs
    var listPublisher: Published<[TeamMatchesCellViewModel]>.Publisher {$list}
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}
    var errorMsgPublisher: Published<String?>.Publisher {$errorMsg}

    //MARK: - Init
    init(coordinator: MainCoordinator? = nil, useCase: TeamsMatchsUseCase, item: TeamsUIModel.TeamUIModel) {
        self.useCase = useCase
        self.item = item
        self.useCase.loadingPublisher.assignNoRetain(to: \.loading, on: self).store(in: &cancellables)
    }
}

//MARK: - Input
extension TeamDetailsViewModel {
    func getHeaderData() -> CommonLeagueModel{
        return .init(name: item.name, logo: item.crest, isDetailsHidden: true)
    }
    func viewWillAppear() {
        requests()
    }
    
    func getCompetitionName() -> String{
        return item.name
    }
    
    func numberOfRowsInSection() -> Int {
        return list.count
    }
    
    func cellForRow(_ indexPath: IndexPath) -> TeamMatchesCellViewModel{
        return list[indexPath.row]
    }
    
    func heightForRow() -> CGFloat {
        return cellHeight
    }
}

//MARK: - Requests
extension TeamDetailsViewModel{
     private func requests(){
         Task {
             let response =  try await useCase.fetchMatches(teamId: item.id)
             switch response {
             case .success(let result):
                 guard let result = result else {
                     errorMsg = "No Data Fetched"
                     return
                 }
                 let cellViewModels = convertToCellModels(result)
                 list = cellViewModels
             case .failure(let error):
                 errorMsg = error.localizedDescription
             }
         }
    }
    
    private func convertToCellModels(_ item: [TeamMatchesUIModel.Match]) -> [TeamMatchesCellViewModel]{
        return item.map { item in
            return .init(item)
        }
    }
}

//
//  TeamsViewModel.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 13/09/2023.
//

import Foundation
import Combine

struct TeamsViewModelActions {
    let openTeamDetails: (TeamsUIModel.TeamUIModel) -> Void
}

//MARK: - Input Protocol
protocol TeamsViewModelInput{
    func viewWillAppear()
    func getHeaderData() -> CommonLeagueModel
    func getCompetitionName() -> String
    func numberOfRowsInSection() -> Int
    func cellForRow(_ indexPath: IndexPath) -> TeamsCellViewModel
    func heightForRow() -> CGFloat
}

//MARK: - Output Protocol
protocol TeamsViewModelOutput{
    var listPublisher: Published<[TeamsCellViewModel]>.Publisher { get }
    var loadingPublisher: Published<LoadingState>.Publisher { get }
    var errorMsgPublisher: Published<String?>.Publisher { get }
}

typealias TeamsViewModelProtocols = TeamsViewModelInput & TeamsViewModelOutput

final class TeamsViewModel: TeamsViewModelProtocols{
    @Published var list: [TeamsCellViewModel] = []
    @Published var loading: LoadingState = .none
    @Published var errorMsg: String?

    private let useCase: LeaguesUseCase
    private let actions: TeamsViewModelActions?
    private var cancellables = Set<AnyCancellable>()
    private var item: LeaguesUIModel.CompetitionUIModel
    private var cellHeight: CGFloat {
        return 120.0
    }
    //MARK: - Outputs
    var listPublisher: Published<[TeamsCellViewModel]>.Publisher {$list}
    var loadingPublisher: Published<LoadingState>.Publisher {$loading}
    var errorMsgPublisher: Published<String?>.Publisher {$errorMsg}

    //MARK: - Init
    init(useCase: LeaguesUseCase, item: LeaguesUIModel.CompetitionUIModel,actions: TeamsViewModelActions? = nil) {
        self.useCase = useCase
        self.item = item
        self.actions = actions
        self.useCase.loadingPublisher.assignNoRetain(to: \.loading, on: self).store(in: &cancellables)
    }
}


//MARK: - Input
extension TeamsViewModel {
    func getHeaderData() -> CommonLeagueModel{
        return .init(name: item.name, logo: item.emblem, isDetailsHidden: false, seasonsNumber: item.numberOfSeasons, matchesNumber: item.numberOfmatches, teamsNumber: item.numberOfTeams)
    }
    func viewWillAppear() {
        requests()
    }
    
    
    func numberOfRowsInSection() -> Int {
        return list.count
    }
    
    func cellForRow(_ indexPath: IndexPath) -> TeamsCellViewModel{
        return list[indexPath.row]
    }
    
    func getCompetitionName() -> String{
        return item.name
    }

    func heightForRow() -> CGFloat {
        return cellHeight
    }
}

//MARK: - Requests
extension TeamsViewModel{
     private func requests(){
        Task {
            let response =  try await useCase.fetchTeams(competition: item)
            switch response {
            case .success(let result):
                let cellViewModels = convertToCellModels(result.teams)
                item.numberOfTeams = "\(result.count)"
                list = cellViewModels
            case .error(let networkError):
                errorMsg = networkError.localizedDescription
            }
        }
    }
    
    private func convertToCellModels(_ item: [TeamsUIModel.TeamUIModel]) -> [TeamsCellViewModel]{
        return item.map { item in
            return .init(item, self)
        }
    }
}

//MARK: - TeamsCellsDelegate
extension TeamsViewModel: TeamsCellViewModelDelegate{
    func openTeamDetails(item: TeamsUIModel.TeamUIModel?) {
        guard let item = item else {return}
        //navigate to Team Matches
        actions?.openTeamDetails(item)
    }
}


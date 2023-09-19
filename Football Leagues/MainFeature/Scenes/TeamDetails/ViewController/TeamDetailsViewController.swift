//
//  TeamDetailsViewController.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit
import Combine
class TeamDetailsViewController: UIViewController, PresentableAlert, LoadingViewCapable {
    //MARK: - Outlets
    @IBOutlet private weak var headerView: CommonLeagueView!
    @IBOutlet private weak var teamMatchesTableView: UITableView!{
        didSet{
            teamMatchesTableView.registerNib(TeamMatchesTableViewCell.self)
            teamMatchesTableView.dataSource = self
            teamMatchesTableView.delegate = self
        }
    }

    //MARK: - Properties
    let viewModel: TeamDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deInit : \(String(describing: Self.self))")
    }
    
    init(viewModel: TeamDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        headerView.item = viewModel.getHeaderData()
        viewModel.viewWillAppear()
    }
    
    //MARK: - Methods / binding
    private func binding(){
        bindLoading()
        bindErrorMsg()
        bindTeamsList()
    }
    
    private func bindLoading(){
        viewModel.loadingPublisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self else { return }
            switch state{
            case .loading:
                showLoader()
            case .dismiss,.none:
                hideLoader()
            }
        }.store(in: &cancellables)
    }
    
    private func bindErrorMsg(){
        viewModel.errorMsgPublisher.receive(on: DispatchQueue.main).sink { [weak self] msg in
            guard let self, let msg = msg else { return }
            showAlert(with: msg)
        }.store(in: &cancellables)
    }
    
    private func bindTeamsList(){
        viewModel.listPublisher.receive(on: DispatchQueue.main).sink { [weak self] list in
            guard let self else { return }
            headerView.item = viewModel.getHeaderData()
            teamMatchesTableView.reloadData()
        }.store(in: &cancellables)
    }
}


//MARK: - DataSource & delegate
extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamMatchesTableViewCell.className, for: indexPath) as? TeamMatchesTableViewCell  else { return UITableViewCell() }
        cell.item = viewModel.cellForRow(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

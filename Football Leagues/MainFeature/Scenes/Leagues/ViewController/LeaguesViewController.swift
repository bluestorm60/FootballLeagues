//
//  LeaguesViewController.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 12/09/2023.
//

import UIKit
import Combine

class LeaguesViewController: UIViewController,PresentableAlert, LoadingViewCapable {
    //MARK: - Outlets
    @IBOutlet private weak var leaguesTableView: UITableView!{
        didSet{
            leaguesTableView.registerNib(LeagueTableViewCell.self)
            leaguesTableView.dataSource = self
            leaguesTableView.delegate = self
        }
    }
    
    //MARK: - Properties
    let viewModel: LeaguesViewModel
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deInit : \(String(describing: Self.self))")
    }
    
    init(viewModel: LeaguesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    //MARK: - Methods
    private func binding(){
        bindLoading()
        bindErrorMsg()
        bindLeaguesList()
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
    
    private func bindLeaguesList(){
        viewModel.listPublisher.receive(on: DispatchQueue.main).sink { [weak self] list in
            guard let self else { return }
            leaguesTableView.reloadData()
        }.store(in: &cancellables)
    }
    
    //MARK: - Actions

}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueTableViewCell", for: indexPath) as? LeagueTableViewCell  else { return UITableViewCell() }
        cell.item = viewModel.cellForRow(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}




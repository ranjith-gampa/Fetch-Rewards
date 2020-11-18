//
//  RewardsViewController.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Combine
import UIKit

class RewardsViewController: UIViewController {
    
    private var model: Model = .init() {
        didSet {
            applyModel()
        }
    }
    
    struct Model {
        var groups: [ViewItemGroup] = []
        var isLoading: Bool = false
        var didFail: Bool = false
        
        struct ViewItemGroup {
            var id: ItemGroup.ID
            var items: [ViewItem]
            
            struct ViewItem {
                var id: Item.ID
                var name: String
            }
        }
    }
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.tableFooterView = UIView()
    
        return view
    }()
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Row>?
    private var dataSource: RewardsDataSource
    
    private var subscriptions = Set<AnyCancellable>()
    
    typealias Section = ItemGroup.ID
    typealias Row = Item.ID
    
    init(dataSource: RewardsDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.loadItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewHierarchy()
        setupConstraints()
        setupTableViewDataSource()
        setupSubscriptions()
    }
    
    private func setupViews() {
        title = "Items"
        view.backgroundColor = .white
    }
    
    private func setupViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupTableViewDataSource() {
        tableViewDataSource = .init(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, row) -> UITableViewCell? in
                
                let cell: ItemTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: ItemTableViewCell.reuseIdentifier
                ) as? ItemTableViewCell ?? ItemTableViewCell()
                
                let item = self?.model.groups[indexPath.section].items.filter { $0.id == row }.first
                cell.model = ItemTableViewCell.Model(from: item)
                
                return cell
            }
        )
    }
    
    private func setupSubscriptions() {
        dataSource.$state
            .map { Model(from: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.model = $0
            }
            .store(in: &subscriptions)
    }
    
    private func applyModel(animated: Bool = true) {
       
        if model.isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
            applyTableViewModel(animated: animated)
        }
    }
    
    private func applyTableViewModel(animated: Bool) {
        guard let tableViewDataSource = tableViewDataSource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        
        snapshot.appendSections(model.groups.map { $0.id })
        model.groups.forEach {
            snapshot.appendItems($0.items.map({ $0.id }), toSection: $0.id)
        }
        
        tableViewDataSource.apply(snapshot, animatingDifferences: animated, completion: nil)
    }
}

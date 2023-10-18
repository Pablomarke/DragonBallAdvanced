//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set}
    var heroesCount: Int {get}
    func onViewappear()
    func heroBy(index: Int)  -> Hero?
}

enum HeroesViewState {
    case loading (_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet var tableHeroes: UITableView!
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewappear()
    }
    
    private func initViews() {
        tableHeroes.delegate = self
        tableHeroes.dataSource = self
        tableHeroes.register(UINib(nibName: HeroCellView.identifier, bundle: nil), forCellReuseIdentifier: HeroCellView.identifier)
        
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        //TODO loading
                        break
                    case .updateData:
                        self?.tableHeroes.reloadData()
                }
            }
        }
    }
}

extension HeroesViewController: UITableViewDelegate, 
                                    UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        HeroCellView.estimatedHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableHeroes.dequeueReusableCell(withIdentifier: HeroCellView.identifier, for: indexPath) as? HeroCellView else {
            return UITableViewCell()
        }
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO : navegar al detalle de hero
        
    }
}

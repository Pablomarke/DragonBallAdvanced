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
    func heroDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?
    func onViewappear()
    func heroBy(index: Int)  -> Hero?
    func logout()
}

enum HeroesViewState {
    case loading (_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet var tableHeroes: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: - Public Properties -
    var viewModel: HeroesViewControllerDelegate?
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewappear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        /*
        guard segue.identifier == "HEROES_TO_MAPHEROES",
              let mapHeroesController = segue.destination as? MapHeroesController else {
            return
        }*/
        guard segue.identifier == "HEROES_TO_DETAIL",
              let index = sender as? Int,
              let heroDetailViewController = segue.destination as? HeroDetailViewController,
              let detailViewModel = viewModel?.heroDetailViewModel(index: index) else {
            return
        }
        
        heroDetailViewController.viewModel = detailViewModel
        let backItem = UIBarButtonItem()
        backItem.title = "Heroes"
        backItem.tintColor = .orange
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - Private functions -
    private func initViews() {
        tableHeroes.dataSource = self
        tableHeroes.delegate = self
        tableHeroes.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier
        )
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading

                    case .updateData:
                        self?.tableHeroes.reloadData()
                }
            }
        }
    }
    // MARK: - Button Actions -
    @IBAction func logoutAction(_ sender: Any) {
        viewModel?.logout()
        self.performSegue(withIdentifier: "HEROES_TO_SPLASHVIEW",
                     sender: nil)
    }
    
    @IBAction func mapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "HEROES_TO_MAPHEROES",
                     sender: nil)
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
        guard let cell = tableHeroes.dequeueReusableCell(withIdentifier: HeroCellView.identifier, 
                                                         for: indexPath) as? HeroCellView else {
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
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.performSegue(withIdentifier: "HEROES_TO_DETAIL",
                     sender: indexPath.row)
    }
}

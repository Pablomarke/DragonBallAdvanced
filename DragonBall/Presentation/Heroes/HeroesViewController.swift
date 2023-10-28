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
    func splashViewModel() -> SplashViewControllerDelegate?
    func mapHeroesViewModel() -> MapHeroesControllerDelegate?
    func onViewappear()
    func heroBy(index: Int)  -> HeroDAO?
    func logout()
    
}

enum HeroesViewState {
    case loading (_ isLoading: Bool)
    case updateData
    case navigateToMap
    case navigateToDetail(index: Int)
    case logoutAndExit
}

class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet var tableHeroes: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var loadLabel: UILabel!
    
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
        switch segue.identifier {
            case "HEROES_TO_DETAIL":
                guard let index = sender as? Int,
                      let heroDetailViewController = segue.destination as? HeroDetailViewController,
                      let detailViewModel = viewModel?.heroDetailViewModel(index: index) else {
                    return
                }
                heroDetailViewController.viewModel = detailViewModel
                
            case "HEROES_TO_MAPHEROES":
                guard let mapHeroesController = segue.destination as? MapHeroesController,
                      let mapHeroesViewModel = viewModel?.mapHeroesViewModel() else {
                    return
                }
                mapHeroesController.viewModel = mapHeroesViewModel
                
            case "HEROES_TO_SPLASHVIEW":
                guard let splashViewController = segue.destination as? SplashViewController,
                      let splashViewModel = viewModel?.splashViewModel() else {
                    return
                }
                viewModel?.logout()
                splashViewController.viewModel = splashViewModel
                
            default:
                break
        }
    }
        
    // MARK: - Private functions -
    private func initViews() {
        tableHeroes.dataSource = self
        tableHeroes.delegate = self
        tableHeroes.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier
        )
        changeBackButton()
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading

                    case .updateData:
                        self?.tableHeroes.reloadData()
                        
                    case .navigateToMap:
                        self?.performSegue(withIdentifier: "HEROES_TO_MAPHEROES",
                                     sender: nil)
                        
                    case .logoutAndExit:
                        self?.performSegue(withIdentifier: "HEROES_TO_SPLASHVIEW",
                                     sender: nil)
                    
                        
                    case .navigateToDetail(index: let index):
                        self?.performSegue(withIdentifier: "HEROES_TO_DETAIL",
                                     sender: index)
                }
            }
        }
    }
    
    private func changeBackButton(){
        let backItem = UIBarButtonItem()
        backItem.title = "Heroes"
        backItem.tintColor = .orange
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - IBActions -
    @IBAction func logoutAction(_ sender: Any) {
        viewModel?.viewState?(.logoutAndExit)
    }
    
    @IBAction func mapAction(_ sender: Any) {
        viewModel?.viewState?(.navigateToMap)
    }
}

// MARK: - Table View Data Source y Delegate-
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
                description: hero.heroDescription
            )
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel?.viewState?(.navigateToDetail(index: indexPath.row))
    }
}

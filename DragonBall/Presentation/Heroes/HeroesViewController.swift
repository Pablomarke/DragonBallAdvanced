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
    func loginViewModel() -> LoginViewControllerDelegate?
    func mapHeroesViewModel() -> MapHeroesControllerDelegate?
    func onViewappear()
    func heroBy(index: Int)  -> HeroDAO?
    func logout()
    func whereIsTheHeroes()
    func destroyData()
    
}

enum HeroesViewState {
    case loading (_ isLoading: Bool)
    case updateData
    case navigateToMap
    case navigateToDetail(index: Int)
    case logoutAndExit
    case noHero
}

class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet var tableHeroes: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var destroyButton: UIButton!
    @IBOutlet weak var bottomTable: NSLayoutConstraint!
    
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
    // MARK: - Segues -
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
                
            case "HEROES_TO_LOGIN":
                guard let loginViewController = segue.destination as? LoginViewController,
                      let loginViewModel = viewModel?.loginViewModel() else {
                    return
                }
                viewModel?.logout()
                loginViewController.viewModel = loginViewModel
                
            default:
                break
        }
    }
    
    // MARK: - Private functions -
    private func initViews() {
        tableHeroes.dataSource = self
        tableHeroes.delegate = self
        tableHeroes.bounces = false
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
                        self?.viewModel?.whereIsTheHeroes()
                        
                    case .navigateToMap:
                        self?.performSegue(withIdentifier: "HEROES_TO_MAPHEROES",
                                           sender: nil)
                        
                    case .logoutAndExit:
                        self?.performSegue(withIdentifier: "HEROES_TO_LOGIN",
                                           sender: nil)
                        
                        
                    case .navigateToDetail(index: let index):
                        self?.performSegue(withIdentifier: "HEROES_TO_DETAIL",
                                           sender: index)
                    case .noHero:
                        self?.viewModel?.destroyData()
                        self?.loadingView.isHidden = false
                        self?.tableHeroes.reloadData()
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
    @IBAction func destroyButtonAction(_ sender: Any) {
        viewModel?.viewState?(.noHero)
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
    
    func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {
        let offsetY = scrollView.contentOffset.y + 30
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        if offsetY > 0 && offsetY + 50 + visibleHeight  >= contentHeight  {
            self.bottomTable.constant = 94
            self.destroyButton.isHidden = false
        } else {
            self.bottomTable.constant = 0
            self.destroyButton.isHidden = true
        }
    }
}


//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import UIKit

class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet var tableHeroes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        tableHeroes.delegate = self
        tableHeroes.dataSource = self
        
    }
}

extension HeroesViewController: UITableViewDelegate, 
                                    UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        UITableViewCell()
    }
}

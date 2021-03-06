//
//  PokemonListViewController.swift
//  AppNicoMVVM
//
//  Created by Gustavo Lembert da Cunha on 03/01/20.
//  Copyright © 2020 Pedro Ullmann. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: PokemonListViewModel!
    private let networking = PokemonListNetworking()
    private let paging = Paging(limit: 20)
    private let pokemonCellIdentifier = "pokemonCell"
    private let goToDetailSegueIdentifier = "goToDetail"
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBind()
        setupTableView()
        setupFetch()
        self.navigationItem.title = "Pokedex"
        tableView.accessibilityIdentifier = AccessibilityIdentifier.pokemonListTableView.rawValue
        tableView.isAccessibilityElement = true
    }
    
    // MARK: - Functions
    private func setupBind() {
        viewModel = PokemonListViewModel(networking: networking)
        viewModel.reloadTableView = tableView.reloadData
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupFetch() {
        viewModel.fetchPokemons(offset: paging.offset,
                                limit: paging.limit)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDetailSegueIdentifier,
            let destination = segue.destination as? PokemonDetailViewController,
            let pokemon = sender as? Pokemon {
            destination.pokemon = pokemon
        }
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getElementsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let unCell = tableView.dequeueReusableCell(withIdentifier: pokemonCellIdentifier, for: indexPath) as? PokemonListTableViewCell,
            let pokemon = viewModel.pokemonPerLine(row: indexPath.row) {
            unCell.accessibilityIdentifier = "\(AccessibilityIdentifier.detailPokemonTableCell.rawValue)\(indexPath.row)"
            unCell.isAccessibilityElement = true
            unCell.pokemon = pokemon
            unCell.indexPokemon = indexPath.row + 1
            return unCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = paging.threshold + indexPath.row
        
        if threshold == viewModel.getElementsCount() {
            paging.offset += paging.limit
            setupFetch()
        }
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Coloca esse valor em uma constante protegida local
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let unPokemon = viewModel.pokemonPerLine(row: indexPath.row) {
            performSegue(withIdentifier: goToDetailSegueIdentifier, sender: unPokemon)
        }
    }
}

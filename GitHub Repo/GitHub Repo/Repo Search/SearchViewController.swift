//
//  SearchController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var items = [Item]()
    
    weak var coordinator: AppCoordinator?
    
    var isFirstSearchingDone = false
    var safeArea: UILayoutGuide!
    
    var scaleRatio = UIScreen.main.bounds.height / 844
    
    lazy var repoList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "searchCell")
        tableView.separatorStyle = .none

        return tableView
    }()
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    lazy var repositoriesLabel: UILabel = {
        let label = UILabel()

        label.text = "Repositories"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24*scaleRatio, weight: .bold)
        label.numberOfLines = 1

        return label
    }()
    
    lazy var initialRepoLabel: UILabel = {
        let label = UILabel()

        label.text = "Search repositories to display results"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18*scaleRatio, weight: .medium)
        label.textColor = UIColor.systemGray4
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()
    
    lazy var avatarImage: UIImage = {
        var avatar = UIImage()
        
        avatar = UIImage(named: "launchScreenLogo.png")!

        return avatar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.view.backgroundColor = .systemBackground
        setupRepoLabel()
        setupInitialLabel()
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
    }
    
    func prepareToParse(query: String) {
        let urlString = "https://api.github.com/search/repositories?q=\(query)&page=1&per_page=20"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        isFirstSearchingDone = true
        
        if isFirstSearchingDone {
            setupElements()
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonItems = try? decoder.decode(Repositories.self, from: json) {
            items = jsonItems.items
        }
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchBar.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchBar.isActive && (!isSearchBarEmpty())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        prepareToParse(query: query)
        repoList.reloadData()
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isFiltering() {
            initialRepoLabel.removeFromSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as?
                SearchCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray6
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.systemBackground.cgColor

        let item = items[indexPath.row]
        
        if let data = try? Data(contentsOf: item.owner.avatarUrl) {
            avatarImage = UIImage(data: data)!
        }

        cell.repoTitle.text = item.name
        cell.starsNumber.text = item.stargazersCount.description
        cell.avatar.image = avatarImage

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        coordinator?.showDetails(repoName: item.name, stargazersCount: item.stargazersCount, authorName: item.owner.login, htmlUrl: item.owner.htmlUrl, avatarUrl: item.owner.avatarUrl)
    }
}


extension SearchViewController {
    func setupElements() {
        view.addSubview(repoList)
        
        repoList.topAnchor.constraint(equalTo: repositoriesLabel.bottomAnchor, constant: 20*scaleRatio).isActive = true
        repoList.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        repoList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10*scaleRatio).isActive = true
        repoList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10*scaleRatio).isActive = true
    }
    
    func setupRepoLabel() {
        view.addSubview(repositoriesLabel)

        repositoriesLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10*scaleRatio).isActive = true
        repositoriesLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        repositoriesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
    }
    
    func setupInitialLabel() {
        view.addSubview(initialRepoLabel)
        
        initialRepoLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        initialRepoLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        initialRepoLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        initialRepoLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    }
}

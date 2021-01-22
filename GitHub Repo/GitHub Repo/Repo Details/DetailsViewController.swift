//
//  DetailsViewController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 18/01/2021.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    weak var coordinator: AppCoordinator?
    
    var commits = [Commits]()
    
    //Don't know how to init these variables in a different way
    var authorName: String = ""
    var repoName: String = ""
    var htmlUrl: String = ""
    var avatarUrl: String = ""
    var stargazersCount: String = ""
    
    let shareIconImage = UIImage(named: "Share.png")
    
    var scaleRatio = UIScreen.main.bounds.height / 844
    
    var scrollView: UIScrollView!
    var headerContainerView: UIView!
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var repoNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18*scaleRatio, weight: .semibold)
        label.textColor = .label
        label.text = repoName
        label.numberOfLines = 2
        
        return label
    }()

    lazy var stargazersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14*scaleRatio, weight: .semibold)
        label.textColor = .lightText
        label.text = "Number of Stars (\(stargazersCount))"
        
        return label
    }()
    
    lazy var headerRepoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14*scaleRatio, weight: .semibold)
        label.textColor = .lightText
        label.text = "REPO BY"
        
        return label
    }()
    
    lazy var repoAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32*scaleRatio, weight: .bold)
        label.textColor = .white
        label.text = authorName
        
        return label
    }()
    
    lazy var commitsHistoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22*scaleRatio, weight: .bold)
        label.textColor = .label
        label.text = "Commits History"
        
        return label
    }()
    
    lazy var viewOnlineButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16*scaleRatio, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15.0
        button.setTitle("VIEW ONLINE", for: .normal)
        
        return button
    }()
    
    lazy var shareRepoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18*scaleRatio, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.setTitle("Share Repo", for: .normal)
        button.setImage(shareIconImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemBlue
        button.imageEdgeInsets = UIEdgeInsets(top: 10*scaleRatio, left: -5*scaleRatio, bottom: 10*scaleRatio, right: 0)
        
        return button
    }()
    
    lazy var commitsList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailsCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        
        return tableView
    }()
    
    let starIcon: UIImageView = {
        var image = UIImageView()
        let starImage = UIImage(named: "Star-filled.png")
        image = UIImageView(image: starImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        setupHeaderImage()
        createView()
        setViewConstraints()
        prepareToParse()
        
        viewOnlineButton.addTarget(self, action: #selector(viewRepoOnline(sender:)), for: .touchUpInside)
        shareRepoButton.addTarget(self, action: #selector(shareRepo(sender:)), for: .touchUpInside)
    }
    
    @objc func viewRepoOnline(sender: UIButton!) {
        let finalUrl = htmlUrl + "/\(repoName)"
        guard let url = URL(string: finalUrl) else { return }
        
        //Opening repository in browser
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func shareRepo(sender: UIButton!) {
        let textToShare = "Check GitHub repository named \(repoName) created by \(authorName)!"
        let finalUrl = htmlUrl + "/" + repoName
        
        //Share button doesn't work for sharing to Messenger
        if let githubWebsite = URL(string: finalUrl) {
            let objectToShare = [textToShare, githubWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func prepareToParse() {
        //Query searches for all queries, but TableView displays max 3
        let urlString = "https://api.github.com/repos/\(authorName)/\(repoName)/commits"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseJson(json: data)
            }
        }
    }
    
    func parseJson(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonCommits = try? decoder.decode([Commits].self, from: json) {
            commits = jsonCommits
        }
    }
    
    func setupHeaderImage() {
        //Extension of imageFrom written below
        let imageUrl = URL(string: avatarUrl)
        headerImageView.imageFrom(url: imageUrl!)
    }
    
    func createView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .gray
        scrollView.addSubview(headerContainerView)
    }
    
    func setViewConstraints() {
        headerContainerView.addSubview(headerImageView)
        scrollView.addSubview(repoNameLabel)
        scrollView.addSubview(stargazersCountLabel)
        scrollView.addSubview(headerRepoLabel)
        scrollView.addSubview(repoAuthorLabel)
        scrollView.addSubview(commitsHistoryLabel)
        scrollView.addSubview(viewOnlineButton)
        scrollView.addSubview(shareRepoButton)
        scrollView.addSubview(starIcon)
        scrollView.addSubview(commitsList)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        repoNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        repoNameLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10*scaleRatio).isActive = true
        repoNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 180*scaleRatio).isActive = true
        repoNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        repoNameLabel.rightAnchor.constraint(equalTo: viewOnlineButton.leftAnchor, constant: -20*scaleRatio).isActive = true
        
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let headerContainerViewBottom: NSLayoutConstraint!
        headerContainerViewBottom = headerContainerView.bottomAnchor.constraint(equalTo: repoNameLabel.topAnchor, constant: -20*scaleRatio)
        headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerContainerViewBottom.isActive = true
        
        headerImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        let imageViewTopConstraint: NSLayoutConstraint!
        imageViewTopConstraint = headerImageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
        
        starIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        starIcon.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -22*scaleRatio).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 15*scaleRatio).isActive = true
        starIcon.widthAnchor.constraint(equalToConstant: 15*scaleRatio).isActive = true
        
        stargazersCountLabel.leftAnchor.constraint(equalTo: starIcon.rightAnchor, constant: 5*scaleRatio).isActive = true
        stargazersCountLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20*scaleRatio).isActive = true
        
        repoAuthorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        repoAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        repoAuthorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        repoAuthorLabel.bottomAnchor.constraint(equalTo: stargazersCountLabel.topAnchor, constant: -10*scaleRatio).isActive = true
        
        headerRepoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        headerRepoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        headerRepoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        headerRepoLabel.bottomAnchor.constraint(equalTo: repoAuthorLabel.topAnchor, constant: -5*scaleRatio).isActive = true
        
        commitsHistoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        commitsHistoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        commitsHistoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        commitsHistoryLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: 30*scaleRatio).isActive = true
        
        viewOnlineButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20*scaleRatio).isActive = true
        viewOnlineButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 175*scaleRatio).isActive = true
        viewOnlineButton.widthAnchor.constraint(equalToConstant: 140*scaleRatio).isActive = true
        
        commitsList.topAnchor.constraint(equalTo: commitsHistoryLabel.bottomAnchor, constant: 15*scaleRatio).isActive = true
        commitsList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commitsList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commitsList.bottomAnchor.constraint(equalTo: shareRepoButton.topAnchor, constant: -20*scaleRatio).isActive = true
        
        shareRepoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        shareRepoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20*scaleRatio).isActive = true
        shareRepoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40*scaleRatio).isActive = true
        shareRepoButton.heightAnchor.constraint(equalToConstant: 50*scaleRatio).isActive = true
    }
}

extension UIImageView {
    func imageFrom(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of rows changes when repository has less than 3 commits or content is not downloaded
        switch commits.count {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Height depends how much lines does the commit have
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as?
                DetailsCell else { return UITableViewCell() }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //Checking if content is downloaded, otherwise App will crash
        //If structure is empty, App displays one default cell
        if !(commits.isEmpty) {
            let commit = commits[indexPath.row]
            cell.commitMessage.text = commit.commit.message
            cell.commitAuthor.text = commit.commit.author.name
            cell.authorEmail.text = commit.commit.author.email
        }
        
        cell.commitNumber.text = (indexPath.row + 1).description
        
        return cell
    }
}

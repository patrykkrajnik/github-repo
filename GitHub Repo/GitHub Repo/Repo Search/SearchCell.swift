//
//  SearchCell.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchCell: UITableViewCell {

    let repoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        
        return label
    }()
    
    let starsNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        
        return label
    }()
    
    let avatarImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    let starIconImage: UIImageView = {
        var image = UIImageView()
        let starImage = UIImage(named: "Star.png")
        
        image = UIImageView(image: starImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(repoTitleLabel)
        addSubview(starsNumberLabel)
        addSubview(avatarImage)
        addSubview(starIconImage)
        
        repoTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        repoTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        repoTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        
        starIconImage.topAnchor.constraint(equalTo: repoTitleLabel.bottomAnchor, constant: 7).isActive = true
        starIconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        starIconImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starIconImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        starsNumberLabel.topAnchor.constraint(equalTo: repoTitleLabel.bottomAnchor, constant: 5).isActive = true
        starsNumberLabel.leftAnchor.constraint(equalTo: starIconImage.rightAnchor, constant: 5).isActive = true
        starsNumberLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        avatarImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  SearchCell.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchCell: UITableViewCell {

    let repoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        
        return label
    }()
    
    let starsNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        
        return label
    }()
    
    let avatar: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    let starIcon: UIImageView = {
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
        
        addSubview(repoTitle)
        addSubview(starsNumber)
        addSubview(avatar)
        addSubview(starIcon)
        
        repoTitle.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        repoTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        repoTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        
        starIcon.topAnchor.constraint(equalTo: repoTitle.bottomAnchor, constant: 7).isActive = true
        starIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        starsNumber.topAnchor.constraint(equalTo: repoTitle.bottomAnchor, constant: 5).isActive = true
        starsNumber.leftAnchor.constraint(equalTo: starIcon.rightAnchor, constant: 5).isActive = true
        starsNumber.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        avatar.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

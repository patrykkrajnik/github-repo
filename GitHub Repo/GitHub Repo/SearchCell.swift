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
        
        return label
    }()
    
    let starsNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(repoTitle)
        addSubview(starsNumber)
        
        repoTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        repoTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        repoTitle.rightAnchor.constraint(equalTo: starsNumber.leftAnchor).isActive = true
        repoTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        starsNumber.topAnchor.constraint(equalTo: topAnchor).isActive = true
        starsNumber.widthAnchor.constraint(equalToConstant: 120).isActive = true
        starsNumber.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        starsNumber.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

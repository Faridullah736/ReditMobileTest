//
//  searchCell.swift
//  Mobiletest
//
//  Created by Faridullah on 8/26/18.
//  Copyright © 2018 Faridullah. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {

    @IBOutlet var lblemail: UILabel!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var userAvatar: UIImageView!
    
    var githubData:Githubuser? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        lblname.text = githubData?.login
        lblemail.text = "Score:\(githubData?.score ?? 0.0)"
        if let image = githubData?.avatarUrl {
            userAvatar.loadImageWith(imgUrl: image, placeHolder: nil)
        }
    }
    func setupUI() {
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
    }
}

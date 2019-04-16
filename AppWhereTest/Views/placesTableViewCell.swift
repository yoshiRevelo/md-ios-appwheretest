//
//  placesTableViewCell.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import UIKit

class placesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var place: Merchant!{
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Private Methods
    private func configureCell(){
        nameLabel.text = place.merchantName
        addressLabel.text = place.merchantAddress
        phoneLabel.text = place.merchantTelephone
    }
}

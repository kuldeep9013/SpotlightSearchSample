//
//  DetailsCell.swift
//  SpotlightSeachSample
//
//  Created by Kuldeep Solanki on 23/04/25.
//

import UIKit

class DetailsCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .gray
        labelTitle.textColor = .white
    }

}

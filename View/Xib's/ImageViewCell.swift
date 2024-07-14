//
//  ImageViewCell.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 14/07/24.
//

import UIKit

class ImageViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

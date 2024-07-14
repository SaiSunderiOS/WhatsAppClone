//
//  TextMessageCell.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 14/07/24.
//

import UIKit

class TextMessageCell: UITableViewCell {
    
    @IBOutlet weak var textMessageLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

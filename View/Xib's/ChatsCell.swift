//
//  ChatsCell.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 13/07/24.
//

import UIKit

class ChatsCell: UITableViewCell   {

    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var messageLbl : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

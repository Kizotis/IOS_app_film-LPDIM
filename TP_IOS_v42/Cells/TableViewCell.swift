//
//  TableViewCell.swift
//  TP_IOS_v42
//
//  Created by Bouvard Antoine on 05/06/2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imgFilmlist: UIImageView!
    @IBOutlet weak var dateFilmlist: UILabel!
    @IBOutlet weak var titreFilmlist: UILabel!
    @IBOutlet weak var synopsisFilmlist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		synopsisFilmlist.numberOfLines = 3
        // Configure the view for the selected state
    }
    
}

//
//  SongsCollectionViewCell.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var artWorkImg: UIImageView!
    
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBOutlet weak var trackNameLbl: UILabel!
    
    @IBOutlet weak var albumLbl: UILabel!
    
    @IBOutlet weak var genreLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0).cgColor
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
}

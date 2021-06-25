//
//  AdditionalInformationCell.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/11.
//

import UIKit

class AdditionalInformationCell: UITableViewCell {
    @IBOutlet weak var additionalInformationLabel: UILabel!
    
    func configureAdditionalInformationCell(information: String) {
        self.additionalInformationLabel.text = information
    }
}

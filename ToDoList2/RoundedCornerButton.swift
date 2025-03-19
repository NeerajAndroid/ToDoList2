//
//  RoundedCornerButton.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 19/03/25.
//

import UIKit

class RoundedCornerButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
       // titleLabel?.text = "Submit"
        titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        backgroundColor = .link
    }
    override func layoutSubviews() {
        layer.cornerRadius = 8
    }

}

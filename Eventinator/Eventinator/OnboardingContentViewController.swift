//
//  OnboardingContentViewController.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/16/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageImageView: UIImageView!
    
    var pageLabelText: String!
    var pageImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageLabel.text = pageLabelText
        pageImageView.image = pageImage
    }
}

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
    
    var pageIndex: Int!
    var pageLabelText: String!
    var pageImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageLabel.text = pageLabelText
        pageImageView.image = pageImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

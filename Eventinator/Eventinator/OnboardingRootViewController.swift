//
//  OnboardingRootViewController.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/16/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class OnboardingRootViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    
    var pageLabels: [String]?
    var pageImages: [UIImage]?
    
    var pageViewController: OnboardingPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        pageLabels = ["Discover exciting events happening around you", "Swipe right to save an event and left to pass", "Saved events show up on you calendar"]
        pageImages = [UIImage.init(named: "ic_discover")!, UIImage.init(named: "ic_profile")!, UIImage.init(named: "ic_star")!]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as? OnboardingPageViewController
        pageViewController?.dataSource = self
        
        let startingViewController = getContentViewController(at: 0)!
        let viewControllers = [startingViewController]
        pageViewController?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        pageViewController?.view.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 30)
        
        addChildViewController(pageViewController!)
        contentView.addSubview((pageViewController?.view)!)
        pageViewController?.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSkipClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    func getContentViewController(at index: Int) -> OnboardingContentViewController? {
        if pageLabels?.count == 0 || index >= (pageLabels?.count)! {
            return nil
        }
        
        if index == (pageLabels?.count)! - 1 {
            skipButton.setTitle("Continue", for: UIControlState.normal)
        } else {
            skipButton.setTitle("Skip", for: UIControlState.normal)
        }
        
        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingContentViewController") as! OnboardingContentViewController
        contentViewController.pageIndex = index
        contentViewController.pageLabelText = pageLabels![index]
        contentViewController.pageImage = pageImages![index]
        return contentViewController
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

extension OnboardingRootViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardingContentViewController).pageIndex!
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        return getContentViewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).pageIndex!
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == pageLabels?.count {
            return nil
        }
        return getContentViewController(at: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return (pageLabels?.count)!
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

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
    
    var pages: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = [
            createPage("Discover exciting events happening around you", UIImage.init(named: "ic_discover")!),
            createPage("Swipe right to save an event and swipe left to pass", UIImage.init(named: "ic_profile")!),
            createPage("Saved events show up on you calendar", UIImage.init(named: "ic_star")!)
        ]
        let pageViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
        pageViewController.dataSource = self
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 30)
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        
        addChildViewController(pageViewController)
        contentView.addSubview((pageViewController.view)!)
        pageViewController.didMove(toParentViewController: self)
    }

    @IBAction func onSkipClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    func skipTitle(_ title: String) {
        skipButton.setTitle(title, for: .normal)
    }
    
    func createPage(_ label: String, _ image: UIImage) -> UIViewController {
        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingContentViewController") as! OnboardingContentViewController
        contentViewController.pageLabelText = label
        contentViewController.pageImage = image
        return contentViewController
    }

}

extension OnboardingRootViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        skipTitle("Skip")
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else {
            skipTitle("Continue")
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

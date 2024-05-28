//
//  PostDetailViewController.swift
//  Post
//
//  Created by Bhanu on 28/05/24.
//

import UIKit

class PostDetailViewController: UIViewController {
  
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    // MARK: - Properties
    var post: Post?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewComponentSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: animated) 
      }
    
    //MARK: - UI Component SetUp
    private func viewComponentSetUp() {
        DisplayDetail()
        //computeAndDisplayDetails()
    }
    
    private func DisplayDetail() {
        if let post {
            titleLabel.text = post.title
            descriptionLabel.text = post.body
        }
    }
    
    ///- Note - Back Button Action
    @objc private func backButtonTapped() {
        //MARK: Handle back button action here
        navigationController?.popViewController(animated: true)
    }
    
    private func computeAndDisplayDetails() {
        guard let post else {
            return
        }
        
        computeIntensiveTask(for: post) { [weak self] timeElapsed in
            debugPrint("Time elapsed for computation: \(timeElapsed) seconds")
        }
    }
    
    func computeIntensiveTask(for post: Post, completion: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            ///- Note - Simulate heavy computation
            let _ = self.heavyComputation(for: post)
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            DispatchQueue.main.async {
                completion("\(timeElapsed)")
            }
        }
    }
    
    func heavyComputation(for post: Post) -> String {
        
        return "Computed value for post \(post.id)"
    }
    
}


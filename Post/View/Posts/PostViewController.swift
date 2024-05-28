//
//  PostViewController.swift
//  Post
//
//  Created by Bhanu on 28/05/24.
//
import UIKit

class PostViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var postTableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: PostsViewModel!
    private let scrollView = UIScrollView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewComponentSetUp()
    }
    
    //MARK: - UI Component SetUp
    private func viewComponentSetUp() {
        viewModel = PostsViewModel()
        setupTableView()
        setupScrollView()
        bindViewModel()
        viewModel.fetchPosts()
    }
    
    ///- Note - Scroll view configuration
    private func setupScrollView() {
        scrollView.delegate = self
        postTableView.addSubview(scrollView)
    }
    
    ///- Note: Table view setup
    private func setupTableView() {
        postTableView.dataSource = self
        postTableView.delegate = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: postTableView.bounds.width, height: 50))
        footerView.addSubview(activityIndicator)
        activityIndicator.center = footerView.center
        postTableView.tableFooterView = footerView
    }
    
    
    //MARK: - Api Handler
    private func bindViewModel() {
        viewModel.didUpdatePosts = { [weak self] in
            DispatchQueue.main.async {
                self?.postTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - UITableview delegate & dataSource
extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postTableViewCell, for: indexPath) as! PostTableViewCell
        let post = viewModel.posts[indexPath.row]
        cell.idLabel.text = "\(post.id)"
        cell.titleLabel.text = post.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Storyboard.main, bundle: nil)
        guard let postDetailVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.postDetailViewController) as? PostDetailViewController else {
            return
        }
        postDetailVC.post = viewModel.posts[indexPath.row]
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension PostViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if viewModel.hasMorePosts() {
                activityIndicator.startAnimating()
                viewModel.fetchPosts()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}




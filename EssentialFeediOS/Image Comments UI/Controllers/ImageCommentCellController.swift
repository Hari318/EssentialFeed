//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Hari on 24/02/24.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: NSObject, UITableViewDataSource {
    
    private let viewModel: ImageCommentViewModel
    
    public init (viewModel: ImageCommentViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageCommentsCell = tableView.dequeueReusableCell()
        
        cell.messageLabel.text = viewModel.message
        cell.usernameLabel.text = viewModel.username
        cell.dateLabel.text = viewModel.date
        
        return cell
    }
   
}

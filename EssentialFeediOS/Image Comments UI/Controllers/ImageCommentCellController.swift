//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Hari on 24/02/24.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    private let viewModel: ImageCommentViewModel
    
    public init (viewModel: ImageCommentViewModel) {
        self.viewModel = viewModel
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentsCell = tableView.dequeueReusableCell()
        
        cell.messageLabel.text = viewModel.message
        cell.usernameLabel.text = viewModel.username
        cell.dateLabel.text = viewModel.date
        
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
}

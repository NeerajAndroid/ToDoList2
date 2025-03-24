//
//  TaskTableViewCell.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 15/03/25.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func editTask(id: String)
    func markTask(id: String, isCompleted: Bool)
}

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"

    @IBOutlet weak var stripView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var isCompletedImage: UIImageView!
    var delegate: TaskTableViewCellDelegate?
    var taskModel: TaskModel?
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryContainer.layer.cornerRadius = categoryContainer.frame.height/2
        cellView.layer.cornerRadius = 8
        cellView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func ShowOptions(_ sender: Any) {
        guard let taskModel = taskModel else { return }
        delegate?.editTask(id: taskModel.id)
    }
    
    func configure(with task: TaskModel, delegate: TaskTableViewCellDelegate?){
        stripView.backgroundColor = task.category.color
        categoryContainer.backgroundColor = task.category.backgroundColor
        category.text = task.category.rawValue
        category.textColor = task.category.color
        caption.text = task.caption
        createdAt.text = dateFormatter.string(from: task.createdAt)
        isCompletedImage.image = UIImage(systemName: task.isCompleted ? "checkmark.circle" : "circle")
        selectionStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCompletion))
        addGestureRecognizer(tapGestureRecognizer)
        isCompletedImage.isUserInteractionEnabled = true
        self.taskModel = task
        self.delegate = delegate
    }
    
    @objc func toggleCompletion() {
        guard let taskModel = taskModel else { return }
        delegate?.markTask(id: taskModel.id, isCompleted: !taskModel.isCompleted)
    }

}

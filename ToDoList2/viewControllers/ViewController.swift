//
//  ViewController.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 14/03/25.
//

import UIKit
//import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleView: UILabel!
    var tasks: [TaskModel] = []
    //let realm =  try! Realm()
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var taskTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleContainerView.clipsToBounds = true
        titleContainerView.layer.cornerRadius = 24
        titleContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        taskTableView.dataSource = self
        taskTableView.estimatedRowHeight = 80
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.tableFooterView = UIView()
        taskTableView.separatorStyle = .none
        
        view.addSubview(addButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newTaskAdded(_:)), name: NSNotification.Name("NewTaskAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taskUpdated(_:)), name: NSNotification.Name("TaskUpdated"), object: nil)
    }
    
    @objc private func newTaskAdded(_ notification: Notification) {
        guard let userInfo =  notification.userInfo,
              let taskModel = userInfo["taskModel"] as? TaskModel else {
            return
        }
        tasks.append(taskModel)
        taskTableView.reloadData()
    }
    
    @objc private func taskUpdated(_ notification: Notification) {
        guard let userInfo =  notification.userInfo,
              let updatedTaskModel = userInfo["taskModel"] as? TaskModel else {
            return
        }
        let taskIndex = tasks.firstIndex{ taskModel in
            taskModel.id == updatedTaskModel.id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex] = updatedTaskModel
        taskTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaBottom = view.safeAreaInsets.bottom
        let width: CGFloat = 60
        let height: CGFloat = 60
        let xPos = view.frame.width/2 - width/2
        let yPos: CGFloat = view.frame.height - height - safeAreaBottom - 5
        addButton.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        addButton.layer.cornerRadius = height/2
    }
    
    @objc private func addButtonTapped() {
        openNewTaskVC(with: nil)
    }
    
    private func openNewTaskVC(with taskModel: TaskModel?) {
        let newTaskVC = NewTaskViewController(taskModel: taskModel)
        present(newTaskVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.configure(with: tasks[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            taskTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: TaskTableViewCellDelegate {
    func editTask(id: String) {
        let taskIndex = tasks.firstIndex { taskModel in
            taskModel.id == id
        }
        guard let taskIndex = taskIndex else { return }
        openNewTaskVC(with: tasks[taskIndex])
    }
    
    func markTask(id: String, isCompleted: Bool) {
        let taskIndex = tasks.firstIndex { taskModel in
            taskModel.id == id
        }
        guard let taskIndex = taskIndex else { return }
        tasks[taskIndex].isCompleted = isCompleted
        taskTableView.reloadData()
    }
}


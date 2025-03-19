//
//  NewTaskViewController.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 15/03/25.
//

import UIKit

protocol NewTaskDelegate {
    func closeModal()
}
class NewTaskViewController: UIViewController {
    var taskModel: TaskModel?
    lazy var modalView: NewTaskModalView = {
        let modalWidth: CGFloat = view.frame.width - 30
        let modalHeight: CGFloat = 450
        let yPos:CGFloat = view.center.y - (modalHeight/2)
        let frame = CGRect(x: 15, y: yPos, width: modalWidth, height: modalHeight)
        let modelView = NewTaskModalView(frame: frame, taskModel: taskModel)
        return modelView
    }()

    init (taskModel: TaskModel?) {
        super.init(nibName: nil as String?, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        self.taskModel = taskModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.addSubview(modalView)
        modalView.newTaskDelegate = self
        
    }

}

extension NewTaskViewController : NewTaskDelegate {
    func closeModal() {
        dismiss(animated: true)
    }
}

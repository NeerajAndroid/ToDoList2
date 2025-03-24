//
//  NewTaskModalView.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 15/03/25.
//

import UIKit

class NewTaskModalView: UIView {
    
    @IBOutlet private weak var captionTextView: UITextView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private var contentView: UIView!
    var newTaskDelegate: NewTaskDelegate?
    private var taskModel: TaskModel?
    
    @IBOutlet weak var submitButton: RoundedCornerButton!
    var caption: String {
        get { captionTextView.text }
        set { captionTextView.text = newValue }
    }
    
    init(frame: CGRect,taskModel: TaskModel? ) {
        super.init(frame: frame)
        self.taskModel = taskModel
        initSubviews()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubviews()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "NewTaskModalView", bundle: nil)
        nib.instantiate(withOwner: self)
        
        captionTextView.layer.borderWidth = 0.5
        captionTextView.layer.borderColor = UIColor.lightGray.cgColor
        captionTextView.layer.cornerRadius = 8
        
        captionTextView.delegate = self
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        
        if let taskModel = taskModel {
            captionTextView.text = taskModel.caption
            captionTextView.textColor = .label
            let selectedRow = CategoryModel.allCases.firstIndex(of: taskModel.category)!
            categoryPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        } else {
            captionTextView.text = "Add caption..."
            captionTextView.textColor = .placeholderText
            categoryPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5
    }
    
    @IBAction func onCrossClick(_ sender: Any) {
        newTaskDelegate?.closeModal()
    }
    
    @IBAction func OnSubmitClick(_ sender: Any) {
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        let category = CategoryModel.allCases[selectedRow]
        
        guard let captionText = captionTextView.text, captionText != "Add caption...", captionText.count > 4 else {
            return
        }
        
        if  let taskModel = taskModel {
            let taskModel: TaskModel = TaskModel(id: taskModel.id , caption: captionText, category: category, createdAt: taskModel.createdAt , isCompleted: taskModel.isCompleted)
            let userInfo: [String : TaskModel] = ["taskModel": taskModel]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TaskUpdated"), object: nil, userInfo: userInfo)
        } else {
            let taskModel: TaskModel = TaskModel(id: UUID().uuidString, caption: captionText, category: category, createdAt: Date() , isCompleted: false)
            let userInfo: [String : TaskModel] = ["taskModel": taskModel]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTaskAdded"), object: nil, userInfo: userInfo)
        }
        
        newTaskDelegate?.closeModal()
    }
    
    
}
extension NewTaskModalView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            captionTextView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            captionTextView.text = "Add caption..."
            textView.textColor = .placeholderText
        }
    }
}

extension NewTaskModalView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        CategoryModel.allCases.count
    }
}

extension NewTaskModalView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        CategoryModel.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = CategoryModel.allCases[row].rawValue
        return pickerLabel!
    }
}

//
//  CategoryModel.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 15/03/25.
//

import Foundation
import UIKit
//import RealmSwift, PersistableEnum

enum CategoryModel: String, CaseIterable  {
    case work = "Work",
         exercise = "Exercise",
         study = "Study",
         home = "Home"
    
    var color: UIColor {
        switch self {
        case .work:
            return .workColor
        case .exercise:
            return .exercise
        case .study:
            return .studyColor
        case .home:
            return .blue
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .work:
            return .workColor.withAlphaComponent(0.2)
        case .exercise:
            return .exercise.withAlphaComponent(0.2)
        case .study:
            return .studyColor.withAlphaComponent(0.2)
        case .home:
            return .blue.withAlphaComponent(0.2)
        }
    }
}

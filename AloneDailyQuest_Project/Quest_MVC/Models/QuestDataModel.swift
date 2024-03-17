//
//  QuestData.swift
//  AloneDailyQuest_Project
//
//  Created by Matthew on 2/28/24.
//

import Foundation

struct QuestDataModel {
    let id: UUID
    var quest: String
    var date: Date
    var selectedDate: [Bool]
    var repeatDay: String
    var completed: Bool
    
    init(id: UUID, quest: String, date: Date,  selectedDate: [Bool], repeatDay: String, completed: Bool) {
        self.id = id
        self.quest = quest
        self.date = date
        self.selectedDate = selectedDate
        self.repeatDay = repeatDay
        self.completed = completed
    }
}

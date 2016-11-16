//
//  LessonsTracking+CoreDataProperties.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 01/11/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension LessonsTracking {
    
    class func getStateFor(_ lesson: Lesson, in context: NSManagedObjectContext) -> LessonState?
    {
        let request: NSFetchRequest<LessonsTracking> = LessonsTracking.fetchRequest()
        request.predicate = NSPredicate(format: "index = %d", Int16(lesson.index))
        
        if let l = (try? context.fetch(request))?.first {
            return LessonState(rawValue: l.state!)
        }
        
        return nil
    }
    
    class func setStateFor(_ lesson: Lesson, in context: NSManagedObjectContext) -> LessonState?
    {
        let request: NSFetchRequest<LessonsTracking> = LessonsTracking.fetchRequest()
        request.predicate = NSPredicate(format: "index = %d", Int16(lesson.index))
        
        if let l = (try? context.fetch(request))?.first {
            if let state = lesson.state {
                l.state = state.rawValue
            }
            return LessonState(rawValue: l.state!)
        } else if let l = NSEntityDescription.insertNewObject(forEntityName: "LessonsTracking", into: context) as? LessonsTracking {
            l.index = Int16(lesson.index)
            l.state = LessonState.new.rawValue
            return LessonState.new
        }
        
        return nil
    }
    
}

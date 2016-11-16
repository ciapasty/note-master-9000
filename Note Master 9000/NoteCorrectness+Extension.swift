//
//  NoteCorrectness+CoreDataProperties.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 01/11/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension NoteCorrectness {

    class func setup(note: Note, inClef clef: Clef, in context: NSManagedObjectContext) {
        let request: NSFetchRequest<NoteCorrectness> = NoteCorrectness.fetchRequest()
        request.predicate = NSPredicate(format: "clef = %@ AND noteID = %d", clef.rawValue, Int16(note.rawValue))
        
        if let _ = (try? context.fetch(request))?.first {
            return
        } else if let nc = NSEntityDescription.insertNewObject(forEntityName: "NoteCorrectness", into: context) as? NoteCorrectness {
            nc.clef = clef.rawValue
            nc.noteID = Int16(note.rawValue)
        }
    }
    
    class func add(correctAnswer correct: Bool, forNote note: Note, inClef clef: Clef, in context: NSManagedObjectContext) {
        let request: NSFetchRequest<NoteCorrectness> = NoteCorrectness.fetchRequest()
        request.predicate = NSPredicate(format: "clef = %@ AND noteID = %d", clef.rawValue, Int16(note.rawValue))
        
        if let nc = (try? context.fetch(request))?.first {
            if correct {
                nc.goodCount += 1
            } else {
                nc.badCount += 1
            }
            nc.goodBadRatio = Float(nc.goodCount)/Float(nc.badCount)
            print(note, nc.goodBadRatio)
            
        } else if let nc = NSEntityDescription.insertNewObject(forEntityName: "NoteCorrectness", into: context) as? NoteCorrectness {
            nc.clef = clef.rawValue
            nc.noteID = Int16(note.rawValue)
            if correct {
                nc.goodCount = 1
            } else {
                nc.badCount = 1
            }
            nc.goodBadRatio = Float(nc.goodCount)/Float(nc.badCount)
            print(note, nc.goodBadRatio)
        }
    }
    
    class func fetchNoteStats(inClef clef: Clef, recordsCount n: Int, ascending: Bool, in context: NSManagedObjectContext) {
        let request: NSFetchRequest<NoteCorrectness> = NoteCorrectness.fetchRequest()
        request.predicate = NSPredicate(format: "clef = %@", clef.rawValue)
        request.fetchLimit = n
        request.sortDescriptors = [NSSortDescriptor(key: "goodBadRatio", ascending: ascending)]
        
        if let ncs = try? context.fetch(request) {
            for nc in ncs {
                print(nc.noteID, nc.goodBadRatio)
            }
        }
    }
}

//
//  DatabaseManager.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 05.06.2024.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    
    private let verbsTable = Table("verbs")
    private let id = Expression<Int64>("id")
    private let verb = Expression<String>("verb")
    private let language = Expression<String>("language")
    private let gerund = Expression<String>("gerund")
    private let participle = Expression<String>("participle")
    private let translation = Expression<String>("translation")
    private let regularity = Expression<String>("regularity")
    
    private let conjugationsTable = Table("conjugations")
    private let verb_id = Expression<Int64>("verb_id")
    private let tense = Expression<String>("tense")
    private let mood = Expression<String>("mood")
    private let person = Expression<String>("person")
    private let conjugation = Expression<String>("conjugation")
    private let is_irregular = Expression<Bool>("is_irregular") // New column for irregular conjugations
    
    private init() {
        connectDatabase()
    }
    
    private func connectDatabase() {
        do {
            if let path = Bundle.main.path(forResource: "verb_conjugations", ofType: "db") {
                db = try Connection(path)
            }
        } catch {
            print("Unable to connect to database: \(error)")
        }
    }
    
    func fetchVerbs() -> [String] {
        var verbsList = [String]()
        
        do {
            guard let db = db else { return [] }
            for verb in try db.prepare(verbsTable) {
                if let verbName = try? verb.get(self.verb) {
                    verbsList.append(verbName)
                }
            }
        } catch {
            print("Failed to fetch verbs: \(error)")
        }
        
        return verbsList
    }
    
    func fetchVerbs(in language: String) -> [String] {
        var verbsList = [String]()
        
        do {
            guard let db = db else { return [] }
            let query = verbsTable.filter(self.language == language)
            for verb in try db.prepare(query) {
                if let verbName = try? verb.get(self.verb) {
                    verbsList.append(verbName)
                }
            }
        } catch {
            print("Failed to fetch verbs: \(error)")
        }
        
        return verbsList
    }
    
    func fetchVerbDetails(for verbName: String, in language: String) -> VerbDetails? {
        do {
            guard let db = db else { return nil }
            
            let query = verbsTable.filter(verb == verbName && self.language == language)
            
            if let verbRow = try db.pluck(query) {
                let verbId = try verbRow.get(id)
                let verb = try verbRow.get(self.verb)
                let translation = try verbRow.get(self.translation)
                let gerund = try verbRow.get(self.gerund)
                let participle = try verbRow.get(self.participle)
                
                let regularity = try verbRow.get(self.regularity)
                
                let indicativePresent = fetchConjugations(for: verbId, tense: "Present", mood: "Indicative")
                let indicativePreterite = fetchConjugations(for: verbId, tense: "Preterite", mood: "Indicative")
                let indicativeImperfect = fetchConjugations(for: verbId, tense: "Imperfect", mood: "Indicative")
                let indicativeFuture = fetchConjugations(for: verbId, tense: "Future", mood: "Indicative")
                let indicativeConditional = fetchConjugations(for: verbId, tense: "Conditional", mood: "Indicative")
                
                let subjunctivePresent = fetchConjugations(for: verbId, tense: "Present", mood: "Subjunctive")
                let subjunctiveImperfect = fetchConjugations(for: verbId, tense: "Imperfect", mood: "Subjunctive")
                let subjunctiveFuture = fetchConjugations(for: verbId, tense: "Future", mood: "Subjunctive")
                
                let imperative = fetchConjugations(for: verbId, tense: "Imperative", mood: "Affirmative")
                
                return VerbDetails(
                    verb: verb,
                    translation: translation,
                    gerund: gerund,
                    participle: participle,
                    regularity: regularity,
                    indicativePresent: indicativePresent,
                    indicativePreterite: indicativePreterite,
                    indicativeImperfect: indicativeImperfect,
                    indicativeFuture: indicativeFuture,
                    indicativeConditional: indicativeConditional,
                    subjunctivePresent: subjunctivePresent,
                    subjunctiveImperfect: subjunctiveImperfect,
                    subjunctiveFuture: subjunctiveFuture,
                    imperative: imperative
                )
            }
        } catch {
            print("Failed to fetch verb details: \(error)")
        }
        
        return nil
    }
    
    func fetchVerbByTranslation(_ translation: String, excluding language: String) -> String? {
        do {
            guard let db = db else { return nil }
            
            let query = verbsTable.filter(self.translation == translation && self.language != language)
            
            if let verbRow = try db.pluck(query) {
                return try verbRow.get(self.verb)
            }
        } catch {
            print("Failed to fetch verb by translation: \(error)")
        }
        
        return nil
    }
    
    private func fetchConjugations(for verbId: Int64, tense: String, mood: String) -> [String: Conjugation] {
        var conjugations = [String: Conjugation]()
        
        do {
            guard let db = db else { return [:] }
            
            let query = conjugationsTable.filter(verb_id == verbId && self.tense == tense && self.mood == mood)
            
            for conjugationRow in try db.prepare(query) {
                let person = try conjugationRow.get(self.person)
                let conjugationText = try conjugationRow.get(self.conjugation)
                let isIrregular: Bool
                if let isIrregularValue = try? conjugationRow.get(self.is_irregular) {
                    isIrregular = isIrregularValue
                } else {
                    isIrregular = false
                }
                print("Person: \(person), Conjugation: \(conjugationText), Is Irregular: \(isIrregular)")
                conjugations[person] = Conjugation(text: conjugationText, isIrregular: isIrregular)
            }
        } catch {
            print("Failed to fetch conjugations: \(error)")
        }
        
        return conjugations
    }
    
    func fetchMatchingVerb(for verb: String, fromLanguage: String, toLanguage: String) -> String? {
        do {
            guard let db = db else { return nil }
            
            print("Fetching matching verb for: \(verb.lowercased()), fromLanguage: \(fromLanguage), toLanguage: \(toLanguage)")
            
            // Fetch the translation of the given verb in the source language
            let querySource = verbsTable.filter(self.verb.lowercaseString == verb.lowercased() && self.language == fromLanguage)
            guard let sourceVerbRow = try db.pluck(querySource) else {
                print("No source verb found for \(verb.lowercased()) in \(fromLanguage)")
                return nil
            }
            let translation = try sourceVerbRow.get(self.translation)
            print("Found translation: \(translation)")
            
            // Fetch the verb in the target language that has the same translation
            let queryTarget = verbsTable.filter(self.translation == translation && self.language == toLanguage)
            if let targetVerbRow = try db.pluck(queryTarget) {
                let matchingVerb = try targetVerbRow.get(self.verb)
                print("Found matching verb: \(matchingVerb) in \(toLanguage)")
                return matchingVerb
            } else {
                print("No matching verb found in \(toLanguage) for translation: \(translation)")
            }
        } catch {
            print("Failed to fetch matching verb: \(error)")
        }
        
        return nil
    }
}

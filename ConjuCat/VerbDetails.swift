//
//  VerbDetails.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 05.06.2024.
//

import Foundation

struct VerbDetails {
    var verb: String
    var translation: String
    var gerund: String
    var participle: String
    var regularity: String
    
    var indicativePresent: [String: Conjugation]
    var indicativePreterite: [String: Conjugation]
    var indicativeImperfect: [String: Conjugation]
    var indicativeFuture: [String: Conjugation]
    var indicativeConditional: [String: Conjugation]
    var subjunctivePresent: [String: Conjugation]
    var subjunctiveImperfect: [String: Conjugation]
    var subjunctiveFuture: [String: Conjugation]
    var imperative: [String: Conjugation]
}


struct VerbNavigationData: Hashable {
    let verb: String
    let language: String
}


struct Conjugation {
    var text: String
    var isIrregular: Bool
}

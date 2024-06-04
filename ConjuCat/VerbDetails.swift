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
    var indicativePresent: [String: String]
    var indicativePreterite: [String: String]
    var indicativeImperfect: [String: String]
    var indicativeFuture: [String: String]
    var indicativeConditional: [String: String]
    var subjunctivePresent: [String: String]
    var subjunctiveImperfect: [String: String]
    var subjunctiveFuture: [String: String]
    var imperative: [String: String]
}

struct VerbNavigationData: Hashable {
    let verb: String
    let language: String
}

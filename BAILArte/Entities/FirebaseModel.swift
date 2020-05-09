//
//  FirebaseModel.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

//import Foundation
//import FirebaseDatabase.FIRDataSnapshot
//
//protocol SelfProperties {
//    func listOfProperties() -> [String: Any]
//}
//
//extension SelfProperties {
//    func listOfProperties() -> [String: Any] {
//        var vars: [String: Any] = [:]
//        Mirror(reflecting: self).children.forEach { child in
//            vars[child.label ?? ""] = child.value
//        }
//        
//        return vars
//    }
//}
//
//protocol FirebaseModel: Codable, SelfProperties {
//    init?(snapshot: DataSnapshot)
//    init?(dictionary: [String: Any]?)
//    
//    func encode() throws -> Data
//    func toDictionary() -> [String: Any]
//    func jsonString() -> String
//}
//
//extension FirebaseModel {
//    init?(snapshot: DataSnapshot) {
//        guard snapshot.exists() else { return nil }
//        self.init(dictionary: snapshot.value as? [String: Any])
//    }
//    
//    init?(dictionary: [String: Any]?) {
//        guard let dictionary = dictionary else { return nil }
//        
//        do {
//            let data = try JSONSerialization.data(withJSONObject: dictionary)
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .millisecondsSince1970
//            self = try decoder.decode(Self.self, from: data)
//        } catch {
//            print("\(Self.self) decoding error: \(error)")
//            return nil
//        }
//    }
//    
//    func encode() throws -> Data {
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
//            var container = encoder.singleValueContainer()
//            try container.encode(date.currentTimeMillis)
//        })
//        encoder.outputFormatting = .prettyPrinted
//        return try encoder.encode(self)
//    }
//    
//    func toDictionary() -> [String: Any] {
//        do {
//            let data = try encode()
//            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                return dict
//            }
//        } catch {
//            print("\(Self.self) encoding error: \(error)")
//        }
//        return [:]
//    }
//    
//    func jsonString() -> String {
//        do {
//            let data = try encode()
//            return String(data: data, encoding: .utf8) ?? ""
//        } catch {
//            print("\(Self.self) encoding error: \(error)")
//        }
//        return ""
//    }
//
//}

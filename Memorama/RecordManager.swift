//
//  RecordManager.swift
//  Memorama
//
//  Created by imac on 16/08/24.
//

import Foundation

class RecordManager {
    static let shared = RecordManager()
    private let plistFileName = "Records.plist"
    
    private init() {}
    
    func getRecords() -> [Record] {
        if let url = getPlistURL(),
           let data = try? Data(contentsOf: url),
           let records = try? PropertyListDecoder().decode([Record].self, from: data) {
            return records
        }
        return []
    }
    
    func saveRecord(_ record: Record) {
        var records = getRecords()
        records.append(record)
        records.sort { $0.score < $1.score } // Ordena por puntaje (ascendente)
        
        if records.count > 5 {
            records = Array(records.prefix(5)) // Mantén solo los 5 mejores
        }
        
        if let url = getPlistURL(),
           let data = try? PropertyListEncoder().encode(records) {
            try? data.write(to: url)
        }
    }
    
    private func getPlistURL() -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsDirectory.appendingPathComponent(plistFileName)
    }
}

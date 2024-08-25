//
//  RecordsViewController.swift
//  Memorama
//
//  Created by imac on 19/08/24.
//

import UIKit

class RecordsViewController: UIViewController {

    @IBOutlet weak var recordsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cargar los registros y mostrar los 5 mejores
        let playerRecords = loadPlayerRecords()
        print(playerRecords)
        let topRecords = playerRecords.prefix(5)
        
        // Formatear los registros para mostrarlos en el label
        var recordsText = ""
        if topRecords.isEmpty {
            recordsText = "No hay records por mostrar"
        } else {
            for (index, record) in topRecords.enumerated() {
                recordsText += "\(index + 1). \(record.name): \(record.score)\n"
            }
        }
        
        // Asignar el texto al label
        recordsLabel.text = recordsText
    }
    
    func loadPlayerRecords() -> [PlayerRecord] {
        if let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PlayerRecords.plist"),
           let data = try? Data(contentsOf: plistURL) {
            do {
                let playerRecords = try PropertyListDecoder().decode([PlayerRecord].self, from: data)
                return playerRecords
            } catch {
                print("Error al cargar los records: \(error)")
            }
        }
        return []
    }
}


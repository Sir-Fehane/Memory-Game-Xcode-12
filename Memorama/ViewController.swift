//
//  ViewController.swift
//  Memorama
//
//  Created by imac on 13/08/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var timerLabels: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    
    @IBOutlet weak var button13: UIButton!
    
    @IBOutlet weak var button14: UIButton!
    
    @IBOutlet weak var button15: UIButton!
    
    @IBOutlet weak var button16: UIButton!
    
    @IBOutlet weak var button17: UIButton!
    
    @IBOutlet weak var button18: UIButton!
    var images = [String]()
    var uniqueImages = [
        "image1",
        "image2",
        "image3",
        "image4",
        "image5",
        "image6",
        "image7",
        "image8",
        "image9",
        "image10",
        "image11",
        "image12",
    ]
    
    var buttons = [UIButton]()
    
    var click = 1
    
    var click1 = 0
    var click2 = 0
    
    var points = 0
    
    var timer: Timer?
    var timeRemaining = 180
    
    var contadorReiniciar = 0
    
    var correctSound: AVAudioPlayer?
    var incorrectSound: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortImages()
        startTimer()
        setupSounds()
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        buttons.append(button5)
        buttons.append(button6)
        buttons.append(button7)
        buttons.append(button8)
        buttons.append(button9)
        buttons.append(button10)
        buttons.append(button11)
        buttons.append(button12)
        buttons.append(button13)
        buttons.append(button14)
        buttons.append(button15)
        buttons.append(button16)
        buttons.append(button17)
        buttons.append(button18)
        
    }
    func compare() {
        if self.click1 == self.click2 {
            self.incorrectSound?.play()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.buttons[self.click1-1].setImage(UIImage(named: "image"), for: .normal)
                self.click = 1
                self.click1 = 0
                self.click2 = 0
                self.points = self.points + 1
                self.playerLabel.text = "Errores: \(self.points)"
            }
            
            return
        }
        if images[click1-1] == images[click2-1] {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.correctSound?.play()
                self.buttons[self.click1-1].alpha = 0
                self.buttons[self.click2-1].alpha = 0
                self.contadorReiniciar = self.contadorReiniciar + 1
                if self.contadorReiniciar == 9{
                    self.showWinnerAlert()
                    self.stopTimer()
                }
            }
        } else {
            self.incorrectSound?.play()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                self.buttons[self.click1-1].setImage(UIImage(named: "image"), for: .normal)
                self.buttons[self.click2-1].setImage(UIImage(named: "image"), for: .normal)
                self.points = self.points + 1
                self.playerLabel.text = "Errores: \(self.points)"
                
            }
        }
    }
    func showWinnerAlert() {
        let timeRemaining = self.timeRemaining
        print("Tiempo restante: \(timeRemaining)")
        
        let mistakes = self.points

        let score = max(0, Int(timeRemaining) - (mistakes * 2))

        let message = "Has ganado el juego con una puntuación de \(score) puntos."

        let alert = UIAlertController(title: "¡Felicidades!", message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Ingresa tu nombre"
        }
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self, let playerName = alert.textFields?.first?.text else { return }
            
            self.savePlayerRecord(score: score, playerName: playerName)
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        present(alert, animated: true, completion: nil)
    }



    func showAlertAndDismiss(title: String, message: String, dismissDelay: TimeInterval) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        present(alert, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
                alert.dismiss(animated: true) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func setupSounds() {
        if let correctSoundURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
            correctSound = try? AVAudioPlayer(contentsOf: correctSoundURL)
            correctSound?.prepareToPlay()
        }
        
        if let incorrectSoundURL = Bundle.main.url(forResource: "incorrect", withExtension: "mp3") {
            incorrectSound = try? AVAudioPlayer(contentsOf: incorrectSoundURL)
            incorrectSound?.prepareToPlay()
        }
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateTimerLabel()
            } else {
                self.stopTimer()
                for button in self.buttons{
                    button.isEnabled = false
                }
                print("Se acabo el tiempo")
            }
        }
    }
    
    func updateTimerLabel() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timerLabels.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        showAlertAndDismiss(title: "Tiempo agotado", message: "Se ha acabado el tiempo.", dismissDelay: 1)
    }
    
    func resetTimer() {
        stopTimer()
        timeRemaining = 180
        updateTimerLabel()
    }
    
    deinit {
        stopTimer()
    }
    
    func sortImages(){
        images.removeAll()
        uniqueImages.shuffle()
        for i in 0...8 {
            images.append(uniqueImages[i])
            images.append(uniqueImages[i])
        }
        images.shuffle()
        
        print(images)
    }
    
     @IBAction func button1Action(_ sender: Any) {
        if click == 1 {
            button1.setImage(UIImage(named: images[0]), for: .normal)
            click = 2
            click1 = 1
        } else if click == 2 {
            button1.setImage(UIImage(named: images[0]), for: .normal)
            click = 1
            click2 = 1
            
            compare()
        }
    }
    @IBAction func button2Action(_ sender: Any) {
        if click == 1 {
            button2.setImage(UIImage(named: images[1]), for: .normal)
            click = 2
            click1 = 2
        } else if click == 2 {
            button2.setImage(UIImage(named: images[1]), for: .normal)
            click = 1
            click2 = 2
            
            compare()
        }
    }
    @IBAction func button3Action(_ sender: Any) {
        if click == 1 {
            button3.setImage(UIImage(named: images[2]), for: .normal)
            click = 2
            click1 = 3
        } else if click == 2 {
            button3.setImage(UIImage(named: images[2]), for: .normal)
            click = 1
            click2 = 3
            
            compare()
        }
    }
    
    
    @IBAction func button4Action(_ sender: Any) {
        if click == 1 {
            button4.setImage(UIImage(named: images[3]), for: .normal)
            click = 2
            click1 = 4
        } else if click == 2 {
            button4.setImage(UIImage(named: images[3]), for: .normal)
            click = 1
            click2 = 4
            
            compare()
        }
    }
    @IBAction func button5Action(_ sender: Any) {
        if click == 1 {
            button5.setImage(UIImage(named: images[4]), for: .normal)
            click = 2
            click1 = 5
        } else if click == 2 {
            button5.setImage(UIImage(named: images[4]), for: .normal)
            click = 1
            click2 = 5
            
            compare()
        }
    }
    @IBAction func button6Action(_ sender: Any) {
        if click == 1 {
            button6.setImage(UIImage(named: images[5]), for: .normal)
            click = 2
            click1 = 6
        } else if click == 2 {
            button6.setImage(UIImage(named: images[5]), for: .normal)
            click = 1
            click2 = 6
            
            compare()
        }
    }
    
    
    @IBAction func button7Action(_ sender: Any) {
        if click == 1 {
            button7.setImage(UIImage(named: images[6]), for: .normal)
            click = 2
            click1 = 7
        } else if click == 2 {
            button7.setImage(UIImage(named: images[6]), for: .normal)
            click = 1
            click2 = 7
            
            compare()
        }
    }
    @IBAction func button8Action(_ sender: Any) {
        if click == 1 {
            button8.setImage(UIImage(named: images[7]), for: .normal)
            click = 2
            click1 = 8
        } else if click == 2 {
            button8.setImage(UIImage(named: images[7]), for: .normal)
            click = 1
            click2 = 8
            
            compare()
        }
    }
    @IBAction func button9Action(_ sender: Any) {
        if click == 1 {
            button9.setImage(UIImage(named: images[8]), for: .normal)
            click = 2
            click1 = 9
        } else if click == 2 {
            button9.setImage(UIImage(named: images[8]), for: .normal)
            click = 1
            click2 = 9
            
            compare()
        }
    }
    
    @IBAction func button10Action(_ sender: Any) {
        if click == 1 {
            button10.setImage(UIImage(named: images[9]), for: .normal)
            click = 2
            click1 = 10
        } else if click == 2 {
            button10.setImage(UIImage(named: images[9]), for: .normal)
            click = 1
            click2 = 10
            
            compare()
        }
    }
    @IBAction func button11Action(_ sender: Any) {
        if click == 1 {
            button11.setImage(UIImage(named: images[10]), for: .normal)
            click = 2
            click1 = 11
        } else if click == 2 {
            button11.setImage(UIImage(named: images[10]), for: .normal)
            click = 1
            click2 = 11
            
            compare()
        }
    }
    @IBAction func button12Action(_ sender: Any) {
        if click == 1 {
            button12.setImage(UIImage(named: images[11]), for: .normal)
            click = 2
            click1 = 12
        } else if click == 2 {
            button12.setImage(UIImage(named: images[11]), for: .normal)
            click = 1
            click2 = 12
            
            compare()
        }
    }
    
    
    @IBAction func button13Action(_ sender: Any) {
        if click == 1 {
            button13.setImage(UIImage(named: images[12]), for: .normal)
            click = 2
            click1 = 13
        } else if click == 2 {
            button13.setImage(UIImage(named: images[12]), for: .normal)
            click = 1
            click2 = 13
            
            compare()
        }
    }
    
    @IBAction func button14Action(_ sender: Any) {
        if click == 1 {
            button14.setImage(UIImage(named: images[13]), for: .normal)
            click = 2
            click1 = 14
        } else if click == 2 {
            button14.setImage(UIImage(named: images[13]), for: .normal)
            click = 1
            click2 = 14
            
            compare()
        }
    }
    
    @IBAction func button15Action(_ sender: Any) {
        if click == 1 {
            button15.setImage(UIImage(named: images[14]), for: .normal)
            click = 2
            click1 = 15
        } else if click == 2 {
            button15.setImage(UIImage(named: images[14]), for: .normal)
            click = 1
            click2 = 15
            
            compare()
        }
    }
    
    @IBAction func button16Action(_ sender: Any) {
        if click == 1 {
            button16.setImage(UIImage(named: images[15]), for: .normal)
            click = 2
            click1 = 16
        } else if click == 2 {
            button16.setImage(UIImage(named: images[15]), for: .normal)
            click = 1
            click2 = 16
            
            compare()
        }
    }
    
    @IBAction func button17Action(_ sender: Any) {
        if click == 1 {
            button17.setImage(UIImage(named: images[16]), for: .normal)
            click = 2
            click1 = 17
        } else if click == 2 {
            button17.setImage(UIImage(named: images[16]), for: .normal)
            click = 1
            click2 = 17
            
            compare()
        }
    }
    
    @IBAction func button18Action(_ sender: Any) {
        if click == 1 {
            button18.setImage(UIImage(named: images[17]), for: .normal)
            click = 2
            click1 = 18
        } else if click == 2 {
            button18.setImage(UIImage(named: images[17]), for: .normal)
            click = 1
            click2 = 18
            
            compare()
        }
    }
    
   
}
extension ViewController {
    func savePlayerRecord(score: Int, playerName: String) {
        var playerRecords = loadPlayerRecords()
        let newRecord = PlayerRecord(name: playerName, score: score)
        playerRecords.append(newRecord)
        
        // Ordenar por puntuación descendente y mantener solo los primeros 5 registros
        playerRecords.sort { $0.score > $1.score }
        playerRecords = Array(playerRecords.prefix(5))
        
        // Guardar en PlayerRecords.plist en el directorio de documentos
        if let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PlayerRecords.plist") {
            do {
                let data = try PropertyListEncoder().encode(playerRecords)
                try data.write(to: plistURL)
                print("Guardado exitosamente en: \(plistURL)")
            } catch {
                print("Error al guardar los records: \(error)")
            }
        } else {
            print("Error: No se pudo obtener la URL del archivo PlayerRecords.plist")
        }
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

struct PlayerRecord: Codable {
    var name: String
    var score: Int
}

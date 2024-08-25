//
//  menuViewController.swift
//  Memorama
//
//  Created by imac on 16/08/24.
//

import UIKit
import AVFoundation

class menuViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioPlayer?.play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer?.stop()
    }

    func iniciarAudio() {
        let audioFilename = "shop"
        if let audioURL = Bundle.main.url(forResource: audioFilename, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer.numberOfLoops = -1 // Para que el sonido se repita indefinidamente
                audioPlayer.play()
            } catch {
                print("Error al inicializar el reproductor de audio: \(error.localizedDescription)")
            }
        } else {
            print("Archivo de audio no encontrado")
        }
    }

    @IBAction func play(_ sender: Any) {
        audioPlayer?.stop()
    }
}

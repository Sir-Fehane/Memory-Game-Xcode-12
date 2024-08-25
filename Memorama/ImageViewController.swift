//
//  ImageViewController.swift
//  Memorama
//
//  Created by imac on 16/08/24.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imgv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let w = 0.8 * view.frame.width
        let h = 0.43 * w
        let x = (view.frame.width - w)/2
        let y = -h
        imgv.frame = CGRect(x: x, y: y, width: w, height: h)
        imgv.alpha = 0.0
    }
    override func viewDidAppear(_ animated: Bool)
    {
        UIView.animate(withDuration: 2) {
            self.imgv.frame.origin.y = (self.view.frame.height - self.imgv.frame.height)/2
            self.imgv.alpha = 1.0
        } completion: { respuesta in
            self.performSegue(withIdentifier: "menu", sender: nil) 
        }
    }

}

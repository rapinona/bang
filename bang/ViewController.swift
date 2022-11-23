//
//  ViewController.swift
//  Alcoholimetro
//
//  Created by Ángel González on 03/06/22.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var X: UILabel!
    @IBOutlet var Y: UILabel!
    @IBOutlet var Z: UILabel!
    
    var previusX = 0.0
    var previusY = 0.0
    var previusZ = 0.0
    
    var player = AVAudioPlayer()
    
    let motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    var activo = false
    
    override func viewDidLoad() {
        iniciaAcelerometro()
    }

    
    func iniciaAcelerometro () {
        
            motionManager.startAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: motionQueue) { (data: CMAccelerometerData?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }

            let motion: CMAcceleration = data.acceleration

            DispatchQueue.main.async {
                self.X.text = "X = "+String(motion.x)
                self.Y.text = "Y = "+String(motion.y)
                self.Z.text = "Z = "+String(motion.z)
                
                if(self.previusX != 0.0 && self.previusY != 0.0 && self.previusZ != 0.0 && self.activo==false){
                    if(abs(self.previusX-motion.x) > 0.7 || abs(self.previusY-motion.y) > 0.7 || abs(self.previusZ-motion.z) > 0.7){
                        
                        self.activo = true
                        
                        let path = Bundle.main.path(forResource: "loud_bang", ofType: "mp3")!
                            let url = URL(fileURLWithPath: path)

                            do {
                                //create your audioPlayer in your parent class as a property
                                self.player = try AVAudioPlayer(contentsOf: url)
                                self.player.play()
                                print("deberia sonar")
                            } catch {
                                print("couldn't load the file")
                            }
                        
                        let alert = UIAlertController(title: "Alerta", message: "El dispositivo esta siendo agitado, la alarma se activo.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Silenciar", comment: "Default action"), style: .default, handler: { _ in
                            self.activo = false
                        }))
                        self.present(alert, animated: true, completion: nil)

                        
                    }
                }
                
                self.previusX = motion.x
                self.previusY = motion.y
                self.previusZ = motion.z
                
            }
        }
    }
}

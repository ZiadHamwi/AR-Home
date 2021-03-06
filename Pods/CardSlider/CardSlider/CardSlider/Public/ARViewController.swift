//
//  ViewController.swift
//  ar
//
//  Created by Ziad Hamwi on 2/4/21.
//


import UIKit
import SceneKit
import ARKit
import SceneKit.ModelIO
import AVFoundation

//play audio when house is displayed
var audioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "Doorbell-sound-effect.wav")!
    source.loops = false
    source.load()
    return source
}()
var titleNode = SCNNode()
var descNode = SCNNode()

class VirtualObjectNode: SCNNode {
    var AR_Object = ""
    
    enum VirtualObjectType {
        case houseObject
    }
    
    
    init(type: VirtualObjectType = .houseObject, _ arObject:String) {
        super.init()
        AR_Object = arObject;

        let scale = 0.1
        switch type {
        case .houseObject:
            loadScn(name: AR_Object, inDirectory: "Objects/Models")
        }
        self.scale = SCNVector3(scale, scale, scale);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func react() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.3
        SCNTransaction.completionBlock = {
            SCNTransaction.animationDuration = 0.15
            self.opacity = 1.0
        }
        self.opacity = 0.5
        SCNTransaction.commit()
    }
    func loadScn(name: String, inDirectory directory: String) {
        if #available(iOS 13.0, *) {
            //load data from json
            let data = DataLoader().userData
            
            
            guard let scene = SCNScene(named: "\(name).scn", inDirectory: directory) else { fatalError() }
            
            for child in scene.rootNode.childNodes {
                child.geometry?.firstMaterial?.lightingModel = .physicallyBased
                addChildNode(child)
            }
            
            //add text over the house from the information in the json file
            for houses in data{
                if houses.houseName == name{
                    titleNode = textNode(houses.houseName, font: UIFont.boldSystemFont(ofSize: 112))
                    titleNode.position.x += Float(scene.rootNode.position.x * 2) - 0.5
                    titleNode.position.y += Float(scene.rootNode.position.y * 2) + 1.7
                    titleNode.isHidden = true
                    addChildNode(titleNode)

                    let text = "Area: " + houses.area + "\nBedrooms: " + houses.bathrooms + "\nBathrooms: " + houses.bathrooms + "\n" + houses.furnished
                    descNode = textNode(text, font: UIFont.boldSystemFont(ofSize: 110))
                    descNode.position.x += Float(scene.rootNode.position.x * 2) + 1.5
                    descNode.position.y += Float(scene.rootNode.position.y * 2) - 0.3
                    descNode.isHidden = true
                    addChildNode(descNode)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)

        text.flatness = 0.1
        text.font = font

        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }

        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)

        return textNode
    }
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
        var current_AR_Object = ""
    var i = 1;
    
    @IBOutlet weak var statusLbl: UILabel!
    
    
    @IBOutlet weak var toggleDebugPoints: UISwitch!
    
    @IBOutlet weak var toggleInteriorExterior: UIButton!
    
    var interiorState = false;
    var firstRun = true
    var tempText = ""
    
    var infoDisplay = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        styleButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        view.addGestureRecognizer(tap)

        
        
        if firstRun {
            statusLbl.text = "Move iPhone to begin..."
            UIView.animate(withDuration: 1) {
                self.toggleDebugPoints.alpha = 1
                self.delay(0.5) {
                    UIView.animate(withDuration: 1) {
                        self.toggleInteriorExterior.alpha = 1
                    }
                }
            }
        firstRun = false
        }

    }
    
    
    
    func styleButton() {
        toggleInteriorExterior.setTitle("Switch to Interior", for: .normal)
        toggleInteriorExterior.backgroundColor = .white
        toggleInteriorExterior.clipsToBounds = true
        toggleInteriorExterior.tintColor = .red
        toggleInteriorExterior.layer.cornerRadius = 10
        toggleInteriorExterior.layer.borderWidth = 1
        toggleInteriorExterior.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run()
    }
    
    //for sound when scene leaves the view
    var audioPlayer2 = AVAudioPlayer()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //sound
        let sound = Bundle.main.path(forResource: "door-7-close", ofType: "wav")
        do{
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch{
            print(error)
        }
        audioPlayer2.play()
        sceneView.session.pause()
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let frame = sceneView.session.currentFrame else {return}
//        sceneView.updateLightingEnvironment(for: frame)
//    }
   
    
    @objc func tapView(_ sender: UITapGestureRecognizer? = nil) {
        
        
        
        if !infoDisplay {
            updateStatusLbl("More Info")
            titleNode.isHidden = false
            descNode.isHidden = false
            infoDisplay = !infoDisplay
        }
        else {
            updateStatusLbl("Tap Screen For More Info")
            titleNode.isHidden = true
            descNode.isHidden = true
            infoDisplay = !infoDisplay

        }
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        print("\(self.classForCoder)/" + #function)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        

        print("House Anchored!")
        
        var virtualNode = VirtualObjectNode(current_AR_Object)
        
//        node.addChildNode(virtualNode)
        DispatchQueue.main.async(execute: {
            if (self.i == 1) {
                self.i += 1
                UIView.animate(withDuration: 0.1) {
                    self.statusLbl.alpha = 0
                    self.delay(0.25) {
                        self.statusLbl.text = "Surface Detected"
                        self.statusLbl.alpha = 1
                        
                        self.delay(0.25) {
                            self.statusLbl.alpha = 0
                            
                            self.delay(0.5) {
                                self.statusLbl.text = "House Anchored"
                                self.statusLbl.alpha = 1
                                
                                self.delay(2) {
                                    self.statusLbl.alpha = 0
                                    self.delay(0.25) {
                                        self.statusLbl.text = "Tap Screen For More Info"
                                        self.statusLbl.alpha = 1
                                    }
                                }
                            }
                        }
                    }
                }
                
                node.addAudioPlayer(SCNAudioPlayer(source: audioSource))
                node.addChildNode(virtualNode)
            }
        })
        
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
//        planeAnchor.updatePlaneNode(on: node)
//    }
//
    
//    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        print("\(self.classForCoder)/" + #function)
//    }
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    @IBAction func toggleDebugPointsFunc(_ sender: UISwitch) {
        if sender.isOn == true {
            print("Debug Points Enabled")
            
            tempText = statusLbl.text!
            updateStatusLbl("Debug Points Enabled")
            
            sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
            
            restoreLbl()
        }
        if sender.isOn == false {
            print("Debug Points Disabled")
            tempText = statusLbl.text!
            
            updateStatusLbl("Debug Points Disabled")
            sceneView.debugOptions = []
            
            restoreLbl()
        }
        
    }
    
    var audioPlayer3 = AVAudioPlayer()
    
    func updateStatusLbl(_ text:String) {
        
        
        UIView.animate(withDuration: 0.25) {
            self.statusLbl.alpha = 0
            self.delay(0.25) {
                self.statusLbl.text = text
                self.statusLbl.alpha = 1
            }
        }
        
    }
    
    func restoreLbl() {
        
        
        delay(3) {
            UIView.animate(withDuration: 0.5) {
                self.statusLbl.alpha = 0
                self.delay(0.5) {
                    if !self.infoDisplay {
                        self.statusLbl.text = "Tap Screen For More Info"
                    }
                    else {
                        self.statusLbl.text = "More Info"
                    }
                    self.statusLbl.alpha = 1
                }
            }
        }
        
    }
    
    @IBAction func toggleInteriorExteriorFunc(_ sender: Any) {
        //add audio when button pressed
        let openDoor = Bundle.main.path(forResource: "door-3-open", ofType: "wav")
        do{
            audioPlayer3 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: openDoor!))
        }
        catch{
            print(error)
        }
        audioPlayer3.play()
        
        print("Toggle Interior/Exterior Pressed!")

        if !interiorState {
            interiorState = !interiorState
            sceneView.session.pause()
            
            UIView.animate(withDuration: 0.5) {
                self.statusLbl.alpha = 0
                self.delay(0.5) {
                    self.statusLbl.text = "Interior Mode Selected"
                    self.statusLbl.alpha = 1
                    self.delay(2) {
                        self.statusLbl.text = ""
                    }
                }
            }
            
            UIView.animate(withDuration: 2) {
                self.toggleInteriorExterior.setTitle("Switch to Exterior", for: .normal)
            }
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
            sceneView.delegate = self
            sceneView.scene = SCNScene()
            let scene = SCNScene(named: "Objects/Models/" + current_AR_Object + ".scn")!
            sceneView.scene = scene
        }
        
        else if interiorState {
            interiorState = !interiorState
            
            UIView.animate(withDuration: 0.5) {
                self.statusLbl.alpha = 0
                self.delay(0.5) {
                    self.statusLbl.text = "Exterior Mode Selected"
                    self.statusLbl.alpha = 1
                    self.delay(2) {
                        self.statusLbl.text = ""
                    }
                }
            }
            
            UIView.animate(withDuration: 2) {
                self.toggleInteriorExterior.setTitle("Switch to Interior", for: .normal)
            }
            
                        

            viewDidLoad()
            super.viewWillAppear(true)
            sceneView.session.run()
            
            
            i = 1
            
            
            
            
            
        }
        
        
    }
    
    
    
}


extension ARSession {
    func run() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}


extension SCNView {
    
    private func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if scene?.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Images/environment_blur.exr") {
                scene?.lightingEnvironment.contents = environmentMap
            }
        }
        scene?.lightingEnvironment.intensity = intensity
    }

    func updateLightingEnvironment(for frame: ARFrame) {
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let intensity: CGFloat
        if let lightEstimate = frame.lightEstimate {
            intensity = lightEstimate.ambientIntensity / 400
        } else {
            intensity = 2
        }
        DispatchQueue.main.async(execute: {
            self.enableEnvironmentMapWithIntensity(intensity)
        })
    }
}

extension ARPlaneAnchor {
    
    @discardableResult
    func addPlaneNode(on node: SCNNode, geometry: SCNGeometry, contents: Any) -> SCNNode {
        guard let material = geometry.materials.first else { fatalError() }
        
        if let program = contents as? SCNProgram {
            material.program = program
        } else {
            material.diffuse.contents = contents
        }
        
        let planeNode = SCNNode(geometry: geometry)
        
        DispatchQueue.main.async(execute: {
            node.addChildNode(planeNode)
        })
        
        return planeNode
    }

//    func addPlaneNode(on node: SCNNode, contents: Any) {
//        let geometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
//        let planeNode = addPlaneNode(on: node, geometry: geometry, contents: contents)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
//    }
    
    func findPlaneNode(on node: SCNNode) -> SCNNode? {
        for childNode in node.childNodes {
            if childNode.geometry as? SCNPlane != nil {
                return childNode
            }
        }
        return nil
    }

//    func findShapedPlaneNode(on node: SCNNode) -> SCNNode? {
//        for childNode in node.childNodes {
//            if #available(iOS 11.3, *) {
//                if childNode.geometry as? ARSCNPlaneGeometry != nil {
//                    return childNode
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        return nil
//    }

    @available(iOS 11.3, *)
    func findPlaneGeometryNode(on node: SCNNode) -> SCNNode? {
        for childNode in node.childNodes {
            if childNode.geometry as? ARSCNPlaneGeometry != nil {
                return childNode
            }
        }
        return nil
    }

    @available(iOS 11.3, *)
    func updatePlaneGeometryNode(on node: SCNNode) {
        DispatchQueue.main.async(execute: {
            guard let planeGeometry = self.findPlaneGeometryNode(on: node)?.geometry as? ARSCNPlaneGeometry else { return }
            planeGeometry.update(from: self.geometry)
        })
    }

    func updatePlaneNode(on node: SCNNode) {
        DispatchQueue.main.async(execute: {
            guard let plane = self.findPlaneNode(on: node)?.geometry as? SCNPlane else { return }
            guard !PlaneSizeEqualToExtent(plane: plane, extent: self.extent) else { return }
            
            plane.width = CGFloat(self.extent.x)
            plane.height = CGFloat(self.extent.z)
        })
    }
}

fileprivate func PlaneSizeEqualToExtent(plane: SCNPlane, extent: vector_float3) -> Bool {
    if plane.width != CGFloat(extent.x) || plane.height != CGFloat(extent.z) {
        return false
    } else {
        return true
    }
}


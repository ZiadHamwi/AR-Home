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

class VirtualObjectNode: SCNNode {
    var AR_Object = ""
    
    enum VirtualObjectType {
        case houseObject
    }
    
    
    init(type: VirtualObjectType = .houseObject, _ arObject:String) {
        super.init()
        AR_Object = arObject;

        var scale = 0.1
        switch type {
        case .houseObject:
            loadScn(name: AR_Object, inDirectory: "Objects/Models")
        default:
            print("Error loading AR object...")
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
        guard let scene = SCNScene(named: "\(name).scn", inDirectory: directory) else { fatalError() }
        for child in scene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            addChildNode(child)
        }
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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLbl.text = "Move iPhone to begin..."
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        styleButton()
        
        
        if firstRun {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let frame = sceneView.session.currentFrame else {return}
//        sceneView.updateLightingEnvironment(for: frame)
//    }
   
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        print("\(self.classForCoder)/" + #function)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
//        statusLbl.text = "House Anchored"

        print("House Anchored!")
        
        var virtualNode = VirtualObjectNode(current_AR_Object)
        
//        node.addChildNode(virtualNode)
        DispatchQueue.main.async(execute: {
            if (self.i == 1) {
                self.i += 1
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
            print("Button Pressed")
            sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        }
        if sender.isOn == false {
            print("Button Depressed")
            sceneView.debugOptions = []
        }
        
    }
    
    
    
    @IBAction func toggleInteriorExteriorFunc(_ sender: Any) {
        print("Toggle Interior/Exterior Pressed!")

        if !interiorState {
            interiorState = !interiorState
            
            UIView.animate(withDuration: 2) {
                self.toggleInteriorExterior.setTitle("Switch to Exterior", for: .normal)
            }
            
            
            let scene = SCNScene(named: "Objects/Models/model.scn")!
            sceneView.scene = scene
        }
        
        else if interiorState {
            interiorState = !interiorState
            
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


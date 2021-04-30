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



//class ARViewController: UIViewController, ARSCNViewDelegate {
//    let switchModes = UIButton();
//    var isPressed = false
//    var scene = SCNScene();
//    @IBOutlet var sceneView: ARSCNView?
//    var current_AR_Object = ""
//
//    let configuration = ARWorldTrackingConfiguration()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Set the view's delegate
//        sceneView?.delegate = self
//
//        // Show statistics such as fps and timing information
////        sceneView?.showsStatistics = true
//
//
////        guard let url = Bundle.main.url(forResource: "art.scnassets/house", withExtension: "usdz")
////        else { fatalError() }
//
////        let mdlAsset = MDLAsset(url: url)
////        let scene = SCNScene(mdlAsset: mdlAsset)
//
////        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])
//
////
////        let material = SCNMaterial()
////        material.diffuse.contents = UIImage(named: "Cottage_Texture.png")
////
////        //Create the the node and apply texture
//////        objectNode?.geometry?.materials = [material]
//
//
//        configureButton(switchModes, "Switch")
//        switchModes.frame = CGRect(x: 255, y: 150, width: 120, height: 31)
//        switchModes.addTarget(self, action: #selector(self.switchModesButton), for: .touchUpInside)
//
//        view.addSubview(switchModes)
//
//        print(current_AR_Object)
//        // Create a new scene
//        scene = SCNScene(named: "Objects/Models/" + current_AR_Object + ".scn")!
////        let scene = SCNScene(named: "Objects/Shotgun.usdz")!
//
////        scene
//
//
//        // Set the scene to the view
//        sceneView?.scene = scene
//    }
//
//
////    init(AR_Object: String) {
////        self.current_AR_Object = AR_Object
////        super.init(nibName: nil, bundle: nil)
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        configuration.planeDetection = .horizontal
//        sceneView?.debugOptions = [ ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
//        sceneView?.automaticallyUpdatesLighting = true
//
//        // Run the view's session
//        sceneView?.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView?.session.pause()
//    }
//
//    // MARK: - ARSCNViewDelegate
//
//
////     Override to create and configure nodes for anchors added to the view's session.
////    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
////        let node = SCNNode()
////
////        return node
////    }
//
//
//    @objc func switchModesButton(sender : UIButton) {
////        scene.removeAllParticleSystems()
//
//        sceneView?.session.pause()
//        sceneView!.scene.rootNode.enumerateChildNodes { (node, stop) in
//               node.removeFromParentNode()
//           }
//
//
//
//
//
//        if (!isPressed) {
//
//            sender.backgroundColor = .red
//            scene = SCNScene()
//            viewWillAppear(true)
//            sceneView!.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
////            scene = SCNScene(named: "Objects/Cottage.scn")!
//            print("Pressed")
//        }
//
//        else {
//            sender.backgroundColor = .blue
//            scene = SCNScene()
////            scene.removeFromParentNode()
//            viewWillAppear(true)
//            sceneView!.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
////            scene = SCNScene(named: "Objects/model.scn")!
//            print("Unpressed")
//        }
//
//        isPressed = !isPressed
//
//    }
//
//
////    func clearScene() {
////        sceneView
////    }
//
//    func configureButton(_ button:UIButton, _ title:String) {
//        button.setTitle(title, for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
//        button.backgroundColor = .white
////        button.clipsToBounds = true
//        button.tintColor = .white
//        button.layer.cornerRadius = 10
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.clear.cgColor
//        button.setTitleColor(.black, for: .normal)
//        button.alpha = 1
//        button.showsTouchWhenHighlighted = true
//        button.backgroundColor = .blue
//    }
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
//}


class VirtualObjectNode: SCNNode {
    var AR_Object = ""
    
    enum VirtualObjectType {
        case duck
    }
    init(type: VirtualObjectType = .duck, _ arObject:String) {
        super.init()
        AR_Object = arObject;

        var scale = 1.0
        switch type {
        case .duck:
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = sceneView.session.currentFrame else {return}
        sceneView.updateLightingEnvironment(for: frame)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        let virtualNode = VirtualObjectNode(current_AR_Object)
        DispatchQueue.main.async(execute: {
            node.addChildNode(virtualNode)
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeAnchor.updatePlaneNode(on: node)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
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
            if let environmentMap = UIImage(named: "models.scnassets/sharedImages/environment_blur.exr") {
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

    func addPlaneNode(on node: SCNNode, contents: Any) {
        let geometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
        let planeNode = addPlaneNode(on: node, geometry: geometry, contents: contents)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
    }
    
    func findPlaneNode(on node: SCNNode) -> SCNNode? {
        for childNode in node.childNodes {
            if childNode.geometry as? SCNPlane != nil {
                return childNode
            }
        }
        return nil
    }

    func findShapedPlaneNode(on node: SCNNode) -> SCNNode? {
        for childNode in node.childNodes {
            if #available(iOS 11.3, *) {
                if childNode.geometry as? ARSCNPlaneGeometry != nil {
                    return childNode
                }
            } else {
                // Fallback on earlier versions
            }
        }
        return nil
    }

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

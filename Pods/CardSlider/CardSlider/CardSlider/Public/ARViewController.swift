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



class ARViewController: UIViewController, ARSCNViewDelegate {
    let switchModes = UIButton();
    var isPressed = false
    var scene = SCNScene();
    @IBOutlet var sceneView: ARSCNView?
    var current_AR_Object = ""
    
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView?.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView?.showsStatistics = true
        
        
//        guard let url = Bundle.main.url(forResource: "art.scnassets/house", withExtension: "usdz")
//        else { fatalError() }
        
//        let mdlAsset = MDLAsset(url: url)
//        let scene = SCNScene(mdlAsset: mdlAsset)
        
//        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])

//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "Cottage_Texture.png")
//
//        //Create the the node and apply texture
////        objectNode?.geometry?.materials = [material]
        
        
        configureButton(switchModes, "Switch")
        switchModes.frame = CGRect(x: 255, y: 150, width: 120, height: 31)
        switchModes.addTarget(self, action: #selector(self.switchModesButton), for: .touchUpInside)

        view.addSubview(switchModes)
        
        print(current_AR_Object)
        // Create a new scene
        scene = SCNScene(named: "Objects/Models/" + current_AR_Object + ".scn")!
//        let scene = SCNScene(named: "Objects/Shotgun.usdz")!

//        scene
        
        
        // Set the scene to the view
        sceneView?.scene = scene
    }
    
    
//    init(AR_Object: String) {
//        self.current_AR_Object = AR_Object
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration.planeDetection = .horizontal
        sceneView?.debugOptions = [ ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView?.automaticallyUpdatesLighting = true

        // Run the view's session
        sceneView?.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView?.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

//     Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }

    
    @objc func switchModesButton(sender : UIButton) {
//        scene.removeAllParticleSystems()
        
        sceneView?.session.pause()
        sceneView!.scene.rootNode.enumerateChildNodes { (node, stop) in
               node.removeFromParentNode()
           }
           
        
        
        
        
        if (!isPressed) {
            
            sender.backgroundColor = .red
            scene = SCNScene()
            viewWillAppear(true)
            sceneView!.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//            scene = SCNScene(named: "Objects/Cottage.scn")!
            print("Pressed")
        }
        
        else {
            sender.backgroundColor = .blue
            scene = SCNScene()
//            scene.removeFromParentNode()
            viewWillAppear(true)
            sceneView!.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//            scene = SCNScene(named: "Objects/model.scn")!
            print("Unpressed")
        }
        
        isPressed = !isPressed
        
    }
    
    
//    func clearScene() {
//        sceneView
//    }
    
    func configureButton(_ button:UIButton, _ title:String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
//        button.clipsToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.black, for: .normal)
        button.alpha = 1
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = .blue
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

//
//  ViewController.swift
//  CubeAR
//
//  Created by Artyom Beldeiko on 13.06.22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        let scene = SCNScene()
    
        sceneView.scene = scene
    }
    
    private func createAlternatingBox(in scene: SCNScene) {
        
        let alternatingBox = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let alternatingBoxMaterial = SCNMaterial()
        
        alternatingBoxMaterial.diffuse.contents = UIColor.red
        alternatingBoxMaterial.specular.contents = UIColor.blue
        
        let alternatingBoxNode = SCNNode(geometry: alternatingBox)
        alternatingBox.name = "box"
        alternatingBoxNode.geometry?.materials = [alternatingBoxMaterial]
        alternatingBoxNode.position = SCNVector3(0.0, 0.0, -0.5)
        scene.rootNode.addChildNode(alternatingBoxNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetTapped(sender: UIButton) {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if node.name == "box" {
                node.removeFromParentNode()
            }
        }
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    @IBAction func addTapped(sender: UIButton) {
        createAlternatingBox(in: sceneView.scene)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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

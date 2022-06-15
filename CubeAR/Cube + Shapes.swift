//
//  CubeViewController.swift
//  CubeAR
//
//  Created by Artyom Beldeiko on 13.06.22.
//

import UIKit
import SceneKit
import ARKit

class CubeViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
// MARK: - Cube
        
        let boxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.brown
        
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.geometry?.materials = [material]
        boxNode.position = SCNVector3(0, 0, -1.0)
        
        scene.rootNode.addChildNode(boxNode)
        
// MARK: - Text
        
        let textGeometry = SCNText(string: "This is your cube", extrusionDepth: 2.0)
        
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        textNode.geometry?.materials = [textMaterial]
        
        textNode.position = SCNVector3(0, 0.2, -1.0)
        scene.rootNode.addChildNode(textNode)
        
// MARK: - Globe
        
        let sphereGeometry = SCNSphere(radius: 0.3)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "earth.jpg")
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.materials = [sphereMaterial]
        
        sphereNode.position = SCNVector3(1, 1, -1.0)
        
        scene.rootNode.addChildNode(sphereNode)
        
        createFigures(in: scene)
        createAlternatingBox(in: scene)
        
// MARK: - GestureRecognizer
        
        let tapGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(alternatingBoxTapped(touch:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    private func createFigures(in scene: SCNScene) {
        
        let array: [SCNGeometry] = [SCNPlane(), SCNSphere(), SCNBox(), SCNPyramid(), SCNTube(), SCNCone(), SCNTorus(), SCNCylinder(), SCNCapsule()]
        
        var xCoordinate: Double = 1
        
        sceneView.autoenablesDefaultLighting = true
        
        for geometryShape in array {
            let node = SCNNode(geometry: geometryShape)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            node.geometry?.materials = [material]
            node.scale = SCNVector3(0.1, 0.1, 0.1)
            node.position = SCNVector3(xCoordinate, 0.5, -1.5)
            
            xCoordinate -= 0.2
            
            scene.rootNode.addChildNode(node)
        }
        
    }
    
    private func createAlternatingBox(in scene: SCNScene) {
        
        let alternatingBox = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let alternatingBoxMaterial = SCNMaterial()
        
        alternatingBoxMaterial.diffuse.contents = UIColor.red
        alternatingBoxMaterial.specular.contents = UIColor.blue
        
        let alternatingBoxNode = SCNNode(geometry: alternatingBox)
        alternatingBoxNode.geometry?.materials = [alternatingBoxMaterial]
        alternatingBoxNode.position = SCNVector3(0.4, 0.2, -2.0)
        scene.rootNode.addChildNode(alternatingBoxNode)
    }
    
    @objc func alternatingBoxTapped(touch: UITapGestureRecognizer) {
        
        let sceneView = touch.view as! SCNView
        let touchLocation = touch.location(in: sceneView)
        
        let touchResults = sceneView.hitTest(touchLocation, options: [:])
        
        guard !touchResults.isEmpty, let node = touchResults.first?.node else { return }
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.blue
        boxMaterial.specular.contents = UIColor.red
        node.geometry?.materials[0] = boxMaterial
        print("Tapped")
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

//
//  GameViewController.swift
//  SceneKit-Basics
//
//  Created by Joao Gabriel Dourado Cervo on 03/09/21.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    //MARK: - Nodes
    
    var scnView: SCNView!
    var cameraNode: SCNNode!
    
    //MARK: - Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        
        setupPlayer()
        setupEnemy()
        
        setupGesture()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Setups
    
    func setupView() {
        scnView = self.view as? SCNView
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.showsStatistics = true
    }
    
    func setupScene() {
        let scene = SCNScene()
        scene.background.contents = MDLSkyCubeTexture(name: "sky", channelEncoding: .float16, textureDimensions: vector_int2(128, 128), turbidity: 0, sunElevation: 1.5, upperAtmosphereScattering: 0.5, groundAlbedo: 0.5)
        scene.lightingEnvironment.contents = scene.background.contents
        
        let ground = SCNBox(width: 50, height: 1, length: 50, chamferRadius: 0)
        ground.firstMaterial?.diffuse.contents = UIColor.black
        
        let groundNode = SCNNode(geometry: ground)
        groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: groundNode, options: [:]))
        groundNode.name = "ground"
        
        scene.rootNode.addChildNode(groundNode)
        
        scnView.scene = scene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 5)

        scnView.scene?.rootNode.addChildNode(cameraNode)
    }
    
    //MARK: - Player and Enemy configuration
    
    func setupPlayer() {
        let player = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        player.firstMaterial?.diffuse.contents = UIColor.white
        
        let playerNode = SCNNode(geometry: player)
        playerNode.position = SCNVector3(x: 0, y: 1, z: 0)
        playerNode.name = "player"
        
        scnView.scene?.rootNode.addChildNode(playerNode)
    }
    
    func setupEnemy() {
        let enemy = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        enemy.firstMaterial?.diffuse.contents = UIColor.red
        
        let enemyNode = SCNNode(geometry: enemy)
        enemyNode.position = SCNVector3(x: 0, y: 1, z: 15)
        enemyNode.name = "enemy"
        
        scnView.scene?.rootNode.addChildNode(enemyNode)
    }
    
    //MARK: - Gesture configuration
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        scnView.addGestureRecognizer(gesture)
    }
    
    @objc func onTap(_ gestureRecognize: UIGestureRecognizer) {
        let location = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(location, options: [:])
        
        if hitResults.count > 0 {
            let result: SCNHitTestResult = hitResults[0]
            
            guard let name = result.node.name else { return }
            
            if name == "enemy" {
                result.node.removeFromParentNode()
            } else if name == "player" {
                let playerColor = result.node.geometry?.firstMaterial!.diffuse.contents as! NSObject
                
                result.node.geometry?.firstMaterial!.diffuse.contents = playerColor == UIColor.green ? UIColor.yellow : UIColor.green
            }
        }
    }
}

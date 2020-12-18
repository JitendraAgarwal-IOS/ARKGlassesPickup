//
//  ViewController.swift
//  GlassSelectionDemo
//
//  Created by Capgemini on 17/12/20.
//

import UIKit
import ARKit

enum AdjectButton:Int {
    case top = 101
    case right = 102
    case botton = 103
    case left = 104
}
class SeenView: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var bgViewGlaessAdgHieght: NSLayoutConstraint!
    @IBOutlet weak var bgViewGlassesHightCont: NSLayoutConstraint!
    private let minPositionDistance: Float = 0.0025
    @IBOutlet weak var leftView: UIView!
    var isMenuTap: Bool =  false
    let planeWidth: CGFloat = 0.13
    let planeHeight: CGFloat = 0.06
    private let nodeYPosition: Float = 0.022
    var glassesPlane: SCNPlane!
    let glassesNode = SCNNode()
    var selectedIndexPath : IndexPath?
    @IBOutlet weak var bgContiner: UIView!
    private let spacing: CGFloat = 10.0
    @IBOutlet weak var aCollectionView: UICollectionView!
    var arrImage =  [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuToggle()
        self.setGlassesPlan()
        self.arrImage = ["glasses0", "glasses1","glasses2","glasses3","glasses4","glasses5","glasses6","glasses7","glasses8"]
        self.aCollectionView.register(UINib(nibName: "GlassSelectionCell", bundle: nil), forCellWithReuseIdentifier: "GlassSelectionCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            self.aCollectionView?.collectionViewLayout = layout
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return
        }
        sceneView.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         let configuration = ARFaceTrackingConfiguration()
         sceneView.session.run(configuration)
     }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    private func menuToggle() {
        if isMenuTap {
            self.leftView.isHidden =  false
            self.bgViewGlaessAdgHieght.constant = 151.0
            self.bgViewGlassesHightCont.constant = 0.0
            
        }else{
            self.leftView.isHidden =  true
            self.bgViewGlaessAdgHieght.constant = 0.0
            self.bgViewGlassesHightCont.constant = 100.0
        }
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        isMenuTap = !isMenuTap
        self.menuToggle()
    }
    func setGlassesPlan(){
        glassesPlane = SCNPlane(width: planeWidth, height: planeHeight)
        glassesPlane.firstMaterial?.isDoubleSided = true
        glassesPlane.firstMaterial?.diffuse.contents =  UIImage(named: "glasses0")
        glassesNode.geometry = glassesPlane
    }
    
    @IBAction func actionGlassAdjCollection(_ sender: UIButton) {
        let topButton = AdjectButton.init(rawValue: sender.tag)
        switch topButton{
        case .top:
            self.glassesNode.position.y += minPositionDistance
          
        case .right:
            self.glassesNode.position.x += minPositionDistance
        case .botton:
            self.glassesNode.position.y -= minPositionDistance
        case .left:
            self.glassesNode.position.x -= minPositionDistance
        default:
            print("No Action")
        }
    
    }
}



extension SeenView: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.transparency = 0
        glassesNode.position.z = faceNode.boundingBox.max.z * 3 / 4
        glassesNode.position.y = nodeYPosition
        faceNode.addChildNode(glassesNode)
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
}


extension SeenView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlassSelectionCell", for: indexPath) as! GlassSelectionCell
            cell.imageView.image = UIImage(named: self.arrImage[indexPath.row])
        
        guard let seleIndex = selectedIndexPath else {
            return cell
        }
        if seleIndex.row == indexPath.row {
            cell.bgView.backgroundColor = .red
          } else {
            cell.bgView.backgroundColor = .white
          }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! GlassSelectionCell
//        cell.toggleBgView()
        
        var cellsToReload = [indexPath]
           if let selected = selectedIndexPath {
               cellsToReload.append(selected)
           }
           selectedIndexPath = indexPath
        collectionView.reloadItems(at: cellsToReload)
        
        glassesPlane.firstMaterial?.diffuse.contents =  UIImage(named: arrImage[indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print("deledd index\(indexPath.row)")
//
//        let cell = collectionView.cellForItem(at: indexPath) as? GlassSelectionCell
//        cell.toggleBgView()
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 80, height: 80)
    }
    
}


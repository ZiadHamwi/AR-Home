//
//  ViewController.swift
//  Prototype01
//
//  Created by Ziad Hamwi on 1/18/21.
//

import UIKit
import SceneKit
import ARKit
import CardSlider
import AVFoundation



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
struct Item:CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
}


struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}


class House {
    var house_title: String = ""
    var house_description: String = ""
    var house_image_link: String = ""
    var house_price: String = ""
    
    init() {
        self.house_title = ""
        self.house_description = ""
        self.house_image_link = ""
        self.house_price = ""
    }
    
    init(_ house_title: String, _ house_description: String, _ house_image_link: String, _ house_price: String) {
        self.house_title = house_title
        self.house_description = house_description
        self.house_image_link = house_image_link
        self.house_price = house_price
    }
    
    
}
class ViewController: UIViewController, ARSCNViewDelegate, CardSliderDataSource, UISearchBarDelegate {
    
    fileprivate let data = [
        CustomData(title: "", url: "", backgroundImage: #imageLiteral(resourceName: "House")),
        CustomData(title: "", url: "", backgroundImage: #imageLiteral(resourceName: "Residential Building")),
        CustomData(title: "", url: "", backgroundImage: #imageLiteral(resourceName: "Two Story House")),
        CustomData(title: "", url: "", backgroundImage: #imageLiteral(resourceName: "Cottage"))
    ]
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
   
    
    
    
    
    let configuration = ARWorldTrackingConfiguration()
    var indicator = UIPageControl()
    
    
    var link1 = ""
    var link2 = ""
    var link3 = ""
    var link4 = ""
    var link5 = ""
    var link6 = ""
    
    
    var data2 = [Item]()
    
    
    func item(for index: Int) -> CardSliderItem {
        return data2[index]
    }
    
    func numberOfItems() -> Int {
        return data2.count
    }
    

    @IBOutlet var sceneView: ARSCNView!
    var timer = Timer()
    let exploreHouses = UIButton()
    let postHouses = UIButton()
//    let searchBar = UISearchBar()
    lazy var searchBar:UISearchBar = UISearchBar()

    
    var houseImages: [UIImage] = []
    var houseImagesIndex = 0
    var houses: [House] = []
    var houseListingLinks: [String] = []
    
    func appendImagesToArray() {
        houseImages.append(UIImage(named: "Cottage")!)
        houseImages.append(UIImage(named: "Residential Building")!)
        houseImages.append(UIImage(named: "Two Story House")!)
        houseImages.append(UIImage(named: "House")!)

        
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        
    }
    
    func loadCardSliderData() {
        
//        for x in 3...5 {
//            if let h1 = try? Data(contentsOf: URL(string: "https:" + houses[0].house_image_link)!) {
//                data.append(Item(image: UIImage(data: h1)!, rating: nil, title: houses[0].house_title, subtitle: "House subtitle", description: houses[0].house_description))
//
//                }
        
//        if let h2 = try? Data(contentsOf: URL(string: "https:" + houses[1].house_image_link)!) {
//            data.append(Item(image: UIImage(data: h2)!, rating: nil, title: houses[1].house_title, subtitle: "House subtitle", description: houses[1].house_description))
////
//            }
//        }
        data2.append(Item(image: UIImage(named: "House")!, rating: nil, title: "model", subtitle: "House", description: "This compact plan features a fully equipped kitchen with a walk-in pantry and eating bar that comfortably seats up to four. The spacious floor plan accommodates full sized furniture and appliances. 9' ceilings and pocket doors throughout the home create a spacious and open feeling. The pocket doors leading into the master suite and guest room can either be closed for privacy or can provide a large 5' wide opening. The modern walk-in shower in the master suite provides both easy access and eliminates the maintenance required by glass doors. Measuring over 6' from end to end, the shower accommodates dual shower heads. The master suite also includes a dual vanity and a large walk-in closet. This design also features a covered front porch, double garage, mudroom/laundry room and a full bath for guests."))

        data2.append(Item(image: UIImage(named: "Cottage")!, rating: nil, title: "Cottage", subtitle: "Cottage House", description: "This compact plan features a fully equipped kitchen with a walk-in pantry and eating bar that comfortably seats up to four. The spacious floor plan accommodates full sized furniture and appliances. 9' ceilings and pocket doors throughout the home create a spacious and open feeling. The pocket doors leading into the master suite and guest room can either be closed for privacy or can provide a large 5' wide opening. The modern walk-in shower in the master suite provides both easy access and eliminates the maintenance required by glass doors. Measuring over 6' from end to end, the shower accommodates dual shower heads. The master suite also includes a dual vanity and a large walk-in closet. This design also features a covered front porch, double garage, mudroom/laundry room and a full bath for guests."))
        data2.append(Item(image: UIImage(named: "Residential Building")!, rating: nil, title: "Residential Building", subtitle: "Residential Building", description: "A residential building is defined as the building which provides more than half of its floor area for dwelling purposes. In other words, residential building provides sleeping accommodation with or without cooking or dining or both facilities."))
        data2.append(Item(image: UIImage(named: "Two Story House")!, rating: nil, title: "Two Story House", subtitle: "Two Story House", description: "2 story house plans (sometimes written \"two story house plans\") are probably the most popular story configuration for a primary residence. A traditional 2 story house plan presents the main living spaces (living room, kitchen, etc) on the main level, while all bedrooms reside upstairs."))
    }
    
    func displayHomeScreenElements() {
        UIView.animate(withDuration: 0.2) {
            self.searchBar.alpha = 1
        }
        delay(0.3) {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
            
                self.delay(0.3) {
                    UIView.animate(withDuration: 0.3) {
                        self.exploreHouses.alpha = 1
                    }
                    self.delay(0.3) {
                        UIView.animate(withDuration: 0.1) {
                            self.postHouses.alpha = 1
                        }
                    
                    
                }
            }
        }
    }
    
    func getNumberofHouseImages() -> Int {
        return houseImages.count
    }

    

    
    

    
    
    
    


    // Explore Houses Button
    @objc func exploreHousesButton(sender : UIButton) {
        AudioServicesPlaySystemSound(1519)

        var vc = CardSliderViewController()
//        var vc = UIViewController()
        
        
        vc = CardSliderViewController.with(dataSource: self)
        vc.navigationItem.title = "Explore Houses"
//        vc.view.backgroundColor = .red

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func exploreHousesTouchDown_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.exploreHouses.alpha = 0.4
        }
    }
    
    
    @objc func exploreHousesTouchUpInside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.exploreHouses.alpha = 1
        }
        
    }
    @objc func exploreHousesTouchUpOutside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.exploreHouses.alpha = 1
        }
        
    }
    
    @objc func exploreHousesTouchDragOutside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.exploreHouses.alpha = 1
        }
    }
    //END of Explore Houses
    
    // Post Houses Button
    @objc func postHousesButton(sender : UIButton) {
        AudioServicesPlaySystemSound(1519)
        let postHousesVC = storyboard?.instantiateViewController(identifier: "PostHouses_VC") as! postController
//        present(ARViewController(), animated: true, completion: nil)
        
        navigationController?.pushViewController(postHousesVC, animated: true)
        
        
//        // Run the view's session
//        self.sceneView.session.run(self.configuration)
//        UIView.animate(withDuration: 0.5) {
//            self.view.backgroundColor = .black
//        }
        
        
        
        
        
        
    }
    
    @objc func postHousesTouchDown_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.postHouses.alpha = 0.4
        }
    }
    
    
    @objc func postHousesTouchUpInside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.postHouses.alpha = 1
        }
        
    }
    @objc func postHousesTouchUpOutside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.postHouses.alpha = 1
        }
        
    }
    
    @objc func postHousesTouchDragOutside_button(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.postHouses.alpha = 1
        }
    }
    //END of Post Houses
    
    
    
    @objc func indicatorChanged(sender : UIPageControl) {
        let current = sender.currentPage
        var indexPath: IndexPath!
        indexPath = IndexPath(item: current, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            
//        print(current)
        
    }

        
        
    func delay(_ delay:Double, closure:@escaping ()->()) {
                    DispatchQueue.main.asyncAfter(
                        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
                }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        // Create a session configuration

        // Run the view's session
//            sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
//        sceneView.session.pause()
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
    var color = UIColor(red: 54/255, green: 240/255, blue: 255/255, alpha: 1)

    func configureButton(_ button:UIButton, _ title:String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 34)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0
        button.backgroundColor = color
    }
    
    func createHomeScreenElements() {
        appendImagesToArray()
        configureButton(exploreHouses, "Explore Houses")
        exploreHouses.translatesAutoresizingMaskIntoConstraints = false
        exploreHouses.addTarget(self, action: #selector(self.exploreHousesButton), for: .touchUpInside)
        exploreHouses.addTarget(self, action: #selector(self.exploreHousesTouchDown_button), for: .touchDown)
        exploreHouses.addTarget(self, action: #selector(self.exploreHousesTouchUpInside_button), for: .touchUpInside)
        exploreHouses.addTarget(self, action: #selector(self.exploreHousesTouchUpOutside_button), for: .touchUpOutside)
        exploreHouses.addTarget(self, action: #selector(self.exploreHousesTouchDragOutside_button), for: .touchDragOutside)

        view.addSubview(exploreHouses)
        
        configureButton(postHouses, "Post Houses")
        postHouses.translatesAutoresizingMaskIntoConstraints = false
        postHouses.addTarget(self, action: #selector(self.postHousesButton), for: .touchUpInside)
        postHouses.addTarget(self, action: #selector(self.postHousesTouchDown_button), for: .touchDown)
        postHouses.addTarget(self, action: #selector(self.postHousesTouchUpInside_button), for: .touchUpInside)
        postHouses.addTarget(self, action: #selector(self.postHousesTouchUpOutside_button), for: .touchUpOutside)
        postHouses.addTarget(self, action: #selector(self.postHousesTouchDragOutside_button), for: .touchDragOutside)
        view.addSubview(postHouses)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.alpha = 0
        searchBar.placeholder = "Search Houses"
//        searchBar.layer.borderWidth = 10
        searchBar.showsCancelButton = true
        
        
        
        indicator.addTarget(self, action: #selector(self.indicatorChanged), for: .valueChanged)
        view.addSubview(indicator)
//        indicator.frame = CGRect(x: 0, y: 595, width: view.frame.width, height: 50)
        indicator.alpha = 1
        indicator.layer.cornerRadius = 12
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.numberOfPages = data.count
        indicator.currentPage = 0
        
        
        
        
//        searchBar.searchBarStyle = UISearchBar.Style.prominent
//            searchBar.placeholder = "Search Houses"
//            searchBar.sizeToFit()
//        searchBar.isTranslucent = false
//            searchBar.backgroundImage = UIImage()
//            searchBar.delegate = self
//            navigationItem.titleView = searchBar

        
        
        
        view.addSubview(searchBar)
        
        
        
        
        
    }
    
    private let myView: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        return myView
    }()
    
    
//    func searchBar(searchBar: UISearchBar, textDidChange textSearched: String)
//    {
//    }
//
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.endEditing(true)
////        self.searchBar.dism
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.endEditing(true)
//
//    }
    
    
    
    
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //myView
        constraints.append((myView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)))
        constraints.append((myView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)))
        constraints.append((myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)))
        constraints.append((myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)))

        
        //searchBar
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(searchBar.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.08))

        constraints.append(searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -12))
        

        
        
        //CollectionView
        constraints.append(collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        constraints.append(collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12))
        constraints.append(collectionView.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.6))
        constraints.append(collectionView.bottomAnchor.constraint(equalTo: indicator.topAnchor, constant: -10))


//        indicator
        constraints.append(indicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(indicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        constraints.append(indicator.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10))
        constraints.append(indicator.bottomAnchor.constraint(equalTo: exploreHouses.topAnchor, constant: -10))

        
        
        
        
        //postHouses
//        constraints.append(postHouses.topAnchor.constraint(equalTo: exploreHouses.bottomAnchor, constant: 20))
        constraints.append(postHouses.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -1))
        constraints.append(postHouses.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.1))
        constraints.append(postHouses.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(postHouses.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))

        
        //exploreHouses
        constraints.append(exploreHouses.bottomAnchor.constraint(equalTo: postHouses.topAnchor, constant: -20))
        constraints.append(exploreHouses.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(exploreHouses.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        constraints.append(exploreHouses.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.1))

        
        //Activate the constraints
        NSLayoutConstraint.activate(constraints)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        webScrapeSomeDataAndGetHouseListingsLinks()
//        houses.append(getHouseData(houseListingLinks[0]))
        if self.traitCollection.userInterfaceStyle == .dark {
                    // User Interface is Dark
            myView.backgroundColor = .black
            color = .yellow
                } else {
                    // User Interface is Light
                    indicator.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)

                    myView.backgroundColor = .white
                }
        title = "Home"
        view.addSubview(myView)
        
        
        
        view.addSubview(collectionView)
        
        
       
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self

        self.collectionView.backgroundColor = view.backgroundColor
        collectionView.isPagingEnabled = true
        collectionView.contentMode = .scaleAspectFill
        
        
        
        
        
        loadCardSliderData()
        createHomeScreenElements()
        displayHomeScreenElements()
        addConstraints()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        print(houses[0].house_title)
//        print(houses[1].house_title)
//        print(houses[2].house_title)
//        print(houses[3].house_title)
//        print(houses[4].house_title)
//        print(houses[5].house_title)
        
        
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            indicator.currentPage = indexPath![1]
        }
    }
    
}




extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.data[indexPath.item]
        return cell
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            bg.image = data.backgroundImage
            
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 30
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        


        
        contentView.addSubview(bg)

        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


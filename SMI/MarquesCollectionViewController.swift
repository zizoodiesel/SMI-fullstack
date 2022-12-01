//
//  MarquesCollectionViewController.swift
//  SMI
//
//  Created by Zizoo diesel on 30/11/2022.
//

import UIKit
//import AVFoundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "Cell"


class MarquesCollectionViewController: UICollectionViewController {
    

    var items = [Brand]()
    var premiumItems = [Brand]()
    var lastFetchedId : String = ""
    var isWaiting = false
    var isPremium = true
    
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    private func doPaging() {


        let reff = Database.database().reference().child("brands")
        
        //Second fetch
        reff.queryOrderedByKey().queryStarting(afterValue:lastFetchedId).queryLimited(toFirst: 100).observeSingleEvent(of: .value, with: { [self] snapshot in

            if snapshot.value is NSNull {
                
                return
            }
            else {
                for item in snapshot.value as! [String:AnyObject] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: item.value)
                        let decoder = JSONDecoder()
                        let decodedArtice = try decoder.decode(Brand.self, from: json)
                        items.append(decodedArtice)
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
                if (snapshot.value as! [String:AnyObject]).count > 0 {
                    lastFetchedId = items.last!.key;
                    collectionView.reloadData()
                    self.isWaiting = false
                }
            }
            
        })
        
        

    }

    func loadBrands() {
 
                                             
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
        


        
        let ref = Database.database().reference().child("brands")


        //First fetch
//        .queryOrderedByChild("premium").queryEqualToValue(true)
        
        var query: DatabaseQuery
        
        if isPremium {
            query = ref.queryOrdered(byChild: "premium").queryEqual(toValue: true).queryLimited(toFirst: 100)
        }
        else {
            query = ref.queryOrderedByKey().queryLimited(toFirst: 100)
        }
        
        query.observe(.value, with: { [self] snapshot in
                                                                
            // Do stuff here with the returned elements
            //...

            items = [Brand]()
            
            if snapshot.value is NSNull {
                
                return
            }
            else {
                for item in snapshot.value as! [String:AnyObject] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: item.value)
                        let decoder = JSONDecoder()
                        let decodedArtice = try decoder.decode(Brand.self, from: json)
                        items.append(decodedArtice)
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
                lastFetchedId = items.last!.key;
                collectionView.reloadData()
            }
            
            
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")


        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        segmentedControl!.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)


        // Do any additional setup after loading the view.
        
        FirebaseApp.configure()

        
        
        if let user = UserDefaults.standard.string(forKey: "user") {
            Auth.auth().signIn(withEmail: user, password: UserDefaults.standard.string(forKey: "password")!) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                guard error == nil else {
                    
                    print("errooooor : \(error!.localizedDescription)")
                    strongSelf.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                    return;
                    
                }
                
                strongSelf.loadBrands()
            }
        }
        else {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        items = [Brand]()
        collectionView.reloadData()
        
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        isPremium = (sender.selectedSegmentIndex == 0) ? true : false
        loadBrands()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailsIdentifier" {
            let cell = sender as! UICollectionViewCell
            
            if let indexPath = collectionView.indexPath(for: cell) {
                
                (segue.destination as! MarquesDetailsTableVIewController).brandItem = items[indexPath.row]
                
            }
        }
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticleCollectioniewCell
        
        let cell : ArticleCollectioniewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticleCollectioniewCell
    
        // Configure the cell

        
        if items[indexPath.row].pic != nil {

            cell.cellImageView?.isHidden = false
            cell.cellImage = nil

            let imageUrl = NSURL(string: items[indexPath.row].pic!)
        
            if imageUrl != nil {
                
                // This method is fetching and caching images if needed otherwise it returns an image from cache
                ImageCache.publicCache.load(url: imageUrl!, indexPath: indexPath) { (fetchedIndex, image) in
                    
                    if let cachedCell = collectionView.cellForItem(at: fetchedIndex!) as? ArticleCollectioniewCell {
                        if let img = image {
                            
                            
                            
                            
                            cachedCell.cellImage = img
                            
                            
                            
                        }
                        
                        else {
                            
                            cachedCell.cellImage = UIImage.init(named: "image-not-found.png")

                        }
                        
                        cachedCell.cellImageView!.contentMode = .scaleAspectFill
                    }
                    
                    print("\n")
                }
                
            }
            else {
                
                cell.cellImage = UIImage.init(named: "image-not-found.png")
                cell.cellImageView!.contentMode = .scaleAspectFill
            }
        }
        else {
            cell.cellImage = UIImage.init(named: "image-not-found.png")
            cell.cellImageView!.contentMode = .scaleAspectFill
            
//            cell.cellImageView?.isHidden = true

//            cachedCellSizes[indexPath] = cell.frame.size.height
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

       if indexPath.item == items.count - 2 && !isWaiting {
           
           print("pagingggggg")
           isWaiting = true
           self.doPaging()
        }
     }
    
    


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

//

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)

        headerView.backgroundColor = UIColor.systemBackground
        
        headerView.addSubview(segmentedControl!)
        segmentedControl?.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl?.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        segmentedControl?.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        

        return headerView
    }
    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

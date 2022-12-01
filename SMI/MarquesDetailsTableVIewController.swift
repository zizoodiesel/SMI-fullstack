//
//  MarquesDetailsTableVIewController.swift
//  SMI
//
//  Created by Zizoo diesel on 1/12/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class MarquesDetailsTableVIewController: UITableViewController {

    var brandItem: Brand!
    
    @IBOutlet private weak var titleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var commissionLabel: UILabel!
    @IBOutlet private weak var salesLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let footerView = self.tableView.tableHeaderView else {
            return
        }
        let width = self.tableView.bounds.size.width
        let size = footerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            self.tableView.tableHeaderView = footerView
        }
    }
    
    func loadPurchases() {

        let ref = Database.database().reference().child("conversions/purchase")


        //First fetch
//        .queryOrderedByChild("premium").queryEqualToValue(true)
        
        var query: DatabaseQuery = ref.queryOrdered(byChild: "brandKey").queryEqual(toValue: brandItem.key)

        query.observe(.value, with: { [self] snapshot in
                                                                
            // Do stuff here with the returned elements
            //...

            var items = [Brand]()
            
            if snapshot.value is NSNull {
                print("is NSNull")
                
                amountLabel.text = "NaN"
                commissionLabel.text = "NaN"
                salesLabel.text = "NaN"
                
                return
            }
            else {
                
                var amount: Double = 0
                var commission: Double = 0
                var sales: Int = 0
                
                for item in snapshot.value as! [String:AnyObject] {
                    
//                    print("item : \(item)")
                    
                    let price = (item.value as! [String:AnyObject])["amount"] as! Double
                    amount += price
                    
                    let comm = (item.value as! [String:AnyObject])["commission"] as! String
                    commission += Double(comm) ?? 0
                    
                    sales += 1
                }
                
//                print("Final amount: \(amount)")
//                print("Final commission: \(commission)")
//                print("sales number: \(sales)")
                
                
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "FR")
                formatter.numberStyle = .currency
                formatter.currencyCode = "EUR"
                
                if let formattedAmount = formatter.string(from: amount as NSNumber) {
                    amountLabel.text = formattedAmount
                }

                if let formattedCommission = formatter.string(from: commission as NSNumber) {
                    commissionLabel.text = formattedCommission
                }

                salesLabel.text = String(sales)
                

            }
//            print("items : \(items)")
            
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .leastNormalMagnitude
        }
        
        
        titleLabel.text = brandItem.name
        descriptionLabel.text = brandItem.description
        
        loadPurchases()
        
        let imageUrl = NSURL(string: brandItem.pic!)
        if imageUrl != nil {
            
            ImageCache.publicCache.load(url: imageUrl!, indexPath: nil) {[self] (fetchedIndex, image) in
                
                
                if let img = image {
                    
                    titleImageView.image = img
                    
                    
                    
                }
                
                else {
                    
                    titleImageView.image = UIImage.init(named: "image-not-found.png")
                    
                }
                
                titleImageView!.contentMode = .scaleAspectFill
            }
            
        }
        else {
            
            titleImageView.image = UIImage.init(named: "image-not-found.png")
            titleImageView!.contentMode = .scaleAspectFill
        }

        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 0.0
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

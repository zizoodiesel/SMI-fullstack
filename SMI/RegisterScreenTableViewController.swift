//
//  RegisterScreenTableViewController.swift
//  SMI
//
//  Created by Zizoo diesel on 1/12/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class RegisterScreenTableViewController: UITableViewController {

    @IBOutlet var userTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    func register() {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] authResult, error in

            guard error == nil else {
                
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                }))

                self.present(alert, animated: true, completion: nil)
                
                print("errooooor : \(error!.localizedDescription)")
                return;
                
            }
            
            UserDefaults.standard.set(emailTextField.text, forKey: "user") //Bool
            UserDefaults.standard.set(passwordTextField.text, forKey: "password")  //Integer
            
            UserDefaults.standard.synchronize()

            
            let alert = UIAlertController(title: "Congratulation", message: "You are now a registered user!\nPlease enjoy ou app", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true)
                ((self.presentingViewController as! UINavigationController).viewControllers[0] as! MarquesCollectionViewController).loadBrands()
            }))

            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    //MARK: - TextField delegates
        

        @IBAction private func textFieldDidChange(_ sender: Any) {
            
            let textField = sender as! UITextField

            if (emailTextField.text!.count > 0 && passwordTextField.text!.count > 0) {

                tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.isUserInteractionEnabled = true
                ((tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.viewWithTag(101))! as! UILabel).isEnabled = true
                
            }
            else {
       
                tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.isUserInteractionEnabled = false
                ((tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.viewWithTag(101))! as! UILabel).isEnabled = false
            }
            
        }
        
        private func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
            return false
        }

        func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
          textField.resignFirstResponder()

            return true
        }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            register()
        }
        
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

//
//  LoginScreenViewController.swift
//  SMI
//
//  Created by Zizoo diesel on 29/11/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class LoginScreenViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet var signInTextView: UITextView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    func authenticate() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] authResult, error in
            
            
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
            
            dismiss(animated: true)
            ((presentingViewController as! UINavigationController).viewControllers[0] as! MarquesCollectionViewController).loadBrands()
            
        }
            
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        performSegue(withIdentifier: "registerSegue", sender: nil)
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let myString = "Don't have an account yet?. "
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor(red: 110/255.0, green: 110/255.0, blue: 115/255.0, alpha: 1.0) ]
        let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)

        
        var string = "Sign Up."
        var attributedString = NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: "https://signup.fr")!])
        
        myAttrString.append(attributedString)
        signInTextView.attributedText = myAttrString;
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
    
//MARK: - tableview delegates

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            authenticate()
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

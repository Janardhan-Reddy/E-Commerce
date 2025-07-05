//
//  OrderSummaryController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 27/11/22.
//

import UIKit
import Razorpay
class OrderSummaryController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RazorpayPaymentCompletionProtocol{
    
 

    
    
    var razorpay:RazorpayCheckout!
    var totalAmount:Double = 0.0
    func onPaymentError(_ code: Int32, description str: String) {
            print("error: ", code, str)
           // self.presentAlert(withTitle: "Alert", message: str)
        }

    func onPaymentSuccess(_ payment_id: String) {

    }
  
    var counts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var image:UIImage?
    var productName:String?
    var price:String?
    var productCategory:String?
    var Description:String?
    var rating:String?
    var total:Double?
    let rupeeSymbol = "\u{20B9}"
    let OrderImage:[String] = ["iphone","mobile","mobile11","mobile3","mobile4","mobile5","mobile6","mobile10","mobile8","mobile9"]
    let OrderProductLabel:[String] = ["iphone13","iphone13pro","iphone14","iphone14pro","iphone12","samsung S20","Vivo V20","Sony Z5","Oppo Reno10x","POCO F4"]
    let OrderPriceLabel:[String]  = ["95,000","85,200","79,200","86,200","98,000","26,200","32,000","22,000","35,000","32,000"]
    //UICollectionView delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OrderImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OrderedCollectionViewCell.dequeueReusableCell(withReuseIdentifier: "OrderSummaryCell", for: indexPath) as! CustomeOrderSummary
        cell.OrderImage.image = UIImage(named: OrderImage[indexPath.row])
        cell.OrderProductLabel.text = OrderProductLabel[indexPath.row]
        cell.OrderPriceLabel.text = "\u{20B9} \(OrderPriceLabel[indexPath.row])"
        let count = counts[indexPath.row]
            cell.countlabel.text = "\(count)"
            
        cell.incrementButton.addTarget(self, action: #selector(incrementCount(sender:)), for: .touchUpInside)
        cell.decrementButton.addTarget(self, action: #selector(decrementCount(sender:)), for: .touchUpInside)
      //  cell.backgroundColor = .gray
      
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((self.view.frame.size.width/2) - 10), height: 255)
        }
    
   
    @objc func incrementCount(sender: UIButton) {
        guard let cell = sender.superview?.superview as? CustomeOrderSummary,
              let indexPath = OrderedCollectionViewCell.indexPath(for: cell) else {
            return
        }
        
        counts[indexPath.row] += 1
        cell.countlabel.text = "\(counts[indexPath.row])"
    }
    @objc func decrementCount(sender: UIButton) {
        guard let cell = sender.superview?.superview as? CustomeOrderSummary,
              let indexPath = OrderedCollectionViewCell.indexPath(for: cell) else {
            return
        }
        
        counts[indexPath.row] -= 1
        cell.countlabel.text = "\(counts[indexPath.row])"
    }
   
    

        
    //ContinueButtonAction
    @IBAction func ContinueAction(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let OrderSuccessPage = storyboard.instantiateViewController(identifier: "OrderSuccessPage") as OrderSuccessPage
//        let navigationcontroller = UINavigationController(rootViewController: OrderSuccessPage)
//        self.navigationController?.pushViewController(OrderSuccessPage, animated: true)
//        navigationcontroller.modalPresentationStyle = .fullScreen
        self.showPaymentForm()
    }
    
   
    
    @IBOutlet weak var itemsAmtLabel: UILabel!
    
    @IBOutlet weak var TotalAmtLabel: UILabel!
    
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    //UICollectionView
    @IBOutlet weak var OrderedCollectionViewCell: UICollectionView!
    
    override func viewDidLoad() {
      
        
        itemsAmtLabel.text = "\(rupeeSymbol)\(Int(total ?? 0))"
        let tax = 17
        let shipping = 59
       
        shippingLabel.text = "\(rupeeSymbol)\(shipping)"
        taxLabel.text = "\(rupeeSymbol)\(tax)"
        if let totalPrice = total {
            totalAmount = Double(Int(totalPrice) + tax + shipping)
            let totalAmountWithSymbol = "\(rupeeSymbol)\(" ")\(totalAmount)"
            // Now you can use the 'totalAmountWithSymbol' string as needed, for example:
            TotalAmtLabel.text = totalAmountWithSymbol
        } else {
            // Handle the case where 'total' is nil
            // For example, you can set a default value or display an error message.
            TotalAmtLabel.text = "Total not available"
        }
        razorpay = RazorpayCheckout.initWithKey("rzp_test_6d1SWcchqSjGGb", andDelegate: self)
      
      
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    internal func showPaymentForm(){
        let options: [String:Any] = [
                    "amount": totalAmount * 100, //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
                    "description": "purchase description",
                    "image": "https://url-to-image.jpg",
                    "name": "business or product name",
                    "prefill": [
                        "contact": "9797979797",
                        "email": "foo@bar.com"
                    ],
                    "theme": [
                        "color": "#F37254"
                    ]
                ]
        razorpay.open(options)
    }
}

/*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if self.selectedCells.contains(indexPath.row) {
            let index = self.selectedCells.firstIndex(of: indexPath.row)
            self.selectedCells.remove(at: index!)
            let amount = Int(roomArray[indexPath.row].roomAmount)!
            bujjiLabel.text = String(amount.self)
            let tax = Int(roomArray[indexPath.row].roomTax)!
            print(tax)
            taxBujji.text = String(tax.self)
            let multiplie = amount * tax
            let intrest =  multiplie / 100
            let finalamount = (amount + intrest )
            amount1 = amount1 - finalamount
            kondaLabel?.text =  String(amount1.self)
            print(amount1)
           
            let y = roomArray[indexPath.row].roomType
            print👍
            bujjiroom.text = String(y.self)
          
        }else {
            self.selectedCells.append(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "namesCell") as!  SecondScreenTableViewCell
            let amount = Int(roomArray[indexPath.row].roomAmount)!
            print(amount)
            bujjiLabel.text = String(amount.self)
            
            let tax = Int(roomArray[indexPath.row].roomTax)!
            print(tax)
            taxBujji.text = String(tax.self)
            let multiplie = amount * tax
            let intrest =  multiplie / 100
            let finalamount = (amount + intrest )
           // print(finalamount)
            amount1 = amount1 + finalamount
            print(amount1)
            let y = roomArray[indexPath.row].roomType
            print👍
            bujjiroom.text = String(y.self)
           // kondaLabel?.text =  String(amount1.self)
           
        }
        tableView.reloadData()
        
 }*/

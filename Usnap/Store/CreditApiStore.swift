//  CreditApiStore.swift

import Foundation

class CreditApiStore : ApiStore {
    
    static let sharedInstance = CreditApiStore()
    
    func getCreditHistory(_ user_id: String, completion: @escaping (_ : CoinsHistoryBase?) -> Void)  {
        let parameters = ["userId": user_id]
        requestAPI(APIs.KCOINSHISTORY, parameters: parameters) { (response) in
            if response != nil {
                completion(CoinsHistoryBase.init(dictionary: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    func getCampaignCategories(completion: @escaping (_ : CampaignCategoryBase?) -> Void)  {
        requestAPI(APIs.KCAMPAIGNCATEGORIES) { (response) in
            if response != nil {
                completion(CampaignCategoryBase.init(dictionary: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    func getCampaignSubCategories(selectedCategory:String,completion: @escaping (_ : CampaignSubCategoryBase?) -> Void)  {
        requestAPI(APIs.KCAMPAIGNSUBCATEGORIES+selectedCategory) { (response) in
            if response != nil {
                completion(CampaignSubCategoryBase.init(dictionary: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SEND IMAGE IN COMMENT
    func sendCategoryAndSubCategoryApi( _ img_id: String, _ subcategory_id: String, _ quantity: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KDELETEIMAGE_P1_IMAGEID:img_id,
                          APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P5_QUANITY: quantity,
                          APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P6_ADDONSERVICES: subcategory_id]
        print(parameters)
        requestAPI(APIs.KCAMPAIGNUPLOADSUBCATEGORIES, parameters: parameters, requestType: .post) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    /*
     params: type(1 for purchase coin)
     */
    
    func purchaseCoin(_ user_id: String, _ type: String, _ coins: CGFloat, _ platformType : String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        /*
         type(1 for purchase coin)
         type(2 for debit coin)
         */
        let parameters = ["userId": user_id,
                          "type": type,
                          "coins": coins,
                          "platformType": platformType] as [String : Any]
        print(parameters)
        requestAPI(APIs.KCOINSPURCHASE, parameters: parameters, requestType: .post) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
//type:post body: campaignId quantity
    
    func updateCampaignQuantity(_ campaignId :String, _ quantity: String ) {
        let parameters = ["campaignId": campaignId,
                          "quantity": quantity]
        print(parameters)
        requestAPI(APIs.KUPDATECAMPAIGNQUANTITY, parameters: parameters, requestType: .post) { (response) in
          
        }
    }
}

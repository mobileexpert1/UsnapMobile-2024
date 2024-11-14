//
//  FaqAnswersViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/04/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class FaqAnswersViewController: AbstractControl {

    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var topView: TopBarView!
    var questionsArray = [BaseFaqresult]()
    
    class func control(_ selectedQuestion : BaseFaqresult) -> FaqAnswersViewController {
        let control = self.control as! FaqAnswersViewController
        control.questionsArray = [selectedQuestion]
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.leftButton1.isUserInteractionEnabled = false
        topView.leftButton2.isUserInteractionEnabled = false
        answerLabel.text = questionsArray[0].ans
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

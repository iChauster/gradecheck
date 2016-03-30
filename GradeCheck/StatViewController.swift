//
//  StatViewController.swift
//  GradeCheck
//
//  Created by Ivan Chau on 3/12/16.
//  Copyright © 2016 Ivan Chau. All rights reserved.
//

import UIKit

class Grade : NSObject {
    var grade : Int!
    var classTitle : String!
    var dictionaryObject : NSDictionary!
    init(grade:Int, className:String, dictionaryObject : NSDictionary){
        self.grade = grade;
        self.classTitle = className;
        self.dictionaryObject = dictionaryObject;
    }
}

class StatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var gpaCircle : GPAView!
    @IBOutlet weak var statTable : UITableView!
    var gradesArray = NSArray();
    var sortedArray : [Grade] = [];
    var cookie : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gpaCircle.layer.cornerRadius = 0.5 * gpaCircle.bounds.size.width;
        self.statTable.dataSource = self;
        self.statTable.delegate = self;
        self.statTable.layer.cornerRadius = 10;
        
        self.getGPA()
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatClassCell", forIndexPath: indexPath) as! StatTableViewCell;
        let element = self.sortedArray[indexPath.row] ;
        cell.classTitle.text = element.classTitle
        let g = element.grade
            switch Int(g){
            case 0..<50:
                cell.backgroundColor = UIColor.blackColor()
            case 51..<75 :
                cell.backgroundColor = UIColor.redColor()
            case 76..<85 :
                cell.backgroundColor = UIColor.yellowColor()
            case 86..<110 :
                cell.backgroundColor = UIColor(red: 0.1574, green: 0.6298, blue: 0.2128, alpha: 1.0);
            default :
                cell.backgroundColor = UIColor.purpleColor()
            }
       
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray.count;
    }
    override func viewDidAppear(animated: Bool) {
        self.getGPA()
        
    }
    func getGPA(){
        var gradeTotal = 0.0;
        var classes = 0;
        var gpaTotal = 0.0;
        self.sortedArray = [];
        for i in 0 ..< gradesArray.count{
            if(i == 0){
                continue;
            }
            
            let a = gradesArray[i];
            print(a);
            var grade : String!;
            var gradeInt : Int!;
            
            if(a.objectForKey("grade") as! String == "No Grades"){
                let new = Grade(grade: 0, className: gradesArray[i].objectForKey("class") as! String, dictionaryObject : a as! NSDictionary);
                self.sortedArray.append(new)
                continue;
            }
            if(a.objectForKey("class")!.containsString(" H") || a.objectForKey("class")!.containsString("AP") || a.objectForKey("class")!.containsString("Honors") || a.objectForKey("class")!.containsString("Hon")){
                grade = a.objectForKey("grade") as! String;
                grade = String(grade.characters.dropLast());
                print(grade);
                gradeInt = Int(grade)! + 5;
                gradeTotal += Double(gradeInt);
                let new = Grade(grade: gradeInt, className: a.objectForKey("class") as! String, dictionaryObject : a as! NSDictionary);
                self.sortedArray.append(new);
                if(gradeInt > 100){
                    gradeInt = 100;
                }
                gpaTotal += Double(gradeInt);
                classes += 1;
                
            }else{
                grade = a.objectForKey("grade") as! String
                grade = String(grade.characters.dropLast());
                print(grade);
                gradeInt = Int(grade)!;
                let new = Grade(grade: gradeInt, className: a.objectForKey("class") as! String, dictionaryObject : a as! NSDictionary);
                self.sortedArray.append(new);
                gradeTotal += Double(gradeInt);
                if(gradeInt > 95){
                    gradeInt = 95;
                }
                gpaTotal += Double(gradeInt);
                classes += 1;
            }
            
        }
        
        let average = gradeTotal/Double(classes);
        print(average);
        print(round(average))
        let gpaAvg = gpaTotal/Double(classes);
        print(gpaAvg);
        print(round(gpaAvg))
        let gpaDifference = 10 - round(gpaAvg)/10
        print(gpaDifference);
        let gpa = 4.5 - gpaDifference;
        print(gpa);
        CellAnimation.growAndShrink(self.gpaCircle);
        self.gpaCircle.GPA.text = String(gpa)
        self.gpaCircle.avg.text = String(average) + "%";
        self.sortedArray.sortInPlace { (element, second) -> Bool in
            return element.grade > second.grade
        }
        self.statTable.reloadData()

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("StatSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "StatSegue"){
            let view = segue.destinationViewController as! DetailStatViewController
            view.data = self.sortedArray[self.statTable.indexPathForSelectedRow!.row].dictionaryObject as NSDictionary
            view.gradesArray = self.gradesArray
            view.cookie = self.cookie;
            let selectedObject = self.sortedArray[self.statTable.indexPathForSelectedRow!.row];
            view.className = selectedObject.classTitle
            self.statTable.deselectRowAtIndexPath(self.statTable.indexPathForSelectedRow!, animated: true)

        }
    }
    

}

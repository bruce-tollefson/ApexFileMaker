@isTest
public class FileMakerTest {
    
    private static List<String> CSVHEADERS = new List<String>{'Id','Name'};
        
        @testSetup static void setupMethod() {
            
            Account act1 = new Account(Name= 'test');
            insert act1;
            Account act2 = new Account(Name= 'test2');
            insert act2;
        } 
    
    @isTest
    public static void createCSVsObjectSameAPINames() {
        List<Account> actList = [Select Id, Name from Account];
        Account act1 = actList[0];
        Account act2 = actList[1];
        
        Test.startTest();
        FileMaker.createCSV(CSVHeaders, actList, 'Testing File 1');
        Test.stopTest();
        ContentVersion cv = [Select Id, Title, VersionData from ContentVersion where title = 'Testing File 1.csv'];
        System.assertEquals('Id,Name\n'+act1.Id+','+act1.Name+'\n'+act2.Id+','+act2.Name,cv.VersionData.toString());
    }
    
    @isTest
    public static void createCSVsObjectDifferentAPINames() {
        List<Account> actList = [Select Id, Name from Account];
        Account act1 = actList[0];
        Account act2 = actList[1];
        
        Test.startTest();
        FileMaker.createCSV(new List<String>{'Column1','Column2'}, CSVHeaders, actList, 'Testing File 2');
        Test.stopTest();
        ContentVersion cv = [Select Id, Title, VersionData from ContentVersion where title = 'Testing File 2.csv'];
        System.assertEquals('Column1,Column2\n'+act1.Id+','+act1.Name+'\n'+act2.Id+','+act2.Name,cv.VersionData.toString());
    }
    
    @isTest
    public static void createCSVString() {
        
        List<String> stringRowsList = new List<String>{'Hello,World','Hello,World'};
            Test.startTest();
        FileMaker.createCSV(CSVHeaders, stringRowsList, 'Testing File 3');
        Test.stopTest();
        ContentVersion cv = [Select Id, Title, VersionData from ContentVersion where title = 'Testing File 3.csv'];
        System.assertEquals('Id,Name\nHello,World\nHello,World',cv.VersionData.toString());
    }
    
    @isTest
    public static void createCSVListOfListObjects() {
        
        List<Integer> row = new List<Integer>{1,2};
            List<List<Integer>> rowList = new List<List<Integer>>();
        rowList.add(row);
        rowList.add(row);
        Test.startTest();
        FileMaker.createCSV(CSVHeaders, rowList, 'Testing File 4');
        Test.stopTest();
        ContentVersion cv = [Select Id, Title, VersionData from ContentVersion where title = 'Testing File 4.csv'];
        System.assertEquals('Id,Name\n1,2\n1,2',cv.VersionData.toString());
    }
}
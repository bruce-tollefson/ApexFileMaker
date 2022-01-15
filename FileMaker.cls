public class FileMaker {

    /**
    @description create a CSV from a list of sObjects in this method the CSV headers are the same as the api names of the fields to add
    */
    public static void createCSV(List<String> csvHeaders, List<sObject> csvRowList, String title){
        String headerRow = String.join(csvHeaders,',') + '\n';
        String concantenatedStr = headerRow;
        concantenatedStr = createSObjectString(csvHeaders, csvRowList, concantenatedStr);
        title += '.csv';
        createFile(concantenatedStr, title);
    }

    /**
    @description create a CSV from a list of sObjects in this method the CSV headers different than the api names of the fields to add
    */
    public static void createCSV(List<String> csvHeaders, List<String> csvFieldAPINames, List<sObject> csvRowList, String title){
        String headerRow = String.join(csvHeaders,',') + '\n';
        String concantenatedStr = headerRow;
        concantenatedStr = createSObjectString(csvFieldAPINames, csvRowList, concantenatedStr);
        title += '.csv';
        createFile(concantenatedStr, title);
    }

    /**
    @description create a CSV file from a list of Strings each string should be a row, if each String is a cell use the List<List<Object>> method
    */
    public static void createCSV(List<String> csvHeaders, List<String> csvRowList, String title){
        String headerRow = String.join(csvHeaders,',') + '\n';
        String concantenatedStr = headerRow;
        Integer i = 0;
        Integer rowListSize = csvRowList.size();
        //assuming the rowList is in the correct format and each object in the list is a new record
        for(String row :csvRowList){
           
            i++;
            concantenatedStr += (String)row + ((i != rowListSize) ? '\n' : '');//add new line
        }
        title += '.csv';
        createFile(concantenatedStr, title);
    }

    /**
    @description create a CSV file from a list of Object Lists each Object List is a row in a list of lists. Each Object is a cell in the CSV
    */
    public static void createCSV(List<String> csvHeaders, List<List<Object>> csvRowList, String title){
        String headerRow = String.join(csvHeaders,',') + '\n';
        String concantenatedStr = headerRow;
        Integer i = 0;
        Integer rowListSize = csvRowList.size();
        for(List<Object> row :csvRowList){
            if(csvHeaders.size() != row.size()) throw new FileMakerException('The row size needs to be the same size as the header');//check the row list is the same size as the header list
            concantenatedStr += String.join(row, ',');
            i++;
            if(i != rowListSize) concantenatedStr += '\n';//add new line
        }
        title += '.csv';
        createFile(concantenatedStr, title);
    }

    /**
    @description create a file - generic
    */
    public static void createFile(String versionData, String title) {
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S'; //denotes it resides on Salesforce
        cv.Title = title; //title of the file
        cv.PathOnClient = title; // full path within Salesforce this can just be the name of file to be in the library
        cv.VersionData = Blob.valueOf(versionData); //file data
        insert cv;
    }

    
    /**
    @description private method for looping through and creating the CSV string from a list of sOBjects
    */
    private static String createSObjectString(List<String> csvFieldAPINames, List<sObject> csvRowList, String concantenatedStr){
        Integer i = 0;
        Integer rowListSize = csvRowList.size();
        Integer headerSize = csvFieldAPINames.size();
        for(sObject row :csvRowList){
            //assuming the rowList is in the correct format and each string in the list is a new record
            Map<String, Object> objFieldMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(row));
            Integer j = 0;
            for(String objField :csvFieldAPINames){
                concantenatedStr += objFieldMap.get(objField) != null ? String.valueOf(objFieldMap.get(objField)) : '';
                j++;
                concantenatedStr += j != headerSize ? ',' : '';//add comma separator
            }
            i++;
            if(i != rowListSize) concantenatedStr += '\n';//add new line
        }
        return concantenatedStr;
    }

    public class FileMakerException extends Exception{}
}

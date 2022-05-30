@RestResource(urlMapping='/apiPost/*')
global with sharing class IntegrationPostmanPost {
    
    @HttpPost
    global static String postInfo (String postName, String postIp, string postCity, string postRegion, string postCountry){
        integration__c newRecord = new integration__c();
        newRecord.name = postName;
        newRecord.ipField__c = postIp;
        newRecord.cityField__c = postCity;
        newRecord.regionField__c = postRegion;
        newRecord.countryField__c = postCountry;
        insert newRecord;
        return ('New record was succusfully created: ' + newRecord.id);

    }
}

@RestResource(urlMapping='/territoryInfo/*')
global  class IntegrationPostmanGet{

    global class territoryInfo{
        String city {get;set;}
        String region {get;set;}
        String country {get;set;}
        Datetime dateTimeCustom {get;set;}
    }

    @httpGet
    global static territoryInfo getInfo() {
        RestRequest request = RestContext.Request;
        String somethingId = request.requestURI.substring(request.RequestURI.lastIndexOf('/')+1);
        
        integration__c record = [SELECT id, ipField__c, cityField__c, regionField__c, countryField__c, dateTimeField__c 
        FROM integration__c WHERE id =: somethingId];
        territoryInfo terInfo =  new territoryInfo ();
        terInfo.city = record.cityField__c;
        terInfo.region = record.regionField__c;
        terInfo.country = record.countryField__c;
        terInfo.dateTimeCustom = record.dateTimeField__c;
        return terInfo;
    }
}
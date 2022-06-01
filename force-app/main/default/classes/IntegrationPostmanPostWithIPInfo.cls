@RestResource(urlMapping='/apiPostNew/*')
global with sharing class IntegrationPostmanPostWithIPInfo {
    
    @HttpPost
    global static String postInfo (String postName, String postIp){
        tokenCS__c mc = tokenCS__c.getValues('adminToken');
        String token = mc.tokenData__c;
        System.debug('token: ' + token);
        String endPointIp = 'https://ipinfo.io/'+ postIp +'/geo' + token;

        integration__c newRecord = new integration__c();
        newRecord.name = postName;
        newRecord.ipField__c = postIp;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endPointIp);
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            Map<String,Object> mapResult = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            newRecord.cityField__c = (String) mapResult.get('city');
            newRecord.regionField__c =(String) mapResult.get('region');
            newRecord.countryField__c = (String) mapResult.get('country');
            insert newRecord;
            return ('New record was succusfully created: ' + newRecord.id);
        } else {
            return ('Something wrong with request status. Its not 200');
        }
    }
}

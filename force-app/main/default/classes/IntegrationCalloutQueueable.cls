public class IntegrationCalloutQueueable implements Queueable, Database.AllowsCallouts{
    // Database.AllowCallouts are used to allow Callouts in batch Apex
    // Callouts include HTTP requests as well as methods defined with the webService keyword.
    
    // Тестовые айпи и айди
    String currentIp='https://ipinfo.io/87.229.240.154';
    String currentId='a00IY000001I341YAC';

    // Constructor in Apex Programming is a code that is called when an object is created from the class.
    // Method name will be same as Class.
    // Access specifier will be public.
    // This method will invoked only one that is at the time of creating an object.
    
    // Get data(Ip&Id) from IntegrationSchedule Class
    public IntegrationCalloutQueueable (String receivedIp, String receivedId){
        // StaticResource sr= [select body from StaticResource Where Name = 'ipServiceToken'];
        // String token = sr.body.toString();

        // Custom setting
        tokenCS__c mc = tokenCS__c.getValues('adminToken');
        String token = mc.tokenData__c;
        if (token != null) {
            this.currentIp = 'https://ipinfo.io/'+ receivedIp +'/geo' + token;
            this.currentId = receivedId;
            System.debug('Ip: ' + this.currentId);
            System.debug('Id: ' + this.currentId);
        } else {
            System.debug('Invalid token, check custom setting');
        }
    }

    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(this.currentIp);
        HttpResponse response = http.send(request);
        System.debug('Current response from server: ' + response);

        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // JSON is like a string, so the built-in JSONParser class converts it to an object
            // Deserialize the JSON string into collections of primitive data types.
            Map<String,Object> mapResult = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Result: '+ mapResult);
            TimeZone tz = UserInfo.getTimeZone();
            DateTime dt = Datetime.now();
            DateTime FormatedTime = dt.addSeconds((tz.getOffset(dt)/1000));
            System.debug('Formatted Time ' + FormatedTime);
            
            // SOQL to find record
            integration__c recordToUpdate = [SELECT ipField__c, cityField__c, regionField__c, countryField__c, dateTimeField__c FROM integration__c WHERE Id =: this.currentId LIMIT 1];
            System.debug(recordToUpdate);
            // Filling fields with values
            recordToUpdate.ipField__c = (String) mapResult.get('ip');
            recordToUpdate.cityField__c = (String) mapResult.get('city');
            recordToUpdate.regionField__c = (String) mapResult.get('region');
            recordToUpdate.countryField__c = (String) mapResult.get('country');
            recordToUpdate.dateTimeField__c = FormatedTime;
            System.debug(recordToUpdate);
            update recordToUpdate;
            }
    }
}

public class IntegrationSchedule implements Schedulable {
    // Scheduler lets you delay execution so that you can run Apex classes at a specified time. 
    public static void execute(SchedulableContext context) {
       System.debug('Schedulable Context here:' + context);

        List<integration__c> dataIpList = [SELECT ipField__c, Id FROM integration__c];
        for (integration__c objRec : dataIpList){
            //check data quality
            if ((objRec.ipField__c != null) & (objRec.Id != null)){
                System.enqueueJob(new IntegrationCalloutQueueable(objRec.ipField__c, objRec.Id));
            } else {
                System.debug ('Wrong data from query, check records');
            }
        }
    }
    // call this in Anonymous apex to schedule job 
    // IntegrationSchedule  schClass = new IntegrationSchedule(); 
    // String cronExp = '0 11 * * * ?';
    // System.schedule('IntegrationWork', cronExp, schClass);
}
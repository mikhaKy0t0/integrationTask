@isTest
public class IntegrationTest {
    public static testMethod void testJob(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ipInfoTestData');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.StartTest();
        String cronExp = '0 0 13 * * ?';
        IntegrationSchedule schClass = new IntegrationSchedule();
        // call Schedule Class 
        String jobId = system.schedule('Test Schedule Class', cronExp, schClass);
        // query data from class execution
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // check results
        System.assertEquals(cronExp, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-05-19 13:00:00', String.valueOf(ct.NextFireTime));
        
        //call Queueable class
        integration__c pros = new integration__c(Name='recordName',ipField__c='87.229.240.154');
        insert pros;
        Id idJobQueue = System.enqueueJob(new IntegrationCalloutQueueable(pros.ipField__c,pros.Id));
        System.debug('Id of queueable job' + idJobQueue);
        System.assertEquals('Queued', [SELECT Id, Status FROM AsyncApexJob WHERE Id=:idJobQueue][0].Status);    
        // System.assertEquals(10, checkRecords.size());
        Test.stopTest();
    }
}
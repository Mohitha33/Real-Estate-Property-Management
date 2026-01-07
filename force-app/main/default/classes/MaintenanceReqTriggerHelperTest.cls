@isTest
public with sharing class MaintenanceReqTriggerHelperTest {
    @TestSetup
    static void setupData(){
        List<Vendor__c> vendors = new List<Vendor__c>();
        vendors.add(new Vendor__c(Name = 'Vendor 1',Phone_Number__c = '1234567890',Email__c = 'vendor1@test.com'));
        vendors.add(new Vendor__c(Name = 'Vendor 2',Phone_Number__c = '8888888888',Email__c = 'vendor2@test.com'));
        vendors.add(new Vendor__c(Name = 'Vendor 3',Phone_Number__c = '7777777777',Email__c = 'vendor3@test.com'));
        insert vendors;

        List<Maintenance_Request__c> maintenanceRequests = new List<Maintenance_Request__c>();
        maintenanceRequests.add(new Maintenance_Request__c(Name = 'Request 1', Status__c = 'In Progress', Vendor__c = vendors[0].Id));
        maintenanceRequests.add(new Maintenance_Request__c(Name = 'Request 2', Status__c = 'In Progress', Vendor__c = vendors[0].Id));
        maintenanceRequests.add(new Maintenance_Request__c(Name = 'Request 3', Status__c = 'In Progress', Vendor__c = vendors[1].Id));
        insert maintenanceRequests;
    }
        @isTest
        static void testAssignVendor(){
            List<Maintenance_Request__c> newRequests = new List<Maintenance_Request__c>();
            newRequests.add(new Maintenance_Request__c(Name = 'Request 4', Status__c = 'In Progress'));
            newRequests.add(new Maintenance_Request__c(Name = 'Request 5', Status__c = 'In Progress'));
            insert newRequests;
        
        for(Maintenance_Request__c mr : [SELECT Id, Vendor__c FROM Maintenance_Request__c WHERE Id IN :newRequests]){
            System.assertNotEquals(null, mr.Vendor__c, 'Vendor should be assigned to the request');
        }
    }
        
        @isTest
        static void testNoVendorAvailable(){
            delete [SELECT Id FROM Vendor__c];
            Maintenance_Request__c requests = new Maintenance_Request__c(Name = 'No Vendor Req', Status__c = 'In Progress');
            try{
                insert requests;
                System.assert(false, 'insert should fail when no vendors exist');
            }
            catch(DmlException e){
                System.assert(e.getMessage().contains('No Vendor Available'), 'Expected no vendor available error');
            }     
    }
}
public with sharing class LeaseExpiryScheduler implements Schedulable{
    public  void execute(SchedulableContext sc){
        Date endDate = Date.today().addDays(30);
        List<Lease_Agreement__c> leaseAgreements = [SELECT Id, Name, Tenant__r.Email__c, Tenant__r.Name, End_Date__c, Reminder_Sent__c FROM Lease_Agreement__c WHERE End_Date__c = :endDate AND Tenant__r.Email__c != null];
        if(leaseAgreements.isEmpty()){
            return;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Lease_Agreement__c> leaseAgreementsToUpdate = new List<Lease_Agreement__c>();
        for(Lease_Agreement__c leaseAgreement : leaseAgreements){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{leaseAgreement.Tenant__r.Email__c});
            email.setSubject('Lease Agreement Expiry Reminder');
            email.setPlainTextBody('Your lease agreement with ' + leaseAgreement.Name + ' is expiring on ' + leaseAgreement.End_Date__c + '. Please renew your lease as soon as possible.');
            emails.add(email);

            leaseAgreementsToUpdate.add(new Lease_Agreement__c(Id = leaseAgreement.Id, Reminder_Sent__c = true));

        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);

            update leaseAgreementsToUpdate;
        }
    }
    
}
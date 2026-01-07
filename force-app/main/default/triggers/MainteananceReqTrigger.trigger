trigger MainteananceReqTrigger on Maintenance_Request__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        MaintenanceReqTriggerHelper.assignVendor(Trigger.new);
    }
}
public with sharing class MaintenanceReqTriggerHelper {
    public static void assignVendor(List<Maintenance_Request__c> newRequests) {
        if(newRequests.isEmpty()){
            return;
        }
            List<Vendor__c> vendors = [SELECT Id, Name FROM Vendor__c];
            
            if(vendors.isEmpty()){
                for(Maintenance_Request__c mr : newRequests){
                    mr.addError('No Vendor Available');
                }
                return;
            }
                Map<Id, Integer> vendorWorkload = new Map<Id, Integer>();
                List<AggregateResult> aggResult = 
                [SELECT Vendor__c, Count(Id) cnt
                FROM Maintenance_Request__c
                WHERE Status__c != 'Completed' AND Vendor__c != null
                GROUP BY Vendor__c
                ];

                for(AggregateResult ar : aggResult){
                    vendorWorkload.put((Id)ar.get('Vendor__c'), (Integer)ar.get('cnt'));
                }
                for(Maintenance_Request__c mr : newRequests){
                    Integer minWorkload = 2147483647;
                    Id selectedVendorId;
                    for(Vendor__c v : vendors){
                    Integer workLoad = vendorWorkload.containsKey(v.Id) ? vendorWorkload.get(v.Id) : 0;  
                        if(workLoad < minWorkload){
                            minWorkload = workLoad;
                            selectedVendorId = v.Id;
                        }
                    }
                    mr.Vendor__c = selectedVendorId;
                    vendorWorkload.put(selectedVendorId, minWorkload + 1);
                }
    }
}
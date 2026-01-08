public with sharing class PropertyController {
    @AuraEnabled(Cacheable = true)
    public static PropertyPageResult getProperties(Integer pageNumber, Integer pageSize, Decimal minPrice, Decimal maxPrice, String status, String furnishingStatus){
        if(pageNumber == null || pageNumber < 1){
            pageNumber = 1;
        }
        if(pageSize == null || pageSize < 1){
            pageSize = 25;
        }
        Integer offset = (pageNumber - 1) * pageSize;
        String query = ' FROM Property__c WHERE Id != null';
        if(minPrice != null){
            query += ' AND Rent__c >=  :minPrice';
        }
        if(maxPrice != null){
            query += ' AND Rent__c <=  :maxPrice'; 
        }
        if(status != null && status != ''){
            query += ' AND Status__c = :status';
        }
        if(furnishingStatus != null && furnishingStatus != ''){
            query += ' AND Furnishing_Status__c = :furnishingStatus';
        }
        String dataQuery = ' SELECT Id, Name, Rent__c, Status__c, Furnishing_Status__c ' + query + ' ORDER BY CreatedDate DESC ' + ' LIMIT :pageSize OFFSET :offset';          
        String countQuery = ' SELECT COUNT() ' + query;
        List<Property__c> properties = Database.query(dataQuery);
        Integer totalRecords = (Integer) Database.countQuery(countQuery);
        return new PropertyPageResult(properties, totalRecords);
    }

    public class PropertyPageResult{
        @AuraEnabled
        public List<Property__c> records;
        @AuraEnabled
        public Integer totalRecords;
        public PropertyPageResult(List<Property__c> records, Integer totalRecords){
            this.records = records;
            this.totalRecords = totalRecords;
        }
    }
}
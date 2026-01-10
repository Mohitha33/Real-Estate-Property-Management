@IsTest
public class PropertyControllerTest {

    private static List<Property__c> createTestProperties() {
        List<Property__c> props = new List<Property__c>();

        props.add(new Property__c(
            Name = 'Property 1',
            Address__c = 'Street 1',
            City__c = 'Hyderabad',
            State__c = 'Telangana',
            Postal_Code__c = '500001',
            Country__c = 'India',
            Type__c = 'Commercial',
            Rent__c = 5000,
            Status__c = 'Available',
            Furnishing_Status__c = 'Unfurnished',
            Description__c = 'This is a test property'
        ));

        props.add(new Property__c(
            Name = 'Property 2',
            Address__c = 'Street 2',
            City__c = 'Bangalore',
            State__c = 'Karnataka',
            Postal_Code__c = '560001',
            Country__c = 'India',
            Type__c = 'Residential',          
            Rent__c = 8000,
            Status__c = 'Occupied',
            Furnishing_Status__c = 'Furnished',
            Description__c = 'Test property 2'
        ));

        props.add(new Property__c(
            Name = 'Property 3',
            Address__c = 'Street 3',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Postal_Code__c = '600001',
            Country__c = 'India',
            Type__c = 'Commercial',
            Rent__c = 12000,
            Status__c = 'Available',
            Furnishing_Status__c = 'Semi-Furnished',
            Description__c = 'Test property 3'
        ));

        insert props;
        return props;
    }

    @IsTest
    static void testGetProperties_Default() {
        createTestProperties();

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, null, null, null, null);
        System.Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.records.size() > 0, 'Records should be returned');
        System.assertEquals(3, result.totalRecords, 'Total records count mismatch');
    }

    @IsTest
    static void testGetProperties_MinPriceFilter() {
        createTestProperties();

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, 7000, null, null, null);
        System.Test.stopTest();

        System.assertEquals(2, result.records.size(), 'Min price filter failed');
    }

    @IsTest
    static void testGetProperties_MaxPriceFilter() {
        createTestProperties();

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, null, 6000, null, null);
        System.Test.stopTest();

        System.assertEquals(1, result.records.size(), 'Max price filter failed');
    }

    @IsTest
    static void testGetProperties_StatusFilter() {
        createTestProperties();

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, null, null, 'Available', null);
        System.Test.stopTest();

        System.assertEquals(2, result.records.size(), 'Status filter failed');
    }

    @IsTest
    static void testGetProperties_FurnishingFilter() {
        createTestProperties();

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, null, null, null, 'Unfurnished');
        System.Test.stopTest();

        System.assertEquals(1, result.records.size(), 'Furnishing filter failed');
    }

    @IsTest
    static void testPagination() {
        List<Property__c> props = new List<Property__c>();
        for (Integer i = 1; i <= 30; i++) {
            props.add(new Property__c(
                Name = 'Property ' + i,
                Rent__c = 1000 * i,
                Status__c = 'Available',
                Furnishing_Status__c = 'Unfurnished'
            ));
        }
        insert props;

        System.Test.startTest();
        PropertyController.PropertyPageResult result =
            PropertyController.getProperties(1, 25, null, null, 'Available', 'Unfurnished');
        System.Test.stopTest();

        System.assertEquals(25, result.records.size(), 'Pagination page size incorrect');
        System.assertEquals(30, result.totalRecords, 'Total records incorrect');
    }
}

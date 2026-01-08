import { LightningElement } from 'lwc';
import getProperties from '@salesforce/apex/propertyController.getProperties';
export default class PropertyList extends LightningElement {
    pageNumber = 1;
    pageSize = 25;
    totalRecords = 0; 
    properties = [];  
    minPrice = null;
    maxPrice = null;
    status = null;
    furnishingStatus  = null;
    statusOptions = [
        {label: 'Available', value: 'Available'},
        {label: 'Occupied', value: 'Occupied'}
    ];
    furnishingStatusOptions = [
        {label: 'Fully Furnished', value: 'Fully Furnished'},
        {label: 'Semi Furnished', value: 'Semi-Furnished'},
        {label: 'Unfurnished', value: 'Unfurnished'}
    ];
    columns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Rent', fieldName: 'Rent__c'},
        {label: 'Status', fieldName: 'Status__c'},
        {label: 'Furnishing Status', fieldName: 'Furnishing_Status__c'}
    ];
    connectedCallback(){
        this.loadProperties();
    }
    loadProperties(){
        getProperties({pageNumber:this.pageNumber,pageSize:this.pageSize, minPrice:this.minPrice, maxPrice:this.maxPrice, status:this.status, furnishingStatus:this.furnishingStatus})
        .then(result => {
            this.properties = result.records;
            this.totalRecords = result.totalRecords;
        })
        .catch(error => {
            console.error(error);
        });
    }
    applyFilters(){
        this.pageNumber = 1;
        this.loadProperties();
        console.log('Apply Filters clicked');
        console.log('Filters:',
        typeof this.minPrice, this.minPrice,
        typeof this.maxPrice, this.maxPrice,
        typeof this.status, this.status,
        typeof this.furnishingStatus, this.furnishingStatus);
    }
    handleMinPriceChange(event){
        const value = event.target.value;     
        this.minPrice = Number(value); 
        console.log('Min Price:', this.minPrice);
    }
    handleMaxPriceChange(event){
        const value = event.target.value;     
        this.minPrice = Number(value);
    }
    handleStatusChange(event){
        this.status = event.detail.value;
    }
    handleFurnishingStatusChange(event){
        this.furnishingStatus = event.detail.value;
    }
    handlePrevious(){
        if(this.pageNumber > 1){
            this.pageNumber--;
            this.loadProperties();
        }
    }
    handleNext(){
        if(this.pageNumber < this.totalPages){
            this.pageNumber++;
            this.loadProperties();
        }
    }
    get disablePrevious(){
        return this.pageNumber <= 1;
    }
    get disableNext(){
        return this.pageNumber >= this.totalPages;
    }
    get totalPages(){
        return Math.ceil(this.totalRecords / this.pageSize);
    }


}
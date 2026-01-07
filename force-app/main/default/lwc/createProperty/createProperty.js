/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi'; 
//import { NavigationMixin } from 'lightning/navigation';//

export default class CreateProperty extends LightningElement {
    recordId;
    showFileUpload = false;
    imageUploaded = false;  
    showForm = true; 
      
    handleSuccess(event) {
        this.recordId = event.detail.id;
        this.showFileUpload = true;
        const toastEvent = new ShowToastEvent({
            title: 'Property Created',
            message: 'Please upload atleast one image to complete the process',
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
    }
    handleUploadFinished(event) {
        if(event.detail.files.length > 0){
            this.imageUploaded = true;
            this.markPropertyAsAvailable();
        }
    }
    
    markPropertyAsAvailable(){
        const fields = {
            Id: this.recordId,
            Status__c: 'Available'
        };
        updateRecord({fields})
            .then(() => {
                this.showFileUpload = false;
                this.recordId = null;
                this.resetForm();
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: 'Property is now available with images uploaded',
                    variant: 'success'
            });
            this.dispatchEvent(toastEvent);
        
           /* this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Property__c',
                    actionName: 'view'
                }
            });*/
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
    }
    resetForm(){
        this.showForm = false;
        setTimeout(() => {
            this.showForm = true;
        }, 0);   
    }
}
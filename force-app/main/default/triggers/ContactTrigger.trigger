trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete ) {

    if( Trigger.isAfter && trigger.isDelete ){

        ContactTriggerHelper.contactRollUpAggDelete( Trigger.old );
    }

    if( Trigger.isAfter && Trigger.isUpdate ){

        ContactTriggerHelper.contactAmountRollUpUpdate( Trigger.oldMap, Trigger.newMap );
        //ContactTriggerHelper.addContactNameOnAcccountUpdate( Trigger.oldMap, Trigger.newMap );
        ContactTriggerHelper.addContactNameOnAcccountUpdateSOQL( Trigger.oldMap, Trigger.newMap );
    }

    if( (Trigger.isAfter && Trigger.isInsert) ||  (Trigger.isAfter && Trigger.isUndelete) ){

        ContactTriggerHelper.contactAmountRollUpInsert( Trigger.newMap );
        ContactTriggerHelper.contactRollUpAggUpdateInsertUndelete( Trigger.new );
        ContactTriggerHelper.addContactNameOnAcccountInsertSOQL( Trigger.new );
    }
}

// Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
// Schema.SObjectType s = m.get('API_Name_Of_SObject') ;
// Schema.DescribeSObjectResult r = s.getDescribe() ;
// Map<String,Schema.SObjectField> fields = r.fields.getMap() ;

// Schema.SObjectType.Object_API_Name__c.getRecordTypeInfosByName().get('recordtype name').getRecordTypeId()


// Date dt = Date.today().addDays(7);
// Opportunity newOpportunity = new Opportunity(Name = 'shivasoft', StageName = 'Prospecting', CloseDate = dt);

// /*
// Create the parent reference. Used only for foreign key reference  and doesn't contain any other fields. If we provide any other value it will give following error

// System.DmlException: Insert failed. First exception on row 1; first error: INVALID_FIELD, More than 1 field provided in an external foreign key reference in entity: Account: []
// */

// Account accountReference = new Account(MyExtID__c = 'SHIVA1234567');
// newOpportunity.Account = accountReference;

// //  Create the Account object to insert.  Same as above but has Name field.  Used for the insert.
// Account parentAccount = new Account(Name = 'Shiva', MyExtID__c = 'SHIVA1234567');

// Database.SaveResult[]
//     results = Database.insert(new SObject[] {  parentAccount, newOpportunity });

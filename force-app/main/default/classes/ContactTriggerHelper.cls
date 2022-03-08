public with sharing class ContactTriggerHelper {

    //Get all contact name without removing data from Contact_Associated__c; UPDATE

    public static void addContactNameOnAcccountUpdate( Map<Id, Contact> oldMap, Map<Id, contact> newMap ){

        Map<Id, List<String>> accountConMap         = new Map<Id, List<String>>();
        Map<Id, Map<Id, String>> contactNameMap     = new Map<Id, Map<Id, String>>();
        List<Id> accIdList                          = new List<Id>(); 
        List<Contact> changedContactList            = fieldHasChanged( oldMap, newMap, 'FirstName');
        List<String> oldContactNames                = new List<String>();

        if( changedContactList.size() > 0 ){

            for( Contact con : changedContactList ){  

                accIdList.add( con.AccountId );
            }
        }

        for( Contact con : oldMap.values() ){

            Map<Id, String> conMap = new Map<Id, String>();
            conMap.put( con.Id, con.FirstName );
            contactNameMap.put( con.AccountId, conMap );
        } 

        system.debug( 'contactNameMap : '+ contactNameMap );

        List<Account> accountList = [ SELECT Id, name, Contact_Associated__c FROM Account WHERE Id IN :accIdList WITH SECURITY_ENFORCED ];

        if( accountList.size() > 0 ){

            for( Account acc : accountList ){
            
                if( acc.Contact_Associated__c != null ){

                    accountConMap.put( acc.Id, (acc.Contact_Associated__c).Split(',') );
                }
            }
        }

        system.debug('accountConMap :' +accountConMap);

        for( Contact con : changedContactList ){

            if( accountConMap != null ){

                String valueRemoved      = contactNameMap.get(con.AccountId).get(con.Id);
                List<String> tempConList = new List<String>();
                if( valueRemoved != null && accountConMap.get(con.AccountId) != null ){

                    tempConList = removeConName( valueRemoved, accountConMap.get(con.AccountId) ) ;
                }
                tempConList.add( String.valueOf(con.FirstName) );
                accountConMap.put( con.AccountId, tempConList );
            }
        }

        if( accountConMap.keyset().size() > 0 ){

            for( Account acc : accountList ) {

                if( accountConMap.get( acc.Id ) != null ){

                    system.debug('accountConMap.get( acc.Id )' +String.join( accountConMap.get( acc.Id ), ','));
                    acc.Contact_Associated__c = String.join( accountConMap.get( acc.Id ), ',');
                }
            }
        }
        update accountList;   
    }

    //Get all contact name with removing data from Contact_Associated__c; UPDATE 

    public static void addContactNameOnAcccountUpdateSOQL( Map<Id, Contact> oldMap, Map<Id, contact> newMap ){

        List<Contact> changedContactList    = fieldHasChanged( oldMap, newMap, 'FirstName');
        List<Id> accIdList                  = new List<Id>();
        Map<Id, List<Contact>> accConMap    = new Map<Id, List<Contact>>();
        Map<Id, String> accConNameMap       = new Map<Id, String>();
        List<Contact> conList               = new List<Contact>();
        List<Contact> tempConList           = new List<Contact>();

        for( Contact con : changedContactList ){

            accIdList.add( con.AccountId );
        }

        List<Account> accList = [ SELECT Id, name, Contact_Associated__c, ( SELECT AccountId, Id, FirstName FROM Contacts ) FROM Account WHERE Id IN :accIdList WITH SECURITY_ENFORCED ];

        if( accList.size() > 0 ){

            for( Account acc : accList ){
                
                if( acc.contacts.size() > 0 ){

                    conList.addAll( acc.contacts );
                    tempConList.addAll( acc.contacts );
                }
                accConMap.put( acc.Id, tempConList );
                tempConList.clear();
            }
        }

        system.debug( 'accConMap : '+accConMap );

        if( accConMap != null ){

            for( Contact con : conList ){

                if( !accConNameMap.containsKey( con.AccountId ) ){
                    
                    String nameString = con.firstName;
                    accConNameMap.put( con.AccountId, nameString );
                }
                else {

                    String nameString = accConNameMap.get( con.AccountId );
                    nameString += ',' + con.firstName;
                    accConNameMap.put( con.AccountId, nameString );
                }
            }
        }

        for( Account accId : accList ){

            accId.Contact_Associated__c = accConNameMap.get(accId.Id);
        }
        update accList;
    }

    //Get all contact name with removing data from Contact_Associated__c; INSERT

    public static void addContactNameOnAcccountInsertSOQL ( List<Contact> newList ){

        List<Contact> changedContactList    = new List<Contact>();
        List<Id> accIdList                  = new List<Id>();
        Map<Id, List<Contact>> accConMap    = new Map<Id, List<Contact>>();
        Map<Id, String> accConNameMap       = new Map<Id, String>();
        List<Contact> conList               = new List<Contact>();
        List<Contact> tempConList           = new List<Contact>();

        if( newList != null ){

            for( Contact con : newList ){

                if( con.FirstName != null ){

                    changedContactList.add( con );
                }
            }
        }

        if( changedContactList.size() > 0 ){

            for( Contact con : changedContactList ){

                accIdList.add( con.AccountId );
            }
        }

        List<Account> accList = [ SELECT Id, name, Contact_Associated__c, ( SELECT AccountId, Id, FirstName FROM Contacts ) FROM Account WHERE Id IN :accIdList WITH SECURITY_ENFORCED ];

        if( accList.size() > 0 ){

            for( Account acc : accList ){
                
                if( acc.contacts.size() > 0 ){

                    conList.addAll( acc.contacts );
                    tempConList.addAll( acc.contacts );
                }
                accConMap.put( acc.Id, tempConList );
                tempConList.clear();
            }
        }

        system.debug( 'accConMap : '+accConMap );

        if( accConMap != null ){

            for( Contact con : conList ){

                if( !accConNameMap.containsKey( con.AccountId ) ){
                    
                    String nameString = con.firstName;
                    accConNameMap.put( con.AccountId, nameString );
                }
                else {

                    String nameString = accConNameMap.get( con.AccountId );
                    nameString += ',' + con.firstName;
                    accConNameMap.put( con.AccountId, nameString );
                }
            }
        }

        for( Account accId : accList ){

            accId.Contact_Associated__c = accConNameMap.get(accId.Id);
        }
        update accList;
    }

    public static void contactRollUpAggUpdateInsertUndelete( List<Contact> newList ){

        Set<Id> accIds = new Set<Id>();
        Map<Id, Integer> accConMap = new Map<Id, Integer>();

        if( newList != null ){

            for( Contact con : newList ){

                if( con.AccountId != null ){

                    accIds.add( con.AccountId );
                }
            }
        }

        AggregateResult[] aggRe = [ SELECT count(Id) cnt, AccountId FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId ];

        if( aggRe.size() > 0 ){

            for( AggregateResult agg :  aggRe ){

                accConMap.put( (Id)agg.get('AccountId'), (Integer)agg.get('cnt') );
            }
        }

        List<Account> accList = [ SELECT Id, Contact_Count__c FROM Account WHERE Id IN :accConMap.keyset() ];

        if( accList.size() > 0 ){

            for( Account acc : accList ){

                acc.Contact_Count__c = accConMap.get( acc.Id );
            }
        }

        update accList;
    }


    public static void contactRollUpAggDelete( List<Contact> oldList ){

        Set<Id> accIds = new Set<Id>();
        Map<Id, Integer> accConMap = new Map<Id, Integer>();

        if( oldList != null ){

            for( Contact con : oldList ){

                if( con.AccountId != null ){

                    accIds.add( con.AccountId );
                }
            }
        }

        AggregateResult[] aggRe = [ SELECT count(Id) cnt, AccountId FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId ];

        if( aggRe.size() > 0 ){

            for( AggregateResult agg :  aggRe ){

                accConMap.put( (Id)agg.get('AccountId'), (Integer)agg.get('cnt') );
            }
        }

        List<Account> accList = [ SELECT Id, Contact_Count__c FROM Account WHERE Id IN :accConMap.keyset() ];

        if( accList.size() > 0 ){

            for( Account acc : accList ){

                acc.Contact_Count__c = accConMap.get( acc.Id );
            }
        }

        update accList;
    }



    public static void contactAmountRollUpUpdate ( Map<Id, Contact> oldMap, Map<Id, Contact> newMap ) {

        List<Contact> changedContactList = fieldHasChanged( oldMap, newMap, 'Amount__c');

        Set<Id> accIds = new Set<Id>();
        Map<Id, Decimal> accAmountMap = new Map<Id, Decimal>();

        if( changedContactList.size() > 0 ){

            for ( contact con : changedContactList ){

                if ( con.AccountId != null ){

                    accIds.add( con.AccountId );
                }
            }
        }
        else{

            return;
        }

        AggregateResult[] aggreAcc = [ SELECT SUM(Amount__c), AccountId FROM contact WHERE AccountId IN :accIds GROUP BY AccountId ];

        for( AggregateResult agg : aggreAcc ){

           accAmountMap.put( (Id)agg.get('AccountId'), (Decimal)agg.get('expr0') ); 
        }

        List<Account> accList = [ SELECT Id, Contact_Amount__c  FROM Account WHERE ID In :accAmountMap.keyset() ];

        for( Account a : accList ){

            a.Contact_Amount__c = accAmountMap.get( a.Id );
        }

        update accList;
    }

    public static void contactAmountRollUpInsert( Map<Id, Contact> newMap ){

        List<Id> accIds                 = new List<Id>();
        Map<Id, Decimal> accAmountMap   = new Map<Id, Decimal>();

        if( newMap != null ){

            for ( contact con : newMap.values() ){

                if( con.AccountId != null && con.Amount__c != null ){

                    accIds.add( con.AccountId );
                }
            }
        }

        if( accIds.size() == 0 ){

            return;
        }

        AggregateResult[] aggreAcc = [ SELECT SUM(Amount__c), AccountId FROM contact WHERE AccountId IN :accIds GROUP BY AccountId ];

        for( AggregateResult agg : aggreAcc ){

           accAmountMap.put( (Id)agg.get('AccountId'), (Decimal)agg.get('expr0') ); 
        }

        List<Account> accList = [ SELECT Id, Contact_Amount__c  FROM Account WHERE ID In :accAmountMap.keyset() ];

        for( Account a : accList ){

            a.Contact_Amount__c = accAmountMap.get( a.Id );
        }

        update accList;
    }

    private static List<sObject> fieldHasChanged( Map<Id, sObject> oldMap, Map<Id, sObject> newMap, String fieldName  ){

        List<sObject> changedObjectList = new List<sObject>();

        // Schema.SObjectType schemaObject         = Schema.getGlobalDescribe().get(objectName) ;
        // Schema.DescribeSObjectResult r          = schemaObject.getDescribe() ;
        // Map<String,Schema.SObjectField> fields  = r.fields.getMap() ;
        // Schema.DescribeFieldResult fieldResult  = fields.get(fieldName).getDescribe();

        for( sObject s : newMap.values() ){

            if( oldMap.get(s.Id).get( fieldName ) != newMap.get(s.Id).get( fieldName ) ){

                changedObjectList.add( s );
            }
        }
        return changedObjectList;
    }

    private static List<String> removeConName( String conName, List<String> originalList ){

        system.debug('conName :' +conName);
        System.debug('originalList : '+originalList);

        Integer removeIndex = originalList.indexOf( conName );
        originalList.remove( removeIndex );

        return originalList;
    }
}
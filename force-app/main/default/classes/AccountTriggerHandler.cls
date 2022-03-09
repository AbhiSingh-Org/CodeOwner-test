public with sharing class AccountTriggerHandler {
    
    public static void accountHierarchyRoll( List<Account> newList ){

        if ( newList == null ){

            return;
        }

        Set<Id> accId = new Set<Id>();

        for( Account acc: newList ){

            accId.add( acc.Id );
        }

    }

    public static void recursiveAccountRollUp( Id accSingle ){

        Decimal amount = 0;

        Account childAndCurrentAccounts = [ SELECT Id, name, amount__c, ( SELECT Id, Amount__c FROM childaccounts ) FROM Account WHERE Id = :accSingle ];
        // Account cloneAccount        = [ SELECT Id, name, amount__c, parentId FROM Account WHERE Id = :accSingle ];

        if(childAndCurrentAccounts.amount__c == null ){

            childAndCurrentAccounts.amount__c = 0;
        }

        System.debug('childAndCurrentAccounts: '+childAndCurrentAccounts);

        if( childAndCurrentAccounts.childaccounts.size() > 0 ){

            for( Account a : childAndCurrentAccounts.childaccounts ){

                amount += a.Amount__c;
            }
        }
        else amount = childAndCurrentAccounts.amount__c;

        childAndCurrentAccounts.amount__c = amount;        
        update childAndCurrentAccounts;

        Account parentAccount = [ SELECT Id, name, amount__c, parentId FROM Account WHERE Id = :accSingle ];

        system.debug('parentAccount : '+parentAccount.parentId);

        if( parentAccount.parentId == null ){

            System.debug('Null');
            return;
        }       
        else {

            System.debug('parentAccount: '+parentAccount);
            recursiveAccountRollUp( parentAccount.parentId );
        }
    }
}
trigger AccountTrigger on account (after insert) {

    for( Account a : Trigger.new ){

        AccountTriggerHandler.recursiveAccountRollUp( a.Id );
    }
}
trigger AccountTrigger on account (after insert) {

    for( Account a : Trigger.new ){

        //test
        AccountTriggerHandler.recursiveAccountRollUp( a.Id );
    }
}
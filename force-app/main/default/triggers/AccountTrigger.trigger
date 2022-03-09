trigger AccountTrigger on account (after insert) {

    for( Account a : Trigger.new ){

        //lets test codeowner
        AccountTriggerHandler.recursiveAccountRollUp( a.Id );
    }
}
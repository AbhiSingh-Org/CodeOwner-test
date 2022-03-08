public with sharing class ReversalClass {
    
    // Execute Anonymous
    // List<String> alphabet = new list<String> { 'a' , 'b' , 'c' };
    // ReverseStringClass testReverse = new ReverseStringClass();
    // testReverse.reverseList(alphabet);

    public void reverseList( List<String> originalList ){

        List<String> reverseList = new List<String>();

        Integer length = originalList.size();

        for( Integer i = length-1; i >= 0; i-- ){

            reverseList.add(originalList[i]);
        }

        if ( reverseList.size() > 0 ){

            system.debug( 'Reverse of list: ' +reverseList );
        }
    }
}
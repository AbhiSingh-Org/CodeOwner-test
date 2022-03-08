public with sharing class ListSort{

    public static void sortList( List<Integer> charList, Integer n ){

        if( n < 1 ){

            System.debug('sortList: '+charList);
            return;
        }        
        else{           
            Integer last = charList[n-1];
        	Integer y = n-2;

        	while( y >=0 && charList[y] > last ){

            	charList[y+1] = charList[y];
            	y--;
            
            	system.debug('in while:' + charList[y+1]);
        	}
        
        	charList[y+1] = last; 
        
            sortList( charList, n-1 );
        }
    }

    public static void checkAnagram( String firstString, String secondString ){

        List<String> firstList = firstString.split('');
        List<String> secondList = secondString.split('');

        Integer firstStringLength = firstList.size();
        Integer secondStringLength = secondList.size();
        Integer looptemp = 0;

        if ( firstStringLength != secondStringLength ){

            system.debug('Not Anagram');
        }

        for( String s : firstList )  {

            if( secondList.contains(s) ){

                looptemp++ ;
            } 
        }

        System.debug('looptemp' +looptemp);

        if( firstStringLength == looptemp ){

            system.debug('Anagram');
        }
    } 

    public static void checkPalindrome( String paliString ){

        List<String> paliList = paliString.split('');
        System.debug( 'paliString : ' +paliString );
        List<String> reversePaliList = listReverse( paliList, paliList.size(), 0 );

        System.debug( 'reversePaliList : ' +reversePaliList );

        String reverseString = String.join( reversePaliList, '' );

        if( paliString ==  reverseString ){

            system.debug( 'Palindrome' );
        }
        else System.debug( 'Not Palindrome' );
    }

    private static List<String> listReverse( List<String> reverseString, Integer n, Integer fromWhere ){

        if( n < 1 ){

            system.debug('reverseStringRecur '+reverseString );
            return reverseString;
        }

        Integer i = n - 1;
        String last = reverseString[ fromWhere ]; 
        String tempString = '';      

        tempString = reverseString[ fromWhere ];
        reverseString[ fromWhere ] = reverseString[i];
        reverseString[ i ] = tempString;

        system.debug('tempString' +tempString);
        system.debug('y ' +reverseString[fromWhere]);
        system.debug('i ' +reverseString[i]);

        listReverse(reverseString, i-1, fromWhere--);

        system.debug( 'return : '+reverseString );

        return reverseString;
    }
}
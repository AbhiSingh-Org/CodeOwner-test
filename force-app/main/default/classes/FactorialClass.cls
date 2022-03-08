public with sharing class FactorialClass {

    Integer factor = 1;
    
    public void fact( integer n ){

        if ( n == 0 ){

            system.debug( 'help :' +factor );
        }

        else if (n > 0){
            
            factor = factor * n;
            fact( n-1 );
        }
    }
}
@IsTest
public class TestAccountTriggerHandler {
    
    @TestSetup
    static void makeData(){
        List <Loyalty_Program__c> lpList = new List<Loyalty_Program__c>();
        Loyalty_Program__c lp =new Loyalty_Program__c (Name = 'BRONZE',
                                                       Loyalty_Sum__c=10000); 
        lpList.add(lp);
        Loyalty_Program__c lpNone =new Loyalty_Program__c (Name = 'NONE',
                                                           Loyalty_Sum__c=0);
        lpList.add(lpNone);
        
        insert lpList;
        
        Account acc = new Account(
            Name = 'Test'
        );
        insert acc;
    }
    
    @IsTest
    static void testUpdateAccountLoyaltyProgram(){
        List<Account> accountsBefore = [SELECT Id, Name, Annual_Revenue_Spend__c, Loyalty_Program__c
                                        FROM Account
                                        WHERE Name = 'Test'
                                        LIMIT 1];
        
        System.assertEquals('NONE', accountsBefore.get(0).Loyalty_Program__c);
        
        Test.startTest();
        Opportunity opp1 = new Opportunity(Name = 'TestOpp1', CloseDate = System.today(), Amount = 10000, StageName = 'Closed Won', AccountId = accountsBefore.get(0).Id);
        insert opp1;
        Test.stopTest();
        
        List<Account> accountsAfter = [SELECT Id, Name, Annual_Revenue_Spend__c, Loyalty_Program__c
                                       FROM Account
                                       WHERE Name = 'Test'
                                       LIMIT 1];
        
        System.assertNotEquals('NONE', accountsAfter.get(0).Loyalty_Program__c);
    }
}
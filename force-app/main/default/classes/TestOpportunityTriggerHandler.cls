@IsTest
public class TestOpportunityTriggerHandler {
    
    @TestSetup
    static void makeData(){
        List <Loyalty_Program__c> lpList = new List<Loyalty_Program__c>();
        Loyalty_Program__c lp =new Loyalty_Program__c (Name = 'GOLD',
                                                       Loyalty_Sum__c=50000); 
        lpList.add(lp);
        Loyalty_Program__c lpNone =new Loyalty_Program__c (Name = 'NONE',
                                                           Loyalty_Sum__c=0);
        lpList.add(lpNone);
        
        insert lpList;
        
        Account acc = new Account(
            Name = 'Test',
            Loyalty_Program__c = 'GOLD'
        );
        insert acc;
        Opportunity opp1 = new Opportunity(Name = 'TestOpp1', CloseDate = System.today(), Amount = 100000, StageName = 'Closed Won', AccountId = acc.Id);
        insert opp1;
        Opportunity opp2 = new Opportunity(Name = 'TestOpp2', CloseDate = System.today(), Amount = 100000, StageName = 'Prospecting', AccountId = acc.Id);
        insert opp2;
    }
    
    @IsTest
    static void testHandleClosedOpportunities(){
        
        List<Account> accountsBefore = [SELECT Id, Name, Annual_Revenue_Spend__c, Loyalty_Program__c
                                        FROM Account
                                        WHERE Name = 'Test'
                                        LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new MockTwilio());
        
        Test.startTest();
        Opportunity opp = new Opportunity(Name = 'TestOpp', CloseDate = System.today(), Amount = 100000, StageName = 'Closed Won', AccountId = accountsBefore.get(0).Id);
        insert opp;
        Test.stopTest();
    }
    
    @IsTest
    static void testUpdateHandleClosedOpportunities(){
        
        List<Account> accountsBefore = [SELECT Id, Name, Annual_Revenue_Spend__c, Loyalty_Program__c
                                        FROM Account
                                        WHERE Name = 'Test'
                                        LIMIT 1];
        
        List<Opportunity> opportunitiesBefore = [SELECT Id, Name, StageName FROM Opportunity WHERE StageName != 'Closed Won' AND AccountId =: accountsBefore.get(0).Id];
        
        Test.setMock(HttpCalloutMock.class, new MockTwilio());
        
        Test.startTest();
        opportunitiesBefore.get(0).StageName = 'Closed Won';
        update opportunitiesBefore;
        Test.stopTest();
    }
}
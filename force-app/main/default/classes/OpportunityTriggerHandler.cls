public with sharing class OpportunityTriggerHandler{
    public static void afterInsert(List<Opportunity> newOpportunities){
        handleClosedOpportunities(newOpportunities);
    }
    
    public static void afterUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities){
        handleClosedOpportunities(newOpportunities);
    }
    
    public static void handleClosedOpportunities(List<Opportunity> opportunities){
        
        Set<id> accIds = new Set<id>();
        for (Opportunity o : opportunities){
            if (o.AccountId != null){
                accIds.add(o.AccountId);
            }
        }
        
        
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT id, Name, Loyalty_Program__c
                                                        FROM Account
                                                        WHERE Id IN :accIds]);
        
        for (Opportunity opp : opportunities){
            if (opp.AccountId != null){
                System.debug(accMap.get(opp.AccountId).Loyalty_Program__c);
                if (opp.StageName == 'Closed Won' && accMap.get(opp.AccountId).Loyalty_Program__c == 'GOLD'){
                    NotificationService.notificateRoleAboutOppStage(opp, 'CEO');
                }
            }
        }
    }
}
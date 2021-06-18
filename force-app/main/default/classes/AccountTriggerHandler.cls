public class AccountTriggerHandler{
	public static void beforeInsert(List<Account> newAccounts){
		updateAccountLoyaltyProgram(newAccounts);
	}

	public static void beforeUpdate(List<Account> newAccounts, Map<Id, Account> oldAccounts){
		updateAccountLoyaltyProgram(newAccounts);
	}

	private static void updateAccountLoyaltyProgram(List<Account> accounts){
		for (Account acc : accounts){
			Loyalty_Program__c tempLP = Loyalty_Program__c.getValues('NONE');
			for (Loyalty_Program__c loyaltyProgram : Loyalty_Program__c.getall().values()){
				if (acc.Annual_Revenue_Spend__c >= loyaltyProgram.Loyalty_Sum__c && tempLP.Loyalty_Sum__c <= loyaltyProgram.Loyalty_Sum__c){
					tempLP = loyaltyProgram;
				}
				acc.Loyalty_Program__c = tempLP.Name;
			}
		}
	}
}
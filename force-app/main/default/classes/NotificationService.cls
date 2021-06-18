public with sharing class NotificationService{
    public static void notificateRoleAboutOppStage(Opportunity opp, String role){
        List<User> users = [SELECT Id, Name, Phone
                            FROM User
                            where UserRole.Name = :role];
        System.debug('notificateRoleAboutOppStage');
        
        for (User u : users){
            String body = 'Hi, ' + u.Name + '! ' + opp.Name + ' moved to ' + opp.StageName + ' stage.';
            TwilioService.sendSms(TwilioService.getTwilioNumber(), body, u.Phone);
        }
    }
}
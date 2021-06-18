public with sharing class TwilioService{
	@future(callout = true)
	public static void sendSms(String fromNumber, String smsBody, String toNumber){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:Twilio_Credentials/' + 'SMS/Messages.json');
		req.setMethod('POST');
		String VERSION = '3.2.0';
		req.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
		req.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
		req.setHeader('Accept', 'application/json');

		req.setHeader('Accept-Charset', 'utf-8');
		req.setBody('To=' + EncodingUtil.urlEncode(toNumber, 'UTF-8')+'&From=' + EncodingUtil.urlEncode(fromNumber, 'UTF-8')+'&Body=' + smsBody);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		if (res.getStatusCode() == 201)
			System.Debug('Message sending Successful');
		else{
			System.Debug('Message sending Unsuccessful');
		}
	}

	public static String getTwilioNumber(){
		return [SELECT Id, Name, Phone
		        FROM User
		        where Name = 'Service Twilio'
		        LIMIT 1].Phone;
	}
}
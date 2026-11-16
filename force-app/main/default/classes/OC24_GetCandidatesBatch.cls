public class OC24_GetCandidatesBatch implements Database.Batchable<OC24_RestResponseCollection.Candidate>,Database.AllowsCallouts, Database.Stateful{
    
    public OC24_API_Setting__mdt oc24Settings;
	public List<Id> successfulCandidateIds;	
    public Boolean hasMoreData;
    
    public Iterable<OC24_RestResponseCollection.Candidate> start(Database.BatchableContext context)
    {   
                
        OC24_API_Setting__mdt apiSettings = [SELECT Endpoint__c
                                             FROM OC24_API_Setting__mdt
                                             WHERE DeveloperName =: OC24_Constants.GENERIC_DEFAULT];
        hasMoreData = false;
        successfulCandidateIds = new List<Id>(); 
        oc24Settings = apiSettings;
      	String paramString;
        //Add the LIMIT = 200 Parameter
        paramString = OC24_Constants.INTEGRATION_OC24_LIMIT + OC24_Constants.INTEGRATION_OC24_LIMIT_200;
    
        
        system.debug(oc24Settings.Endpoint__c + OC24_Constants.INTEGRATION_OC24_ENDPOINT_RESULTS + '?' + OC24_Constants.INTEGRATION_OC24_LIMIT + OC24_Constants.INTEGRATION_OC24_LIMIT_200);
        //Set Header
        Map<String , String> requestHeader = OC24_Utilities.ConstructRequestHeaders();
        
        HttpResponse getResponse = RestHandler.ExecuteRequest(requestHeader, oc24Settings.Endpoint__c + OC24_Constants.INTEGRATION_OC24_ENDPOINT_RESULTS + '?' + paramString, null, OC24_CONSTANTS.INTEGRATION_REST_METHOD_GET);      
		
        String getResponseBodyString = getResponse?.getBody();   
        System.debug('Response'+getResponseBodyString);
        
        OC24_Utilities.CreateRequestResponseLog(OC24_CONSTANTS.INTEGRATION_REST_METHOD_GET, 
                                                null, 
                                                getResponse?.getBody(), 
                                                getResponse?.getStatusCode(), 
                                                OC24_CONSTANTS.INTEGRATION_OC24_MONGODB);
        
        
        if(!OC24_Utilities.CheckResponseBodyValidity(getResponse?.getStatusCode() , getResponseBodyString)){
            return new List<OC24_RestResponseCollection.Candidate>();
        }

        
       
        
        OC24_RestResponseCollection.OC24CandidateResponseBody oc24Candidate = (OC24_RestResponseCollection.OC24CandidateResponseBody)JSON.deserialize(getResponseBodyString, OC24_RestResponseCollection.OC24CandidateResponseBody.class);
        List<OC24_RestResponseCollection.Candidate> oc24CandidateItems = new List<OC24_RestResponseCollection.Candidate>();
        system.debug('oc24Candidate: ' + oc24Candidate);
        
        if(oc24CandidateItems == NULL){
            return new List<OC24_RestResponseCollection.Candidate>();
            
        }else if(!oc24Candidate.records?.isEmpty()){
            
            hasMoreData = oc24Candidate.more;
            oc24CandidateItems =  oc24Candidate.records;        
        }else{
            return new List<OC24_RestResponseCollection.Candidate>();
        }
   
        return oc24CandidateItems;    
    }
    
    
    public void execute(Database.BatchableContext context, List<OC24_RestResponseCollection.Candidate> oc24CandidateItems){
        
        List<Candidate__c> candidatesForUpsert = new List<Candidate__c>();
        
        if(oc24CandidateItems != NULL && !oc24CandidateItems.isEmpty()){
            
            for(OC24_RestResponseCollection.Candidate candidate : oc24CandidateItems) {
                
                candidatesForUpsert.add(OC24_RestService.setCandidateRecord(candidate));
                
            }
            
            List<Exception_Log__c> logsToInsert = new List<Exception_Log__c>();
         
            
            //Partial commit allowing failed records to capture
            //Use External Id MongoDB for upsert
            List<Id> successfulRecordIds = new List<Id>();
            Database.UpsertResult[] results = Database.upsert(candidatesForUpsert, Candidate__c.Fields.MongoDB_Id__c, false);
            
            system.debug('results: ' + results);
            
            for (Integer i = 0; i < results.size(); i++) {
                if (results[i].isSuccess()) {
                    successfulRecordIds.add(results[i].getId());
                } else {
                    
                    for (Database.Error err : results[i].getErrors()) {
                      
                        // Log the error
                        logsToInsert.add(OC24_Utilities.CreateExceptionLog(new DmlException(err.getMessage()), false));
                    }
                }
            }
            
            if(logsToInsert.size() > 0){
                insert logsToInsert;
            }
            
            //Store the Successful Ids for Confirmation API
            successfulCandidateIds = successfulRecordIds;
            
            
        }
        
    }
    
    public void finish(Database.BatchableContext context) {
        
         //POST API Callout to confirm candidate records    
        if(!successfulCandidateIds.IsEmpty()){
            
            List<String> refs = new List<String>();
            for(Candidate__c candidate : [SELECT Id, MongoDB_Id__c FROM Candidate__c WHERE Id IN : successfulCandidateIds]){
                refs.add(candidate.MongoDB_Id__c);
            }
            
            
            String requestBodyString = '';
            OC24_RestRequestCollection.CandidateRequestBody requestBody = OC24_RestService.setPostCandidateBody(refs);
            requestBodyString = JSON.serialize(requestBody);
            system.debug('requestBodyString: ' + requestBodyString);
            system.debug('requestBodyString: ' + oc24Settings.Endpoint__c  + OC24_Constants.INTEGRATION_OC24_ENDPOINT_CONFIRM);
            Map<String, String> requestHeader = OC24_Utilities.ConstructRequestHeaders();
            //Do the POST  
            HttpResponse getResponse = RestHandler.ExecuteRequest(requestHeader, oc24Settings.Endpoint__c + OC24_Constants.INTEGRATION_OC24_ENDPOINT_CONFIRM, requestBodyString, OC24_CONSTANTS.INTEGRATION_REST_METHOD_POST);      
            system.debug(getResponse);
            //Log the Response Result
            OC24_Utilities.CreateRequestResponseLog(OC24_CONSTANTS.INTEGRATION_REST_METHOD_POST, 
                                                    requestBodyString, 
                                                    getResponse?.getBody(), 
                                                    getResponse?.getStatusCode(), 
                                                    OC24_CONSTANTS.INTEGRATION_OC24_MONGODB);
            
            
            //if response has more data, rerun the batch after the POST Confirm
            if(getResponse?.getStatusCode() == 200 && hasMoreData){
                 
                Database.executeBatch(new OC24_GetCandidatesBatch(), 200);
                
            }
            
        }
        
       	
        //Capture last sync datetime
        OC24ProcessingSettings__c OC24ProcessingSettings = OC24ProcessingSettings__c.getOrgDefaults();
        if(OC24ProcessingSettings != NULL)
        {
            OC24ProcessingSettings.Candidate_Sync_DateTime__c = System.now();
            Database.Update(OC24ProcessingSettings);
        }
        
    }

}
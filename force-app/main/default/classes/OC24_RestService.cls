public class OC24_RestService {
    
  
    public static Candidate__c setCandidateRecord(OC24_RestResponseCollection.Candidate item){
        
        Candidate__c candidate = new Candidate__c();
        
        candidate.AI_Comments__c = item.ai_comments;
        candidate.Call_Count__c = item.call_count;
        candidate.Car_Access__c = item.car_access;
        candidate.Care_Experience_Months__c = item.care_experience_months;
        candidate.Driving_Licence__c = item.driving_licence;
        candidate.Email__c = item.email;
        candidate.First_Name__c = item.first_name;
		candidate.Interested__c = item.interested;
        candidate.Job_Title__c = item.job_title;
        candidate.Last_Call_At__c = item.last_call_at;
        candidate.Last_Name__c = item.last_name;
        candidate.Mobile__c = item.mobile;
        candidate.MongoDB_Id__c = item.ref;
        candidate.Outcome__c = item.outcome;
        candidate.Postcode__c = item.postcode;
        candidate.Right_To_Work__c = item.right_to_work;
        candidate.Salesforce_Contact_Id__c = item.salesforce_contact_id;
        candidate.Shift_Pattern__c = item.shift_pattern;
        candidate.Shifts_Per_Week__c = item.shifts_per_week;
        candidate.Status__c = item.status;
        candidate.Travel_Distance__c = item.travel_distance;
        candidate.Updated_At__c = item.updated_at;
        candidate.Visa_Valid__c = item.visa_valid;
       
        return candidate;
        
        
        
    }
    
    
    public static OC24_RestRequestCollection.CandidateRequestBody setPostCandidateBody(List<String> refs){
        
        OC24_RestRequestCollection.CandidateRequestBody requestBody = new OC24_RestRequestCollection.CandidateRequestBody();
        requestBody.refs = refs;
        
        return requestBody;
        
        
        
    }
    
}
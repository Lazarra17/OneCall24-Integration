public class OC24_RestResponseCollection {
    
    public class OC24CandidateResponseBody {
        
        public Integer count;
        public Boolean more;
        public List<Candidate> records;
    }
    
    public class Candidate{
        public String ref;
        public String salesforce_contact_id;
        public String first_name;
        public String last_name;
        public String mobile;
        public String email;
        public String status;
        public String outcome;
        public String interested;
        public String right_to_work;
        public String visa_valid;
        public String ai_comments;
        public Integer care_experience_months;
        public String job_title;
        public String shift_pattern;
        public Integer shifts_per_week;
        public String postcode;
        public String travel_distance;
        public String driving_licence;
        public String car_access;
        public Integer call_count;
        public Datetime last_call_at;
        public Datetime updated_at;
    }
    
}
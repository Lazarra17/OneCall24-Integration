public class OC24_Utilities {
    
    public static void CreateExceptionLog(Exception error)
    {
        Exception_Log__c newException = new Exception_Log__c();
        newException.StackTrace__c = error.getStackTraceString().abbreviate(OC24_Constants.EXCEPTION_LOG_STACK_TRACE_FIELD_LIMIT);
        newException.ExceptionMessage__c = error.getMessage().abbreviate(OC24_Constants.EXCEPTION_LOG_EXCEPTION_LOG_FIELD_LIMIT);
        
        Database.insert(newException);
    }
     
    public static Exception_Log__c CreateExceptionLog(Exception error, Boolean isCreate)
    {
        Exception_Log__c newException = new Exception_Log__c();
        newException.StackTrace__c = error.getStackTraceString().abbreviate(OC24_Constants.EXCEPTION_LOG_STACK_TRACE_FIELD_LIMIT);
        newException.ExceptionMessage__c = error.getMessage().abbreviate(OC24_Constants.EXCEPTION_LOG_EXCEPTION_LOG_FIELD_LIMIT);
        
        if(isCreate){
            insert newException;
        }
        return newException;
    }
    
    
      public static void CreateRequestResponseLog(String method, String requestBody, String responseBody, Integer statusCode, String integName)
    {
        Integration_Log__c responseRequestLog = new Integration_Log__c();
        responseRequestLog.Name__c = integName.abbreviate(80);
        responseRequestLog.Method__c = method;
        responseRequestLog.Request_String__c = requestBody?.abbreviate(OC24_CONSTANTS.EXCEPTION_LOG_EXCEPTION_LOG_FIELD_LIMIT);
        responseRequestLog.Response_String__c = responseBody?.abbreviate(OC24_CONSTANTS.EXCEPTION_LOG_EXCEPTION_LOG_FIELD_LIMIT);
        responseRequestLog.Status_Code__c = statusCode;
        Database.insert(responseRequestLog);
    }
    
    public static Boolean CheckResponseBodyValidity(Integer responseStatusCode , String responseBodyString)
    {
        Boolean isValid;
        
        if(responseStatusCode == NULL || responseStatusCode != OC24_Constants.INTEGRATION_REST_RESPONSE_200)
        {
            isValid = FALSE;
            return isValid;
        }
        
        if(responseBodyString == NULL || String.IsBlank(responseBodyString))
        {
            isValid = FALSE;
            return isValid;
        }
        
        isValid = TRUE;
        return isValid;
    }
    
    public static Map<String , String> ConstructRequestHeaders()
    {
        return new Map<String , String>{
            OC24_CONSTANTS.INTEGRATION_MYOB_HEADER_KEY_ACCEPT => OC24_CONSTANTS.INTEGRATION_VALUE_CONTENT_TYPE_APPJSON, 
            OC24_CONSTANTS.INTEGRATION_KEY_CONTENT_TYPE => OC24_CONSTANTS.INTEGRATION_VALUE_CONTENT_TYPE_APPJSON};
    }

}
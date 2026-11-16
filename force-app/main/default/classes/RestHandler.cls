public class RestHandler 
{
	private static HttpRequest Request;
    
    public void SetRequest(Map<String , String> requestHeaders , String requestEndpoint , String requestBody , String methodName)
    {
        Request = new HttpRequest();
        
        Request.setEndpoint(requestEndpoint);
        Request.setMethod(methodName);
        
        if(requestHeaders != null)
        {
            for(String requestKey : requestHeaders.keySet())
            {
                String requestValue = requestHeaders.get(requestKey);
                Request.setHeader(requestKey, requestValue);
            }
        }
        
        if(requestBody != null) Request.setBody(requestBody);
    }
    
    public HttpResponse SendRequest()
    {
        HttpResponse requestResponse;
        
        if(Request != null)
        {
            try
            {
                Http httpObject = new Http();
                Request.setTimeout(120000);
                requestResponse = httpObject.send(Request);
               
                
            }
            catch(Exception err)
            {
                OC24_Utilities.CreateExceptionLog(err);
            }
        }
        else
        {
            ExceptionCollection.GenericException error = new ExceptionCollection.GenericException(OC24_Constants.ERROR_REQUEST_NOT_SET);
            Throw error;
        }
        
        return requestResponse;
    } 
     
    public static HttpResponse ExecuteRequest(Map<String , String> requestHeader , String requestEndpoint , String requestBody, String restMethod)
    {
        RestHandler handler = new RestHandler();
        handler.setRequest(requestHeader, requestEndpoint, requestBody, restMethod);
        return handler.SendRequest();
    }
    
    public class ExceptionLogWrapper{
        public string statusCode;
        public string responseBody;
        public string requestEndpoint;
        public string requestBody;
    }
}
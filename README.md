# OC24 Salesforce & MongoDB Integration

This integration synchronizes candidate data from OneCall24 (MongoDB API) into Salesforce and confirms successful processing back to the API.

---

## How to Run

### Via Scheduled Job

1. Go to **Setup → Apex Classes → Schedule Apex**.
2. Populate the following fields:

| Field | Value |
|---------|---------|
| Job Name | OC24_GetCandidatesScheduler |
| Apex Class | OC24_GetCandidatesScheduler |
| Frequency | Weekly (Every Day) |
| Start Date | 16/11/2026 |
| End Date | 16/12/2026 |
| Preferred Start Time | 2:00 AM |

---

### Via Developer Console

1. Open **Developer Console → Debug → Open Execute Anonymous Window**.
2. Execute the following code:

```apex
Database.executeBatch(new OC24_GetCandidatesBatch(),200);
```

---

## OneCall24 API Reset Feature

### Via Developer Console

1. Open **Developer Console → Debug → Open Execute Anonymous Window**.
2. Execute the following code:

```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:OC24_Connector/reset');
req.setMethod('POST');

Http http = new Http();
HttpResponse res = http.send(req);

System.debug(res.getBody());
```


---

# Custom Objects & Configuration

## 1. Candidate__c

| Field Name | Data Type |
|------------|-----------|
| AI_Comments__c | Long Text Area (32768) |
| Call_Count__c | Number(5,0) |
| Car_Access__c | Picklist |
| Care_Experience_Months__c | Number(5,0) |
| Driving_Licence__c | Picklist |
| Email__c | Email |
| First_Name__c | Text(255) |
| Interested__c | Picklist |
| Job_Title__c | Text(255) |
| Last_Call_At__c | Date/Time |
| Last_Name__c | Text(255) |
| Mobile__c | Phone |
| MongoDB_Id__c | Text(255) **(External ID)** |
| Outcome__c | Text(255) |
| Postcode__c | Text(20) |
| Right_To_Work__c | Text(255) |
| Salesforce_Contact_Id__c | Text(255) |
| Shift_Pattern__c | Text(255) |
| Shifts_Per_Week__c | Number(3,0) |
| Status__c | Picklist |
| Travel_Distance__c | Text(50) |
| Updated_At__c | Date/Time |
| Visa_Valid__c | Picklist |

---

## 2. Exception_Log__c

| Field Name | Data Type |
|------------|-----------|
| ExceptionMessage__c | Long Text Area (32768) |
| StackTrace__c | Text(255) |

---

## 3. Integration_Log__c

| Field Name | Data Type |
|------------|-----------|
| Method__c | Text(255) |
| Name__c | Text(255) |
| Request_String__c | Long Text Area (131072) |
| Response_String__c | Long Text Area (131072) |
| Status_Code__c | Number(3,0) |

---

## 4. OC24_API_Setting__mdt (Custom Metadata)

| Field Name | Data Type |
|------------|-----------|
| Endpoint__c | Text(255) |

### Example Record

| Field | Value |
|---------|---------|
| Developer Name | Default |
| Endpoint__c | callout:OC24_Connector |

---

## 5. OC24_Processing_Settings__c (Hierarchy Custom Setting)

| Field Name | Data Type |
|------------|-----------|
| Candidate_Sync_DateTime__c | Datetime |

---

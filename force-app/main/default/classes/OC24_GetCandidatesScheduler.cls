global class OC24_GetCandidatesScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new OC24_GetCandidatesBatch(),200);
    }
}
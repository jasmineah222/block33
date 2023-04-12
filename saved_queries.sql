-- getAllRoutinesByUser
SELECT *
FROM routines 
JOIN users ON routines."creatorId" = users.id;
JOIN routine_activities ON routine_activities."routineId" = routines.id
JOIN activities ON routine_activities.activityId = activities.id
WHERE users.id = 1;

-- getPublicRoutinesByActivity
SELECT *
FROM routines
JOIN routine_activities ON routines.id=routine_activities."routineId"
JOIN activities ON activities.id=routine_activities."activityId"
WHERE routines.isPublic=true
AND routine_activities."activityId"=$1;

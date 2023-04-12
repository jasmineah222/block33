# FitnessTrackr API Documentation

## Introduction

Here at FitnessTrackr we strive to provide you with an easy to consume API, so you can build out beautiful front end experiences and leave the Data management to us.

We have a small handful of endpoints, each documented below.

### Authentication through JSON Web Tokens

When using the API, many calls are made in the context of a registered user. The API protects itself by requiring a token string passed in the Header for requests made in that context.

A sample request **with** an authorization token looks like this:

```js
fetch('https://fitnesstrac-kr.herokuapp.com/api/activities', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer TOKEN_STRING_HERE'
  },
  body: JSON.stringify({ /* whatever things you need to send to the API */ })
})
```

It is **crucial** that the value for `Authorization` is a string starting with `Bearer`, followed by a space, and finished with the `token` you receive either by registering or logging in. Deviating from this format will cause the API to not recognize the token, and will result in an error.

If the token is malformed, missing, or has been revoked, you will get a response specific to that.

```js
{
  "error": "You must be logged in to perform this action",
  "name": "MissingUserError",
  "message": "You must be logged in to perform this action"
}
```

### General Return Schema

ERROR
```js
{
  "error": "No activity by ID 10",
  "name": "NotFound",
  "message": "No activity by ID 10"
}
```
SUCCESS (sends back created/updated entity)
```js
{
  "id": 9,
  "name": "Biceps",
  "description": "Yep, it's that day again!"
}
```


## User Endpoints

### `POST /api/users/register`

This route is used to create a new user account. On success, you will be given a JSON Web Token to be passed to the server for requests requiring authentication.

#### Request Parameters

* `username` (`string`, required): the desired username for the new user
* `password` (`string`, required): the desired password for the new user

#### Return Parameters

* `user` (`object`)
  * `id` (`number`): the database identifier of the user
  * `username` (`string`): the username of the user
* `message` (`string`): the success message
* `token` (`string`): the JSON Web Token which is used to authenticate the user with any future calls

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/users/register', {
  method: "POST",
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    username: 'superman27',
    password: 'krypt0n0rbust'
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API creates a new user, the following object will be returned:

```js
{
  "user": {
    "id": 5,
    "username": "superman27"
  },
  "message": "you're signed up!",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcm5hbWUiOiJzdXBlcm1hbjI3MTIiLCJpYXQiOjE2MDE3OTcwNDIsImV4cCI6MTYwMjQwMTg0Mn0.8q2B4oCtL3Dx-fRk_K0YTZaCgzrYXXeCqU6G1AI9JT0"
}
```

### `POST /api/users/login`

This route is used for a user to login when they already have an account. On success, you will be given a JSON Web Token to be passed to the server for requests requiring authentication.

#### Request Parameters

* `username` (`string`, required): the registered username for the user
* `password` (`string`, required): the matching password for the user

#### Return Parameters

* `user` (`object`)
  * `id` (`number`): the database identifier of the user
  * `username` (`string`): the username of the user
* `message` (`string`): the success message
* `token` (`string`): the JSON Web Token which is used to authenticate the user with any future calls

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/users/login', {
  method: "POST",
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    username: 'superman27',
    password: 'krypt0n0rbust'
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API authenticates the username and password, the following object will be returned:

```js
{
  "user": {
    "id": 5,
    "username": "superman27"
  },
  "message": "you're logged in!",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcm5hbWUiOiJzdXBlcm1hbjI3MTIiLCJpYXQiOjE2MDE3OTczNTcsImV4cCI6MTYwMjQwMjE1N30.ZCWu6iI7u-GrchkK0vhxTH3ZD7RV56vJNvc_azBB9C0"
}
```

### `GET /api/users/me`

This route is used to grab an already logged in user's relevant data. It is mostly helpful for verifying the user has a valid token (and is thus logged in). You must pass a valid token with this request, or it will be rejected.

#### Request Parameters

No request parameters are necessary for this route.

#### Return Parameters

* `id` (`number`): the database identifier of the user
* `username` (`string`): the username of the user

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/users/me', {
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer TOKEN_STRING_HERE'
  },
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
{
  "id": 5,
  "username": "superman27"
}
```

### `GET /api/users/:username/routines`

This route returns a list of public routines for a particular user.

#### Request Parameters

There are no request parameters, but **if a token is sent in the Authorization header (and if this token's logged in user matches the user for which these routines are being requested), both public and private routines will be sent back for the requested user**.

#### Return Parameters

(`array` of `object`):
  * `id` (`number`): This is the database identifier for the `routine` object.
  * `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
  * `creatorName` (`string`): This is the username for the `user` which created this `routine`
  * `isPublic` (`boolean`): Whether or not the routine should be visible to all users (will always be true for public routes)
  * `name` (`string`): This is the name (or title) of the routine.
  * `goal` (`string`): This is like the description of the routine.
  * `activity` (`array` of `activity` objects): An array of activities associated with this routine.
    * `id` (`number`): This is the database identifier for the `activity`
    * `name` (`string`): This is the name (or title) of the activity.
    * `description` (`string`): This is the description of the activity.
    * `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.
    * `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
    * `routineActivityId` (`number`): This is the database identifier for the `routine_activity`
    * `routineId` (`number`): This is the database identifier for the `routine`

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/users/albert/routines', {
  headers: {
    'Content-Type': 'application/json',
  },
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
[
    {
        "id": 2,
        "creatorId": 1,
        "isPublic": true,
        "name": "Chest Day",
        "goal": "To beef up the Chest and Triceps!",
        "creatorName": "albert",
        "activities": [
            {
                "id": 3,
                "name": "bench press",
                "description": "3 sets of 10. Lift a safe amount, but push yourself!",
                "duration": 8,
                "count": 10,
                "routineActivityId": 6,
                "routineId": 2
            },
            {
                "id": 4,
                "name": "Push Ups",
                "description": "Pretty sure you know what to do!",
                "duration": 7,
                "count": 10,
                "routineActivityId": 7,
                "routineId": 2
            }
        ]
    }
]
```
 
## Activities Endpoints

### `GET /api/activities`

Just returns a list of all activities in the database

#### Request Parameters

There are no request parameters.

#### Return Parameters

(`array` of `object`):
  * `id` (`number`): This is the database identifier for the `activity`
  * `name` (`string`): This is the name (or title) of the activity.
  * `description` (`string`): This is the description of the activity.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/activities', {
  headers: {
    'Content-Type': 'application/json',
  },
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
[
    {
        "id": 2,
        "name": "Incline Dumbbell Hammer Curl",
        "description": "Lie down face up on an incline bench and lift thee barbells slowly upward toward chest"
    },
    {
        "id": 3,
        "name": "bench press",
        "description": "Lift a safe amount, but push yourself!"
    },
    {
        "id": 4,
        "name": "Push Ups",
        "description": "Pretty sure you know what to do!"
    },
    {
        "id": 5,
        "name": "squats",
        "description": "Heavy lifting."
    },
    {
        "id": 6,
        "name": "treadmill",
        "description": "running"
    },
    {
        "id": 7,
        "name": "stairs",
        "description": "climb those stairs"
    },
    {
        "id": 8,
        "name": "elliptical",
        "description": "using the elliptical machine"
    },
    {
        "id": 1,
        "name": "standing barbell curl",
        "description": "Lift that barbell!"
    }
]
```

### `POST /api/activities` `(*)`

A request to this endpoint will attempt to create a new activity. You must pass a valid token with this request, or it will be rejected.

#### Request Parameters

* `name` (`string`, required): the desired name for the new activity
* `description` (`string`, required): the desired description for the new activity

#### Return Parameters

* `id` (`number`): This is the database identifier for the `activity`
* `name` (`string`): This is the name (or title) of the activity.
* `description` (`string`): This is the description of the activity.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/activities', {
  method: "POST",
  body: JSON.stringify({
    name: 'Running',
    description: 'Keep on running!'
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API creates a new activity, the following object will be returned:

```js
{
    "id": 9,
    "name": "Running",
    "description": "Keep on running!"
}
```


### `PATCH /api/activities/:activityId` `(*)`

Anyone can update an activity (yes, this could lead to long term problems a la wikipedia)

#### Request Parameters

* `name` (`string`, optional): the desired new name for the activity
* `description` (`string`, optional): the desired new description for the activity

#### Return Parameters

* `id` (`number`): This is the database identifier for the `activity`
* `name` (`string`): This is the name (or title) of the activity.
* `description` (`string`): This is the description of the activity.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/activities/9', {
  method: "PATCH",
  body: JSON.stringify({
    name: 'Running',
    description: 'Keep on running, til you drop!'
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API successfully edits the activity, the following object will be returned:

```js
{
    "id": 9,
    "name": "Running",
    "description": "Keep on running, til you drop!"
}
```

### `GET /api/activities/:activityId/routines`

This route returns a list of public routines which feature that activity

#### Request Parameters

There are no request parameters.

#### Return Parameters

(`array` of `object`):
  * `id` (`number`): This is the database identifier for the `routine` object.
  * `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
  * `creatorName` (`string`): This is the username for the `user` which created this `routine`
  * `isPublic` (`boolean`): Whether or not the routine should be visible to all users (will always be true for public routes)
  * `name` (`string`): This is the name (or title) of the routine.
  * `goal` (`string`): This is like the description of the routine.
  * `activity` (`array` of `activity` objects): An array of activities associated with this routine.
    * `id` (`number`): This is the database identifier for the `activity`
    * `name` (`string`): This is the name (or title) of the activity.
    * `description` (`string`): This is the description of the activity.
    * `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.
    * `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
    * `routineActivityId` (`number`): This is the database identifier for the `routine_activity`
    * `routineId` (`number`): This is the database identifier for the `routine`

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/activities/3/routines', {
  headers: {
    'Content-Type': 'application/json',
  },
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
[
    {
        "id": 2,
        "creatorId": 1,
        "isPublic": true,
        "name": "Chest Day",
        "goal": "To beef up the Chest and Triceps!",
        "creatorName": "albert",
        "activities": [
            {
                "id": 3,
                "name": "bench press",
                "description": "Lift a safe amount, but push yourself!",
                "duration": 8,
                "count": 10,
                "routineActivityId": 6,
                "routineId": 2
            },
            {
                "id": 4,
                "name": "Push Ups",
                "description": "Pretty sure you know what to do!",
                "duration": 7,
                "count": 10,
                "routineActivityId": 7,
                "routineId": 2
            }
        ]
    }
]
```

## Routines Endpoints

### `GET /api/routines`

This route returns a list of all public routines

#### Request Parameters

There are no request parameters.

#### Return Parameters

(`array` of `object`):
  * `id` (`number`): This is the database identifier for the `routine` object.
  * `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
  * `creatorName` (`string`): This is the username for the `user` which created this `routine`
  * `isPublic` (`boolean`): Whether or not the routine should be visible to all users (will always be true for public routes)
  * `name` (`string`): This is the name (or title) of the routine.
  * `goal` (`string`): This is like the description of the routine.
  * `activity` (`array` of `activity` objects): An array of activities associated with this routine.
    * `id` (`number`): This is the database identifier for the `activity`
    * `name` (`string`): This is the name (or title) of the activity.
    * `description` (`string`): This is the description of the activity.
    * `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.
    * `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
    * `routineActivityId` (`number`): This is the database identifier for the `routine_activity`
    * `routineId` (`number`): This is the database identifier for the `routine`

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routines', {
  headers: {
    'Content-Type': 'application/json',
  },
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
[
    {
        "id": 2,
        "creatorId": 1,
        "isPublic": true,
        "name": "Chest Day",
        "goal": "To beef up the Chest and Triceps!",
        "creatorName": "albert",
        "activities": [
            {
                "id": 3,
                "name": "bench press",
                "description": "Lift a safe amount, but push yourself!",
                "duration": 8,
                "count": 10,
                "routineActivityId": 6,
                "routineId": 2
            },
            {
                "id": 4,
                "name": "Push Ups",
                "description": "Pretty sure you know what to do!",
                "duration": 7,
                "count": 10,
                "routineActivityId": 7,
                "routineId": 2
            }
        ]
    },
    {
        "id": 4,
        "creatorId": 2,
        "isPublic": true,
        "name": "Cardio Day",
        "goal": "Running, stairs. Stuff that gets your heart pumping!",
        "creatorName": "sandra",
        "activities": [
            {
                "id": 6,
                "name": "treadmill",
                "description": "running",
                "duration": 10,
                "count": 10
            },
            {
                "id": 7,
                "name": "stairs",
                "description": "climb those stairs",
                "duration": 15,
                "count": 10
            }
        ]
    }
]
```

### `POST /api/routines` `(*)`

A request to this endpoint will attempt to create a new routine. You must pass a valid token with this request, or it will be rejected.

#### Request Parameters

* `name` (`string`, required): the desired name for the new routine
* `goal` (`string`, required): the desired goal description of the routine.
* `isPublic` (`boolean`, optional): Whether or not the routine should be visible to all users. `null` by default

#### Return Parameters

* `id` (`number`): This is the database identifier for the `routine`
* `name` (`string`): This is the name (or title) of the routine.
* `goal` (`string`): This is like the description of the routine.
* `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
* `isPublic` (`boolean`): Whether or not the routine should be visible to all users. `null` by default

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routines', {
  method: "POST",
  body: JSON.stringify({
    name: 'Long Cardio Routine',
    goal: 'To get your heart pumping!',
    isPublic: true
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API creates a new routine, the following object will be returned:

```js
{
    "id": 8,
    "creatorId": 2,
    "isPublic": true,
    "name": "Long Cardio Routine",
    "goal": "To get your heart pumping!"
}
```

### `PATCH /api/routines/:routineId` `(**)`

Update a routine, notably change public/private, the name, or the goal

#### Request Parameters

* `name` (`string`, optional): the desired new name for the routine
* `goal` (`string`, optional): the desired new goal description of the routine.
* `isPublic` (`boolean`, optional): Whether or not the routine should be visible to all users. `null` by default

#### Return Parameters

* `id` (`number`): This is the database identifier for the `routine`
* `name` (`string`): This is the name (or title) of the routine.
* `goal` (`string`): This is like the description of the routine.
* `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
* `isPublic` (`boolean`): Whether or not the routine should be visible to all users. `null` by default

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routines/6', {
  method: "PATCH",
  body: JSON.stringify({
    name: 'Long Cardio Day',
    goal: 'To get your heart pumping!'
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API successfully edits the routine, the following object will be returned:

```js
{
    "id": 6,
    "creatorId": 2,
    "isPublic": true,
    "name": "Long Cardio Day",
    "goal": "To get your heart pumping!"
}
```

### `DELETE /api/routines/:routineId` `(**)`

Hard delete a routine. Make sure to delete all the `routineActivities` whose routine is the one being deleted.

This endpoint will hard delete a routine whose `id` is equal to `routineId`.  Will also delete all the `routineActivities` whose routine is the one being deleted.  The request will be rejected if it is either missing a valid token, or if the user represented by the token is not the user that created the original routine.

#### Request Parameters

There are no request parameters.

#### Return Parameters

* `success` (`boolean`): Will be true if the routine was deleted
* `id` (`number`): This is the database identifier for the `routine`
* `name` (`string`): This is the name (or title) of the routine.
* `goal` (`string`): This is like the description of the routine.
* `creatorId` (`number`): This is the database identifier for the `user` which created this `routine`
* `isPublic` (`boolean`): Whether or not the routine should be visible to all users. `null` by default

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routines/6', {
  method: "DELETE",
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer TOKEN_STRING_HERE'
  }
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
{
    "success": true,
    "id": 6,
    "creatorId": 2,
    "isPublic": true,
    "name": "Long Cardio Day",
    "goal": "To get your heart pumping!"
}
```

### `POST /api/routines/:routineId/activities`

Attaches a single activity to a routine. Prevents duplication on `(routineId, activityId)` pair.

#### Request Parameters

* `activityId` (`number`): This is the database identifier for the `activity`
* `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
* `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.

#### Return Parameters

* `id` (`number`): This is the database identifier for the `routine_activity`
* `routineId` (`number`): This is the database identifier for the `routine`
* `activityId` (`number`): This is the database identifier for the `activity`
* `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
* `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routines/6/activities', {
  method: "POST",
  body: JSON.stringify({
    activityId: 7,
    count: 1, 
    duration: 20
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API associates the activity with the routine, the following object will be returned:

```js
{
    "id": 11,
    "routineId": 6,
    "activityId": 7,
    "duration": 20,
    "count": 1
}
```

## routine_activities Endpoints

### `PATCH /api/routine_activities/:routineActivityId` `(**)`

Update the count or duration on the routine activity

#### Request Parameters

* `count` (`number`, optional): This is the number of times (reps) this activity should be performed for this routine.
* `duration` (`number`, optional): This is how long (in minutes) this activity should be performed for this routine.

#### Return Parameters

* `id` (`number`): This is the database identifier for the `routine_activity`
* `routineId` (`number`): This is the database identifier for the `routine`
* `activityId` (`number`): This is the database identifier for the `activity`
* `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
* `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/api/routine_activities/11', {
  method: "PATCH",
  body: JSON.stringify({
    count: 2,
    duration: 30
  })
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

If the API successfully edits the routine, the following object will be returned:

```js
{
    "id": 11,
    "routineId": 6,
    "activityId": 7,
    "duration": 30,
    "count": 2
}
```

### `DELETE /api/routine_activities/:routineActivityId` `(**)`

Remove an activity from a routine (hard deleting routine_activity), dissociating an activity from a routine.

#### Request Parameters

There are no request parameters.

#### Return Parameters

* `success` (`boolean`): Will be true if the routine_activity was deleted
* `id` (`number`): This is the database identifier for the `routine_activity`
* `routineId` (`number`): This is the database identifier for the `routine`
* `activityId` (`number`): This is the database identifier for the `activity`
* `count` (`number`): This is the number of times (reps) this activity should be performed for this routine.
* `duration` (`number`): This is how long (in minutes) this activity should be performed for this routine.

#### Sample Call

```js
fetch('http://fitnesstrac-kr.herokuapp.com/api/routine_activities/11', {
  method: "DELETE",
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer TOKEN_STRING_HERE'
  }
}).then(response => response.json())
  .then(result => {
    console.log(result);
  })
  .catch(console.error);
```

#### Sample Response

```js
{
    "success": true,
    "id": 11,
    "routineId": 6,
    "activityId": 7,
    "duration": 25,
    "count": 1
}
```
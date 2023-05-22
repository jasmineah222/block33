# Workshop: Backend Fundamentals - Fitness Trackr

## Introduction

In this workshop, you'll be provided this GitHub repo with details for a full operational CRUD API that uses Express.JS, PostgreSQL, and other technologies that you've been trained on.

## Getting Started

Install Packages

    npm i

Initialize Database

    createdb fitness-dev

Start Server

    npm run start:dev

## Automated Tests

Currently, test suites must be run separately. I have not yet fixed this.

### DB Methods

    npm run test:watch db.spec

### API Routes (server must be running for these to pass)

    npm run test:watch api.spec

### Documentation

To edit the documentation, edit the `FitnessTrackr API Documentation.md` file, then copy the markdown content and use https://markdowntohtml.com/ to convert to html. Paste the html into `public/index.html` in the `div` with `id="doc-html"`.

## Problems to Solve

### Problem 1: Seed Database

Begin by seeding the database with the provided `seed.js` file. You can run this file with the following command:

    `npm run seed`

### Problem 2: GET all

Using Postman to test your API, create a GET route that returns all routines and activies available in the database. There shouldn't be any errors at this point.

### Problem 3: GET one by ID

Continuing to use Postman to test your API, you will encounter an error when trying to GET a single routine by ID. Fix this error.

### Problem 4: POST new

You will need to configure authorization in Postman to test this route. After authorizing, you will encounter an error when trying to POST a new routine. Fix this error.

### Problem 5: PATCH one by ID

In this exercise, you will update a record using Postman. There should be no errors if your code is correct.

### Problem 6: DELETE one by ID

Remove a record from the "rountine_activities" table. You will encounter an error. Fix this error.

### STRETCH GOAL: interactive frontend

Using ReactJS or HTML / CSS / JS, create a frontend that allows a user to interact with the API.


# Backend Take Home Project

Build out a FHIR Patient management portal

## Overview

This project is responsible for creating, retrieving, and updating [FHIR patients](https://www.hl7.org/fhir/patient.html).

It runs on Node.js 14.x, uses Expressjs.

There is tooling to create a datastore of patients in `data/patients.json`. These are [FHIR representations](https://www.hl7.org/fhir/patient.html) of patients.

There is tooling to create a datastore of users in `data/users.json`. These include an `id`, `password`, `passwordHash` and `permissions`.

## Project submission

1. Clone this project locally
2. Create a feature branch
3. Make your changes, committing as often as you would like
4. Once ready to submit, Rrun: `git add . && git commit -m 'solution' && git diff master > ./solution.txt`
5. Send the resulting `solution.txt` file to `zack@agilemd.com`

**Note** Please do not submit the solution as a Github Pull Request

## Goals

### 1. Implement an authenticate middleware
  - User datastore is provided, with usernames and sha1 hashed passwords
  - Basic auth via the `Authorization` header should be used
  - The passwords in the users database are only there so you can test the authenticate middleware. You should validate the passwords against the `passwordHash` which is a hex digest of the sha1 hash of the password.
  - This authenticate middleware should apply to all routes
### 2. Implement an authorize middleware
  - Each user has a `permissions` array that contains some combination of `GET` `LIST` `UPDATE` and `DELETE`
  - A user with the `GET` permission should be authorized to call the `GET /patients/:patientId` route
  - A user with the `LIST` permission should be authorized to call the `GET /patients` route
  - A user with the `UPDATE` permission should be authorized to call the `PUT /patients/:patientId` route
  - A user with the `DELETE` permission should be authorized to call the `DELETE /patients/:patientId` route
  - If a user tries to call a route they are not authorized for, the correct error should be thrown
  - The user must be authenticated before we even try to authorize
### 3. Implement a `PUT /patients/:patientId` route.
  - This updates the patient with an `id` of `patientId` if they exist
  - If the patient does not exists, throw the correct error.
  - This route **must** validate the patient data - however we do not need to support the full FHIR spec for patients, only support the following fields
    - `id`
    - `resourceType`
    - `gender`
    - `identifier`
    - `birthDate`
    - `name`
  - The specification for these fields can be found in the [FHIR documentation](https://www.hl7.org/fhir/patient.html) however, it is very verbose. You only need to validate the fields that we have in our patients data store. See appendix below for the spec.
  - The recommended approach to validation here is to use [joi](https://www.npmjs.com/package/joi) but any method is acceptable
### 4. Implement a `GET /patients` route.
  - This lists all patients that match given criteria
  - You should support the `birthdate` search parameter as described in the [Search Parameters FHIR spec](https://www.hl7.org/fhir/patient.html#search)
### 5. Improvements?
  - There is no deliverable for this portion - however, we will have a discussion about what improvements you would make to this project to make it production ready.

## Setup

1. Make sure you have the correct version of Node.js
2. Install your dependencies `npm install`
3. Run `npm run setup-data` to populate your data store
4. Run `npm run dev` to start the server
5. Try the existing `GET` route by navigation to `http://localhost:8080/patients/:patientId` in your browser, where `patientId` matches the ID of one of your generated patients

## Guidelines

1. You can use whatever dependencies you would like
2. The [Airbnb ESLint Style guide](https://www.npmjs.com/package/eslint-config-airbnb-base) is used, please follow it.
3. Use the utilities to create your data store - no need to commit this data (it's in gitignore so you shouldn't need to do anything to prevent that).
4. Your routes will interact with data store on the file system. You **should** persist any changes to disk (e.g. if a patient is deleted, delete them from the file on disk) however you do not have to optimize this. Doing `fs.writeFileSync` on every update is acceptable.
5. We use the [debug module](https://www.npmjs.com/package/debug) to print debug statements. See the documentation on how to use it. You do not need to add any debug statements, but it's there for you to use if you would like.
6. We expect this project to take between 2-4 hours depending on your familiarity with Javascript and the tools used here. If you find yourself spending more than 4 hours, please stop and submit what you have. We will use your feedback to calibrate.

## Appendix A - FHIR Patient slim format

```json
{
  "resourceType": "Patient",
  "id": String,
  "gender": String<one of coded values, see below>,
  "identifier": [
    {
      "use": String<one of coded values, see below>,
      "system": String,
      "value": String
    }
  ],
  "birthDate": Date - see https://www.hl7.org/fhir/datatypes.html#date,
  "name": [
    {
      "use": String<one of coded values, see below>,
      "text": String,
      "family": String,
      "given": [
        String
      ]
    }
  ]
}
```

**Coded Values**
- `gender` https://www.hl7.org/fhir/valueset-administrative-gender.html
- identifier `use` https://www.hl7.org/fhir/valueset-identifier-use.html
- name `user` https://www.hl7.org/fhir/valueset-name-use.html

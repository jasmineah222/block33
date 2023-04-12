# fitnesstrackr
an API for our new fitness empire, FitnessTrac.kr, using node, express, postgresql, and jQuery

## Getting Started
Install Packages

    npm i

Initialize Database

    createdb fitness-dev
    
Start Server

    npm run start:dev

## Automated Tests
Currently, test suites must be run separately.  I have not yet fixed this.

### DB Methods

    npm run test:watch db.spec

### API Routes (server must be running for these to pass)

    npm run test:watch api.spec

### Documentation

To edit the documentation, edit the `FitnessTrackr API Documentation.md` file, then copy the markdown content and use https://markdowntohtml.com/ to convert to html.  Paste the html into `public/index.html` in the `div` with `id="doc-html"`.

### Deployment
The api is hosted on Heroku, connected to this git repo, and though multiple collaborators are listed, the app is owned by services@fullstackacademy.com (at the time of writing this).
To deploy:
- As a signed-in collaborator on the heroku app `fitnesstrac-kr`...
- Go to the [Deploy](https://dashboard.heroku.com/apps/fitnesstrac-kr/deploy/github) tab of the app settings
- Click "Deploy Branch" to deploy the `master` branch.

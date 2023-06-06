# Running Rails Application with Docker, Seeds, and Migrations

This documentation will guide you through the steps required to run your Rails application using Docker. This includes setting up the Docker environment, running database migrations, and generating initial data using the seeds file.

## Prerequisites

Before proceeding, make sure you have Docker and Docker Compose installed in your development environment.

## Step 1: Environment Setup

1. Clone your Rails application repository to your local environment.

2. Navigate to the root directory of your project.

## Step 2: Environment Docker Setup

In the terminal, run the following command to create and start the containers:

1. docker-compose build --no-cache

2. docker-compose up

Another prompt run:

1. docker-compose exec app bash

2. cd /app

3. bundle exec rake db:migrate

4. bundle exec rake db:seed

## Conclusion

You now have your Rails application up and running using Docker, with database migrations applied and initial data generated from the seeds file.

You can access your application at http://localhost:3000 in your web browser.

# Use the official Ruby image as the base image
FROM ruby:2.7.0

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]

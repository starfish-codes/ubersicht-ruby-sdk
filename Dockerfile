# Dockerfile
# Use ruby image to build our own image
FROM ruby:3.1

ARG APP_ROOT=/app
ARG BUILD_PACKAGES="\
    vim \
    "

# token for fetching private gems https://www.surminus.com/blog/installing-private-gems-during-a-docker-build/
ARG BUNDLE_GITHUB__COM

# We specify everything will happen within the /app folder inside the container
WORKDIR $APP_ROOT

ENV PATH="${APP_ROOT}/bin:${PATH}"

RUN apt-get update -qq && apt-get install -y --fix-missing --no-install-recommends $BUILD_PACKAGES && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# We install all the dependencies
# RUN bundle config set jobs "$(getconf _NPROCESSORS_ONLN)" && \
#     bundle config set path /usr/local/bundle && \
#     bundle install

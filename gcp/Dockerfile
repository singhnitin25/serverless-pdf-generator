FROM ruby:3.3.6-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    wkhtmltopdf

WORKDIR /apps

# Copy the current directory contents into the container at /app
COPY . /apps

RUN gem install --no-document bundler \
    && bundle config --local frozen true \
    && bundle config --local without "development test" \
    && bundle install

ENV FUNCTION_SIGNATURE_TYPE='http'
ENV FUNCTION_TARGET='pdf_creation_service'

EXPOSE 8080

CMD ["bundle", "exec", "functions-framework-ruby"]
## Overview - Serverless PDF Generator Application

This project is a serverless Ruby application designed to generate PDFs from input HTML. It leverages the power of AWS Lambda and Google Cloud Functions to deliver a scalable and efficient PDF generation solution.

## Dependencies:

This app uses [Wicked PDF](https://github.com/mileszs/wicked_pdf) ruby library, which further uses [wkhtmltopdf](https://wkhtmltopdf.org/) shell utility to generate PDF file for given input.


## Google Cloud Function:

GCP provides function framework which we can use as light weight standalone application, easily deployable without worrying about server setup and all. We just need to focus on writing code.

Source - [Check GCP Ruby Function Framework for more details](https://github.com/GoogleCloudPlatform/functions-framework-ruby).
You can find product overview here [Cloud Run Functions](https://cloud.google.com/functions/docs/concepts/overview).

1. Code is present inside the folder serverless-pdf-generator/gcp/*
2. Setup 
    a) Install required ruby version - 3.3.6
    b) run `bundle install`
    c) Start function server as `bundle exec functions-framework-ruby --target pdf_creation_service`
    d) This will start a local server on port 8080
3. Sample Request-

#### GCP function Authentication

You need to generate IdToken to access GCP function. Either use ruby sdk or gcloud cli to generate token.

#### GCP function deployment

[Check this for more details](https://googlecloudplatform.github.io/functions-framework-ruby/v1.4.2/file.deploying-functions.html)

**Deploy GCP function with GCP provided runtimes & Images**
You can deploy GCP function from your local system using below command:
<pre>
gcloud functions deploy $YOUR_FUNCTION_NAME \
    --project=$YOUR_PROJECT_ID \
    --runtime=ruby27 \
    --trigger-http \
    --entry-point=$YOUR_FUNCTION_TARGET
</pre>
for example:
<pre>
gcloud functions deploy pdf_creation_service \
    --project=<TEST GCP PROJECT ID> \
    --runtime=ruby33 \
    --trigger-http \
    --entry-point=pdf_creation_service

</pre>

**Deploy GCP function with custom runtimes & managed by user**

1. Build the docker image using dockerfile `gcp/Dockerfile` and push it to google artifact registry. Use **Linux_x86_64** architecture only because cloud run supports only this architecture.You can use command `docker build --platform linux/amd64 -t pdf-generation-service:latest .` to build the image.
2. Now, you need to deploy it to Cloud Run Service:
<pre>
gcloud run deploy <CLOUD_RUN_SERVICE_NAME> \\
  --image=<DOCKER_IMAGEE_URL> \\
  --platform=managed \
  --region=<REGION> \
  --timeout=<TIMEOUT_IN_SECONDS> \
  --set-env-vars=GCP_PROJECT_ID=<PROJECT_ID> \
  --service-account=<SERVICE_ACCOUNT_EMAIL>
</pre>

## AWS Lambda Function:

Coming soon.....

## Advantage of serverless application:

Here are few major advantages of using serverless application:

#### Cost Efficiency
1. **Pay-as-you-go-model**: You are billed only for the actual compute time used, rather than paying for idle server capacity.
2. **Zero upfront costs**: No need to invest in and maintain physical or virtual servers.

#### Scalability
1. **Automatic scaling**: Serverless functions scale seamlessly with demand, handling sudden traffic spikes without manual intervention
2. **Global availability**: With cloud providers, serverless functions are often deployed across multiple regions, reducing latency for users worldwide.

#### Reduced Operational Overhead
1. **No server management**: Developers don't need to worry about provisioning, maintaining, or patching servers.
2. **Focus on code**: Allows teams to dedicate more time to application development rather than infrastructure management.

#### Faster Development and Deployment
1. **Event-driven model**: Functions can be triggered by various events (e.g., API calls, file uploads, database updates), simplifying workflows.
2. **Shorter release cycles**: Quick iteration due to modular nature and ease of deployment.


#### High Availability and Fault Tolerance
1. **Built-in redundancy**: Serverless platforms automatically manage fault tolerance and backups, ensuring high availability.
2. **Resilience**: Functions are distributed, minimizing the impact of regional outages.

#### Tight Integration with Cloud Ecosystems
1. **Ecosystem benefits**: Serverless functions integrate seamlessly with other cloud services, such as storage (S3, GCS), databases (DynamoDB, Firestore), and AI/ML services.
2. **Unified monitoring and logging**: Centralized tools like AWS CloudWatch or GCP Cloud Monitoring simplify observability.

#### Containerized Deployments:
1. **Custom runtimes**: Modern serverless platforms (e.g., AWS Lambda, Google Cloud Run) support containerized deployments, allowing you to package your application along with its dependencies in a Docker image.
2. **Support for non-standard environments**: By leveraging containers, serverless functions can support specialized libraries or custom software requirements that aren't natively supported by the serverless runtime.



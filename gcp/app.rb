require 'functions_framework'
require 'wicked_pdf'
require 'base64'
require 'json'

FunctionsFramework.http "pdf_creation_service" do |request|
  logger = request.logger

  WickedPdf.configure do |config|
    # TODO - Use this if you are using wkhtmltopdf-binary gem to install wkhtmltopdf library
    # config.exe_path = "#{Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')}"
    config.exe_path = "/usr/bin/wkhtmltopdf"
    config.enable_local_file_access = true
  end
  request_payload = parse_request_body(request.body.read.to_s, logger)
  logger.info "Processing request #{request.request_method} from #{request.url} with content body #{request.content_type}!"

  html = request_payload['html']
  pdf_options = request_payload['pdf_options'] || {}

  raise ArgumentError, "Argument input `html` is missing." if html.nil? || html.empty?

  resp = html_to_pdf(html, pdf_options, logger)
  if resp[:success]
    logger.info("PDF Generation successful.\n")
    { statusCode: 200, success: true, body: resp[:body] }
  else
    logger.info("PDF Generation failed due to error #{resp[:errorMessage]}.\n")
    { statusCode: 400, success: false, errorMessage: resp[:errorMessage] }
  end
end

def parse_request_body(body, logger)
  begin
    JSON.parse(body)
  rescue JSON::ParserError => e
    logger.error("Error parsing request body: #{e.message}\n")
    raise ArgumentError, "Error parsing request body: #{e.message}"
  end
end

def html_to_pdf(html, pdf_options, logger)
  logger.info("Generating PDF with PDF options = #{pdf_options}.\n")
  begin
    pdf = WickedPdf.new.pdf_from_string(html, pdf_options)
    pdf = Base64.encode64(pdf)
    { success: true, body: pdf }
  rescue => e
    logger.error e.message
    logger.error e.backtrace.inspect
    { success: false, errorMessage: e.message }
  end
end
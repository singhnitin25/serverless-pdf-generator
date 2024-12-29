require 'rspec'
require 'functions_framework/testing'

describe 'PDF Creation Service' do
  include FunctionsFramework::Testing
  let(:headers) { ["Content-Type: application/json"] }

  context 'when request payloads are valid' do
    let(:body) { { html: '<h1>Generate PDF for given HTML input</h1>', pdf_options: { page_size: 'A4' } }.to_json }

    it 'generates pdf successfully for given html input' do
      load_temporary 'app.rb' do
        request = make_post_request 'http://example.com:8080/', body, headers
        response = call_http "pdf_creation_service", request
        parsed_response = JSON.parse(response.body.first)
        expect(parsed_response['statusCode']).to eq 200
        expect(parsed_response['success']).to be true
        expect(parsed_response['errorMessage']).to be_blank
        expect(parsed_response['body']).to be_present
      end
    end
  end

  context 'when request payloads are invalid' do
    context 'when input html is missing' do
      let(:body) { { pdf_options: { page_size: 'A4' } }.to_json }
      it 'should raise error for missing html' do
        load_temporary 'app.rb' do
          request = make_post_request 'http://example.com:8080/', body, headers
          response = call_http "pdf_creation_service", request
          expect(response.status).to eq 500
          expect(response.body.join).to match(/ArgumentError: Argument input `html` is missing./)
        end
      end
    end

    context 'when request body is not valid JSON' do
      it 'should raise error for invalid JSON' do
        load_temporary 'app.rb' do
          request = make_post_request 'http://example.com:8080/', 'Invalid JSON', headers
          response = call_http "pdf_creation_service", request
          expect(response.status).to eq 500
          expect(response.body.join).to match(/ArgumentError: Error parsing request body/)
        end
      end
    end
  end
end
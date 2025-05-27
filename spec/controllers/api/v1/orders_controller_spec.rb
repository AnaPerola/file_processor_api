require 'rails_helper'

RSpec.describe "Api::V1::OrdersController", type: :request do
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/data2.txt'), 'text/plain') }

  describe "POST /api/v1/orders/process_file" do
    context "when file is present" do
      it "returns success" do
        allow(ProcessFileService).to receive(:call).and_return([{ user_id: 1, name: 'User', orders: [] }])
        
        post "/api/v1/orders/process_file", params: { file: file }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('File processed successfully')
      end
    end

    context "when file is missing" do
      it "returns bad request" do
        post "/api/v1/orders/process_file"

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('File parameter is required')
      end
    end

    context "when service returns an error" do
      it "returns bad request with error message" do
        allow(ProcessFileService).to receive(:call).and_return({ error: 'Invalid file' })

        post "/api/v1/orders/process_file", params: { file: file }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid file')
      end
    end

    context "when exception occurs" do
      it "returns internal server error" do
        allow(ProcessFileService).to receive(:call).and_raise(StandardError.new("Unexpected"))

        post "/api/v1/orders/process_file", params: { file: file }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['error']).to eq('Internal server error while processing file')
      end
    end

    context "when filters are passed" do
      it "passes order_ids and date filters to the service" do
        expect(ProcessFileService).to receive(:call).with(
          file,
          order_ids: [123, 456],
          start_date: "2024-01-01",
          end_date: "2024-12-31"
        ).and_return([])

        post "/api/v1/orders/process_file", params: {
          file: file,
          order_ids: "123,456",
          start_date: "2024-01-01",
          end_date: "2024-12-31"
        }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
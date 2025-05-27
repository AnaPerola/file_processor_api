require 'rails_helper'

RSpec.describe "Api::V1::OrdersController", type: :request do
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/data2.txt'), 'text/plain') }

  describe "POST /api/v1/orders/process_file" do
    context "when file is present" do
      it "returns success" do
        allow(ProcessFileService).to receive(:call).and_return([{ user_id: 1, name: 'User', orders: [] }])
        
        post "/api/v1/orders/process_file", 
             params: { file: file },
             headers: { 'HOST' => 'localhost' }  # Especifica um host válido

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('File processed successfully')
      end
    end

    context "when file is missing" do
      it "returns bad request" do
        post "/api/v1/orders/process_file",
             headers: { 'HOST' => 'localhost' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('File parameter is required')
      end
    end
  end
end
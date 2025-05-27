require 'rails_helper'

RSpec.describe ProcessFileService do
  let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'data2.txt') }
  let(:file) { File.open(file_path) }

  let(:filter_criteria_service) { instance_double('FilterCriteriaService') }

  before do
    allow(FilterCriteriaService).to receive(:new).and_return(filter_criteria_service)
    allow(filter_criteria_service).to receive(:matches?).and_return(true)
  end

  after do
    file.close
  end

  context 'when file is not present' do
    it 'returns an error' do
      result = described_class.call(nil)
      expect(result).to eq({ error: 'File is not present' })
    end
  end

  context 'when file is provided' do
    it 'returns grouped and formatted orders' do
      result = described_class.call(file)

      expect(result).to be_an(Array)
      expect(result.size).to eq(200)
      expect(result.first[:orders].first[:products].size).to eq(2)
    end
  end

  context 'with filter matching only one user' do
    it 'returns only filtered data' do
      allow(filter_criteria_service).to receive(:matches?) do |line|
        line[:user_id] == 123
      end

      result = described_class.call(file)

      expect(result.size).to eq(1)
      expect(result.first[:user_id]).to eq(123)
      expect(result.first[:orders].size).to eq(3)
    end
  end

  context 'when date filters are invalid' do
    it 'does not raise error' do
      result = described_class.call(file, start_date: 'invalid', end_date: 'also-bad')

      expect(result).to be_an(Array)
    end
  end
end

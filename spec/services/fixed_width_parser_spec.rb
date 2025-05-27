require 'rails_helper'

RSpec.describe FixedWidthParser do
  describe '#parse' do
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'data2.txt') }
    let(:file) { File.open(file_path) }
    let(:parser) { described_class.new(file) }

    after do
      file.close
    end

    it 'parses all lines correctly' do
      result = parser.parse

      expect(result).to be_an(Array)
      expect(result.size).to eq(3870)

      expect(result.first).to include(
        user_id: 88,
        name: 'Terra Daniel DDS',
        order_id: 836,
        product_id: 3,
        product_value: '1899.02',
        date: Date.new(2021, 9, 9)
      )

      expect(result.last).to include(
        user_id: 13,
        name: 'Mr. Paulina Conn',
        order_id: 119,
        product_id: 1,
        product_value: '1835.71',
        date: Date.new(2021, 6, 10)
      )
    end

    it 'ignores blank lines' do
      content_with_blanks = "\n" + File.read(file_path) + "\n"
      file_with_blanks = StringIO.new(content_with_blanks)
      parser_with_blanks = described_class.new(file_with_blanks)

      result = parser_with_blanks.parse

      expect(result.size).to eq(3870)
    end

    it 'returns empty array when file is nil or empty' do
      parser_nil = described_class.new(nil)
      expect(parser_nil.parse).to eq([])

      empty_file = StringIO.new('')
      parser_empty = described_class.new(empty_file)
      expect(parser_empty.parse).to eq([])
    end
  end
end

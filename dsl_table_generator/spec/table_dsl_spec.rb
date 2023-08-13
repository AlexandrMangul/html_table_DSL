# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("..", __dir__))

require 'table_dsl'

module TableDSL
  describe Builder do
    context 'when setting invalid attributes' do
      it 'raises an exception for negative rows or cols' do
        expect {
          Builder.new { create_table(-1, 3) }
        }.to raise_error(ArgumentError, 'Number of rows and cols must be greater than zero')
      end

      it 'raises an exception for negative border' do
        expect {
          Builder.new { set_border(-2) }
        }.to raise_error(ArgumentError, 'Border must be non-negative')
      end

      it 'raises an exception for negative cellpadding' do
        expect {
          Builder.new { set_cellpadding(-1) }
        }.to raise_error(ArgumentError, 'Cellpadding must be non-negative')
      end
    end

    context 'when applying invalid styles' do
      it 'raises an exception for non-string styles' do
        expect {
          Builder.new { apply_styles :invalid_styles }
        }.to raise_error(ArgumentError, 'Styles argument must be a string')
      end
    end

    context 'when generating HTML with valid parameters' do
      it 'generates an HTML table with headers and data' do
        builder = Builder.new do
          create_table 2, 2
          set_dimensions '50%', '300px'
          set_border 2
          set_cellpadding 10
          apply_styles 'fashionable-table'
          add_headers 'Name', 'Age'
          add_data 'Alice', 28, 'Bob', 35
        end

        html = builder.to_html
        puts html

        expect(html).to include('<table')
        expect(html).to include("style='width: 50%; height: 300px;")
        expect(html).to include("class='fashionable-table'")
        expect(html).to include('<tr><th>Name</th><th>Age</th></tr>')
        expect(html).to include("<tr><td style='border: 2px solid;'>Alice</td><td style='border: 2px solid;'>28</td></tr>")
        expect(html).to include("<tr><td style='border: 2px solid;'>Bob</td><td style='border: 2px solid;'>35</td></tr>")
      end
    end
  end
end

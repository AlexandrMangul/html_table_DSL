# # frozen_string_literal: true

module TableDSL
  class Builder
    def initialize(&block)
      @table_attributes = {
        rows: 1,
        cols: 1,
        width: '100%',
        height: 'auto',
        border: 1,
        cellpadding: 0,
        headers: [],
        data: [],
        styles: {}
      }
      instance_eval(&block) if block_given?
    end

    def create_table(rows, cols)
      raise ArgumentError, 'Number of rows and cols must be greater than zero' if rows <= 0 || cols <= 0

      @table_attributes[:rows] = rows
      @table_attributes[:cols] = cols
    end

    def set_dimensions(width, height)
      @table_attributes[:width] = width
      @table_attributes[:height] = height
    end

    def set_border(border)
      raise ArgumentError, 'Border must be non-negative' if border.negative?

      @table_attributes[:border] = border
    end

    def set_cellpadding(padding)
      raise ArgumentError, 'Cellpadding must be non-negative' if padding.negative?

      @table_attributes[:cellpadding] = padding
    end

    def add_headers(*headers)
      @table_attributes[:headers] = headers
    end

    def add_data(*data)
      @table_attributes[:data] = data
    end

    def apply_styles(styles)
      raise ArgumentError, 'Styles argument must be a string' unless styles.is_a?(String)

      @table_attributes[:styles] = styles
    end

    def to_html
      table_style = "width: #{@table_attributes[:width]}; height: #{@table_attributes[:height]}; border: #{@table_attributes[:border]}px; border-collapse: collapse; padding: #{@table_attributes[:cellpadding]}px;"
      table_class = @table_attributes[:styles].empty? ? '' : "class='#{@table_attributes[:styles]}'"

      html = "<table style='#{table_style}' #{table_class}>\n"

      if @table_attributes[:headers].any?
        header_row = @table_attributes[:headers].map { |h| "<th>#{h}</th>" }.join
        html += "<tr>#{header_row}</tr>\n"
      end

      data_rows = @table_attributes[:data].each_slice(@table_attributes[:cols]).to_a
      data_rows.each do |data_row|
        data_cells = data_row.map { |d| "<td style='border: #{@table_attributes[:border]}px solid;'>#{d}</td>" }
        html += "<tr>#{data_cells.join}</tr>\n"
      end

      html += "</table>\n"
    end
  end
end

# frozen_string_literal: true

require 'sinatra'
require_relative 'table_dsl'

set :public_folder, 'public'

get '/' do
  builder = TableDSL::Builder.new do
    create_table 3, 4
    set_dimensions '80%', 'auto'
    set_border 2
    set_cellpadding 10
    add_headers 'Name', 'Age', 'Occupation', 'Location'
    add_data 'Alice', 28, 'Engineer', 'New York', 'Bob', 35, 'Designer', 'San Francisco', 'Charlie', 22, 'Student',
             'Chicago', 'David', 45, 'Manager', 'Los Angeles'
    apply_styles('fashionable-table')
  end

  erb :index, locals: { html_code: builder.to_html }
end

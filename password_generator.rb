# frozen_string_literal: true

require 'cssminify'
require 'faker'
require 'htmlbeautifier'
require 'markaby'
require 'sinatra'
require 'zxcvbn'

require './lib'

set :public_folder, File.dirname(__FILE__)
unless `hostname`.start_with?('damien')
  set :bind, '0.0.0.0'
  set :port, 80
end

get '/' do
  index_page
end

PASSWORD_TYPES.each do |type|
  get password_route(type) do
    password_page(type)
  end
end

get '/random_password' do
  password_page(PASSWORD_TYPES.sample)
end

get '/testing_password' do
  password_page('Space')
  # password_page(:overwatch)
  # password_page(:silicon_valley)
  # password_page(:fallout)
  # password_page(:zelda)
  # password_page(:harry_potter)
  # password_page(:hacker)
end

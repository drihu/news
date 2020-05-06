require 'http'
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative './app/helpers/helper'

helpers Helper

get '/:path?' do |path|
  @tab = {}
  if params['page'] && params['page'].to_i > 0
    page = params['page'].to_i
  else
    page = 1
  end

  case path
  when nil
    articles = HTTP.get("https://api.hnpwa.com/v0/news/#{page}.json").parse
  when 'newest'
    @tab['newest'] = 'active'
    articles = HTTP.get("https://api.hnpwa.com/v0/newest/#{page}.json").parse
  when 'ask'
    @tab['ask'] = 'active'
    articles = HTTP.get("https://api.hnpwa.com/v0/ask/#{page}.json").parse
  when 'show'
    @tab['show'] = 'active'
    articles = HTTP.get("https://api.hnpwa.com/v0/show/#{page}.json").parse
  when 'jobs'
    @tab['jobs'] = 'active'
    articles = HTTP.get("https://api.hnpwa.com/v0/jobs/#{page}.json").parse
  else
    halt(404, { 'Content-Type' => 'text/plain' }, 'Unknown.')
  end

  erb(:home, locals: { articles: articles, page: page, path: path })
end

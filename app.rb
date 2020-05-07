require 'http'
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers/helper'

helpers Helper

get '/:path?' do |path|
  @tab = {}
  page = params.fetch('page', 1).to_i

  case path
  when nil
    articles = HTTP.get("https://api.hnpwa.com/v0/news/#{page}.json").parse
  when 'new'
    @tab['new'] = 'active'
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

  articles.each_with_index do |article, i|
    article['host_url'] = "#{article['url'][/(https|http)/]}://#{article['domain']}"
    article['number'] = 30 * (page - 1) + i + 1
  end

  erb(:home, locals: { articles: articles, page: page, path: path })
end

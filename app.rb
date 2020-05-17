require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers/helper'

helpers Helper

get /\/(new|ask|show|jobs)?/ do |path|
  page = params.fetch('page', 1).to_i
  max_pages = get_max_pages(path: path)
  articles = get_articles(path: path, page: page)
  erb(:home, locals: {
    articles: articles,
    page: page,
    max_pages: max_pages,
  })
end

get '/item' do
  id = params['id']
  %{
    <h1>#{id}</h1>
    <div>I'm working on this. Please be patient.</div>
    <a href="/">Go Home</a>
  }
end

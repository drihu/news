require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers/helper'

helpers Helper

get /\/(new|ask|show|jobs)?/ do |path|
  path = "/#{path}" || '/'
  page = params.fetch('page', 1).to_i
  page_count = get_page_count(path: path)
  articles = get_articles(path: path, page: page)

  erb(:home, locals: {
    articles: articles,
    page: page,
    page_count: page_count,
    path: path,
  })
end

get '/item' do
  item = get_item(params['id'])

  erb(:item_page, locals: { item: item })
end

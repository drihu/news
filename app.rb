require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helpers/helper'

use Rack::Deflater

helpers Helper

set :static_cache_control, [:public, :max_age => 86400]

before do
  cache_control :public, :must_revalidate, :max_age => 300
end

get /\/(new|ask|show|jobs)?/ do |path|
  path = "/#{path}" || '/'
  page = params.fetch('page', 1).to_i
  page_count = get_page_count(path: path)
  feed_title = get_feed_title(path)
  feed_items = get_feed_items(path: path, page: page)

  erb(:feed_page, locals: {
    feed_title: feed_title,
    feed_items: feed_items,
    page: page,
    page_count: page_count,
    path: path,
  })
end

get '/item' do
  item = get_item(params['id'])

  erb(:item_page, locals: { item: item })
end

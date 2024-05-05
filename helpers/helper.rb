require 'http'

module Helper
  API_BASE_URL = 'https://api.hnpwa.com/v0'

  PATHS = {
    '/' => {
      feed_title: 'Popular',
      api_path: '/news',
      api_page_count: 10,
    },
    '/new' => {
      feed_title: 'New',
      api_path: '/newest',
      api_page_count: 10,
    },
    '/ask' => {
      feed_title: 'Ask',
      api_path: '/ask',
      api_page_count: 2,
    },
    '/show' => {
      feed_title: 'Show',
      api_path: '/show',
      api_page_count: 2,
    },
    '/jobs' => {
      feed_title: 'Jobs',
      api_path: '/jobs',
      api_page_count: 1,
    }
  }

  def get_feed_title(path)
    feed_title = PATHS[path][:feed_title]
  end

  def get_feed_items(path: '/', page: 1)
    feed_items = HTTP.get("#{API_BASE_URL}#{PATHS[path][:api_path]}/#{page}.json").parse

    feed_items.each do |feed_item|
      scheme = feed_item['url'][/(https|http)/]
      feed_item['domain_url'] = "#{scheme}://#{feed_item['domain']}"
      feed_item['title'] = escape_html feed_item['title']
    end
  end

  def get_page_count(path: '/')
    PATHS[path][:api_page_count]
  end

  def get_link(path, page)
    "#{path}?page=#{page}"
  end

  def get_item(id)
    item = HTTP.get("#{API_BASE_URL}/item/#{id}.json").parse
  end

  def get_lines(content)
    lines = content.gsub('\n', ' ').split('<p>').select { |line| not line.empty? }
  end
end

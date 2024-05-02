require 'http'

module Helper
  API_BASE_URL = 'https://api.hnpwa.com/v0'

  PATHS = {
    '/' => {
      api_path: '/news',
      api_page_count: 10
    },
    '/new' => {
      api_path: '/newest',
      api_page_count: 10
    },
    '/ask' => {
      api_path: '/ask',
      api_page_count: 2
    },
    '/show' => {
      api_path: '/show',
      api_page_count: 2
    },
    '/jobs' => {
      api_path: '/jobs',
      api_page_count: 1
    }
  }

  def get_articles(path: '/', page: 1)
    articles = HTTP.get("#{API_BASE_URL}#{PATHS[path][:api_path]}/#{page}.json").parse

    articles.each do |article|
      scheme = article['url'][/(https|http)/]
      article['domain_url'] = "#{scheme}://#{article['domain']}"
      article['title'] = escape_html article['title']
    end
  end

  def get_page_count(path: '/')
    PATHS[path][:api_page_count]
  end

  def get_link(path, page)
    "#{path}?page=#{page}"
  end
end

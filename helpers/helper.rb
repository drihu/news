require 'http'

module Helper
  def get_domain_url(article)
    scheme = article['url'][/(https|http)/]
    domain = article['domain']
    "#{scheme}://#{domain}"
  end

  def get_articles(path: nil, page: 1)
    case path
    when nil
      articles = HTTP.get("https://api.hnpwa.com/v0/news/#{page}.json").parse
    when 'new'
      articles = HTTP.get("https://api.hnpwa.com/v0/newest/#{page}.json").parse
    when 'ask'
      articles = HTTP.get("https://api.hnpwa.com/v0/ask/#{page}.json").parse
    when 'show'
      articles = HTTP.get("https://api.hnpwa.com/v0/show/#{page}.json").parse
    when 'jobs'
      articles = HTTP.get("https://api.hnpwa.com/v0/jobs/#{page}.json").parse
    else
      articles = nil
    end
    articles.each_with_index do |article, i|
      article['domain_url'] = get_domain_url(article)
      article['number'] = 30 * (page - 1) + i + 1
    end
    articles
  end

  def get_max_pages(path: nil)
    case path
    when nil then max_pages = 10
    when 'new' then max_pages = 12
    when 'ask' then max_pages = 2
    when 'show' then max_pages = 2
    when 'jobs' then max_pages = 1
    else max_pages = nil
    end
    max_pages
  end
end

#!/usr/bin/env ruby
#description: get http server basic banner and output the result
#author:k3m

require 'faraday'
require 'socket'
require 'faraday_middleware'

def banner_request(url)
    result = {}
    begin
        faraday = Faraday.new(:url => url, :ssl => {:verify => false}) do |builder|
            builder.response :follow_redirects
            #builder.use Faraday::Response::Logger
            builder.adapter :net_http
        end
        response = faraday.get(url)
        result['server'] = response.headers['server']
        result['status_code'] = response.status
        begin
            result['title'] = response.body.scan(/<title>(.*?)<\/title>/)
        rescue => exception
            result['title'] = ''
        end
        puts url
        return result
    rescue => exception
        return nil
    end
end

def add_domain(filename)
    lines = File.readlines(filename)
    result = []
    for line in lines
        result << regex_subdomain(line.chomp)
    end
    return result
end

def test_subdomain(subdomain)
    #puts subdomain
    begin
        result = Socket.getaddrinfo(subdomain, "http", nil, :STREAM)
        #puts result
        return true
    rescue => exception
        return false
    end
end

def regex_subdomain(line)
    return (/[a-z0-9\-\.]{2,}[com||cn||io||kr||jp||sg||us||uk||ca||br]/).match(line).to_s.strip
end

def regex_ip(line)
    return (/((\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.){3}(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$/).match(line).to_s.strip
end

filename = 'passivetotal_logitech-com_subdomains.csv'


lines = add_domain(filename)
subdomains = []
for line in lines do
    if test_subdomain(line)
        puts banner_request("https://" + line)
    end
end

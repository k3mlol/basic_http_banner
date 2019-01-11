#!/usr/bin/env ruby
#description: get cname
#author: k3m
require 'net/dns'

def get_header_rcode(domain)
    begin
        return Resolver(domain).header.rCode.explanation.to_s
    rescue => exception
        return ""
        
    end
end

def add_domain(filename)
    lines = File.readlines(filename)
    result = []
    for line in lines
        tmp_str = regex_subdomain(line.chomp)
        if !result.include?(tmp_str)
            result << tmp_str
        end
    end
    return result
end

def regex_subdomain(line)
    return (/[a-z0-9\-\.]{1,}\.starbucks\.[a-z]{1,}\.[a-z]{1,}/).match(line).to_s.strip
end

def get_answer_cname(domain)
    p Resolver(domain).answer
=begin
        answer_str = packet.answer.to_s.split(',')
        for str in answer_str
            if Net::DNS::RR.new(str).type.to_s == "CNAME"
                puts Net::DNS::RR.new(str).name
                p str
            end
        end
    rescue => exception
=end
end

file_name = "starbucks.txt"

result = add_domain(file_name)
p get_header_rcode("westus-cardreloadloadus.starbucks.com")
#puts result
=begin
get_header_rcode("westus-cardreloadloadus.starbucks.com")
for line in result
    p line
    p get_header_rcode(line)
    p "-----"
end
=end

require 'fileutils'
require_relative 'model'
require_relative 'helpers'

include Sinatra
include Helpers


def render_link(title, url)
    '[' + title + '](' + url  + ')'
end

def render_toc(f)
    f.puts '## Table of content'

    [:free, :demo, :paid].each { |type|
        category = type_name(type).capitalize
        anchor = '#' + category.downcase.gsub!(' ', '-')
        f.puts('* ' + render_link(category, anchor))
    }
end

def render_categories(type, data, f)
    f.puts
    f.puts('## ' + type_name(type).capitalize)

    categories = data.categories
    count = data.count

    categories.sort.each_with_index { |(category, projects), index|
        f.puts('### ' + category + ' (' + count.to_s + ')')
        projects.each { |project|
            name = project[ 'name']
            url = project['url']
            f.puts('* ' + render_link(name, url))
        }
        f.puts
    }
end

readme = 'README.md'
header = 'README-HEADER.md'
data = DataContext.new

FileUtils.cp(header, readme)
open(readme, 'a') { |f|
    f.puts '<hr/>'
    render_toc(f)
    render_categories(:free, data.free, f)
    render_categories(:demo, data.demo, f)
    render_categories(:paid, data.paid, f)
}

puts 'README file was generated';
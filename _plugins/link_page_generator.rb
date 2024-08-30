module LinkTagPlugin
  class LinkPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      tags = site.data["links"].flat_map { |link| link["tags"]  }.uniq.sort

      site.pages << LinkPage.new(site, tags, "", site.data["links"])

      tags.each do |tag|
        tag_links = site.data["links"].select { |link| link["tags"].include?(tag) }
        site.pages << LinkPage.new(site, tags, tag, tag_links)
      end
    end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class LinkPage < Jekyll::Page
    def initialize(site, tags, tag, links)
      @content = File.read(File.expand_path "../_templates/links.html", __dir__)
      @title = tag.length > 0 ? "Links - " + tag_name(tag) : "Links"
      @permalink = "/links/#{tag}"
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = "links/#{tag}"              # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
      @ext      = '.html'      # the extension.
      @name     = 'index.html' # basically @basename + @ext.

      all_tags = tags.map do |tag_item|
        {
          "name" => tag_name(tag_item),
          "tag" => tag_item,
          "count" => site.data["links"].select { |l| l["tags"].include?(tag_item) }.count
        }
      end

      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
        'tag_links' => links,
        'all_tags' => all_tags,
        "layout" => "default",
        "title" => @title,
        "top_level" => tag.length == 0
      }
    end

    # Placeholders that are used in constructing page URL.
    def url_placeholders
      {
        :path       => @dir,
        :category   => @dir,
        :basename   => basename,
        :output_ext => output_ext,
      }
    end

    def tag_name(tag)
      tag.gsub("_", " ").gsub(/\w+/) do |word|
        word.capitalize
      end
    end
  end
end
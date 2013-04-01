module Scorched
  module Helpers
    module Assets
      FRAGMENT_HASH           = "#".freeze
      APPEND_ASSET_EXTENSIONS = [:js, :css]  # assets that require an appended extension
      ABSOLUTE_URL_PATTERN    = %r{^(https?://)} # absolute url regex

      ##
      # Returns an html script tag for each of the sources provided.
      # You can pass in the filename without extension or a symbol and we search it in your +appname.public_folder+
      # like app/public/stylesheets for inclusion. You can provide also a full path.
      #
      # @overload stylesheet_link_tag(*sources, options={})
      #   @param [Array<String>] sources   Splat of css source paths
      #   @param [Hash]          options   The html options for the link tag
      #
      # @return [String] Stylesheet link html tag for +sources+ with specified +options+.
      #
      # @example
      #   stylesheet_link_tag 'style', 'application', 'layout'
      #
      # @api public
      def stylesheet_link_tag(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(:media => 'screen', :rel => 'stylesheet', :type => 'text/css')
        sources.flatten.map { |source|
          tag(:link, options.reverse_merge(:href => asset_path(:css, source)))
        }.join("\n")
      end

      ##
      # Returns an html script tag for each of the sources provided.
      # You can pass in the filename without extension or a symbol and we search it in your +appname.public_folder+
      # like app/public/javascript for inclusion. You can provide also a full path.
      #
      # @overload javascript_include_tag(*sources, options={})
      #   @param [Array<String>] sources   Splat of js source paths
      #   @param [Hash]          options   The html options for the script tag
      #
      # @return [String] Script tag for +sources+ with specified +options+.
      #
      # @example
      #   javascript_include_tag 'application', :extjs
      #
      # @api public
      def javascript_include_tag(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(:type => 'text/javascript')
        sources.flatten.map { |source|
          content_tag(:script, nil, options.reverse_merge(:src => asset_path(:js, source)))
        }.join("\n")
      end

      def stylesheet(*sources)
        stylesheet_link_tag(*sources)
      end
      alias_method :stylesheets, :stylesheet  
      alias_method :css, :stylesheet

      def javascript(*sources)
        javascript_include_tag(*sources)
      end
      alias_method :javascripts, :javascript
      alias_method :js,          :javascript
    
      def is_uri?(source)
        source =~ ABSOLUTE_URL_PATTERN || source =~ /^\// # absolute source
      end

      def asset_path(kind, source)
        source = asset_normalize_extension(kind, URI.escape(source.to_s))
        return source if is_uri?(source)  
        
        @@count ||= 0  
        if @@count < asset_host_limit
          @@count = @@count + 1 
        else
          @@count = 1
        end
        
        asset_folder = asset_folder_name(kind)

        if self.class.respond_to?(:assets_host)     
          result_path = asset_host(source) 
          result_path << uri_root_path(asset_folder, source)      
        else 
          result_path = uri_root_path(asset_folder, source)      
        end    

        timestamp = asset_timestamp(result_path)
        
        "#{result_path}#{timestamp}"
      end

      ##
      # Returns the timestamp mtime for an asset
      #
      # @example
      #   asset_timestamp("some/path/to/file.png") => "?154543678"
      #   asset_timestamp("/some/absolute/path.png", true) => nil
      #
      def asset_timestamp(file_path, absolute=false)
        return nil if file_path =~ /\?/ || (self.class.respond_to?(:asset_stamp) && !self.class.asset_stamp)
        public_file_path = File.join(settings.root, 'public', file_path) if settings.respond_to?(:root)
        stamp   = File.mtime(public_file_path).to_i if public_file_path && File.exist?(public_file_path)
        stamp ||= Time.now.to_i unless absolute
        "?#{stamp}" if stamp
      end

    private  
      # Normalizes the extension for a given asset
      #
      #  @example
      #
      #    asset_normalize_extension(:images, "/foo/bar/baz.png") => "/foo/bar/baz.png"
      #    asset_normalize_extension(:js, "/foo/bar/baz") => "/foo/bar/baz.js"
      #
      def asset_normalize_extension(kind, source)
        ignore_extension = !APPEND_ASSET_EXTENSIONS.include?(kind.to_sym)
        source << ".#{kind}" unless ignore_extension || source =~ /\.#{kind}/ || source =~ ABSOLUTE_URL_PATTERN
        source
      end

      def uri_root_path(*paths)
        root_uri = settings.uri_root if settings.respond_to?(:uri_root)
        root_uri = settings.assets_uri_root if settings.respond_to?(:assets_uri_root)
        File.join(ENV['RACK_BASE_URI'].to_s, root_uri || '/', *paths)
      end 
         
      def asset_folder_name(kind)
        if kind == :css  
          asset_folder = 'stylesheets'
          asset_folder = settings.stylesheets_folder.to_s if settings.respond_to?(:stylesheets_folder)
        elsif kind == :js                               
          asset_folder = 'javascripts'                  
          asset_folder = settings.javascripts_folder.to_s if settings.respond_to?(:javascripts_folder)                
        else
          asset_folder = kind.to_s
        end 
      
        return asset_folder
      end 

      def asset_host(source)       
        unless settings.assets_host.is_a?(Proc)     
          host = settings.assets_host    
          host = settings.assets_host.gsub("%d", @@count.to_s) if settings.assets_host.index('%d')
        end  
        host = settings.assets_host(source, request) if settings.assets_host.is_a?(Proc)    
        return host
      end       
      
      def asset_host_limit()
        return 4 unless self.class.respond_to?(:assets_host_count)   
        settings.assets_host_count
      end
    end
  end
end

module RubyJmeter
  class ExtendedDSL < DSL
    def extract(params, &block)
      node = if params[:regex]
        params[:refname] = params[:name]
        params[:regex] = params[:regex] #CGI.escapeHTML
        params[:template] = params[:template] || "$1$"
        RubyJmeter::RegularExpressionExtractor.new(params)
      elsif params[:xpath]
        params[:refname] = params[:name]
        params[:xpathQuery] = params[:xpath]
        RubyJmeter::XpathExtractor.new(params)
      elsif params[:json]
        params[:VAR] = params[:name]
        params[:JSONPATH] = params[:json]
        RubyJmeter::Plugins::JsonPathExtractor.new(params)
      elsif params[:css]
        params[:refname] = params[:name]
        params[:expr] = params[:css]
        RubyJmeter::CssjqueryExtractor.new(params)
      end

      attach_node(node, &block)
    end

    alias web_reg_save_param extract
  end
end

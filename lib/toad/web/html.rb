require "haml"

module Toad::Web::HTML

  include Haml::Helpers

  def actions
    tag "div", {class: "actions"}, &proc
  end

  def ajax_list_builder(name, data_url, attrs={})
    attrs = attrs.dup
    values = [*attrs.delete(:value)]
    text_field name, attrs
    tag "script", <<-javascript
      $('##{attrs[:id] || name}').textext({
        plugins : 'autocomplete tags ajax',
        tags : {
          items : #{values.to_json}
        },
        ajax : {
          url : '#{data_url}',
          dataType : 'json',
          cacheResults : false
        }
      });
    javascript
  end

  def cancel(name="Cancel", path=request.path.sub(/\/[^\/]+$/, ""), attrs={})
    link_to name, path, {class: "btn"}.merge(attrs)
  end

  def concat(*a,&b)
    haml_concat(*a,&b)
  end

  def edit_link(text, path)
    link_to text, path, class: "btn primary small pull-right"
  end

  def error
    tag "div", class: "alert-message block-message error", &proc
  end

  def form(action, attrs={}, &block)
    attrs = attrs.dup
    _method = attrs.delete(:method)
    tag "div", class: "row" do
      tag "div", class: "span12" do
        tag "form", {action: action, method: "post", class: "form-stacked"}.merge(attrs) do
          tag "input", name: "_method", type: "hidden", value: _method if _method
          yield
        end
      end
    end
  end

  def fieldset(legend=nil)
    tag "fieldset", legend, &proc
  end

  def h(content)
    html_escape content
  end

  def info
    tag "div", class: "alert-message block-message info", &proc
  end

  def link_to(text, url, attrs={})
    tag "a", h(text), {href: url}.merge(attrs)
  end

  def page_title(title)
    tag "h1", title, class: "page-title title"
  end

  def password_field(name, options={})
    text_field(name, options.merge(type: "password"))
  end

  def remove_link(text, path)
    link_to text, path, class: "btn small pull-right"
  end

  def submit(text, attributes={})
    tag("input", {type: "submit", class: "btn primary", value: text}.merge(attributes))
  end

  def tag(*a,&b)
    name = a.shift
    opts = a.pop if a.last.is_a?(Hash)
    html = a.pop if a.last

    if html
      haml_tag name, opts || {} do
        concat html
      end
    elsif block_given?
      haml_tag name, opts || {} do
        yield
      end
    else
      haml_tag name, opts || {}
    end
  end

  def text_area(name, options={})
    attrs = options.dup
    label = attrs.delete :label

    attrs[:id]   = name   unless attrs.key? :id
    attrs[:name] = name   unless attrs.key? :name

    value = attrs.delete :value


    tag "div", class: "clearfix" do
      tag "label", label, for: attrs[:id] if label
      tag "div", class: "input" do
        tag "textarea", value, {class: "span6", rows: 25, cols: 80}.merge(attrs)
      end
    end
  end

  def text_field(name, options={})
    attrs = options.dup
    label = attrs.delete :label

    attrs[:id]   = name   unless attrs.key? :id
    attrs[:name] = name   unless attrs.key? :name
    attrs[:type] = "text" unless attrs.key? :type

    tag "div", class: "clearfix" do
      tag "label", label, for: attrs[:id] if label
      tag "div", class: "input" do
        tag "input", {class: "span6"}.merge(attrs)
      end
    end
  end
end

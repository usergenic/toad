module Toad::Web::HTML

  def actions
    tag "div", {class: "actions"}, &proc
  end

  def concat(*a,&b)
    haml_concat(*a,&b)
  end

  def error
    tag "div", class: "alert-message block-message error", &proc
  end

  def form(action, attributes={}, &block)
    tag "div", class: "row" do
      tag "div", class: "span12" do
        tag "form", {action: action, method: "post", class: "form-stacked"}.merge(attributes), &block
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

  def link_to(text, url, attributes={})
    tag "a", h(text), {href: url}.merge(attributes)
  end

  def page_title(title)
    tag "h1", title, class: "page-title"
  end

  def password_field(name, options={})
    text_field(name, options.merge(type: "password"))
  end

  def submit(text, attributes={})
    tag("input", {type: "submit", class: "btn primary", value: text}.merge(attributes))
  end

  def tag(*a,&b)
    haml_tag *a, &b
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
        tag "input", attrs.merge(class: "span6")
      end
    end
  end
end

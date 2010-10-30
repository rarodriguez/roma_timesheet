module JqgridJson
  include ActionView::Helpers::JavaScriptHelper

  def to_jqgrid_json(attributes, current_page, per_page, total)
    json = %Q({"page":"#{current_page}","total":#{total/per_page.to_i+1},"records":"#{total}")
    if total > 0
      json << %Q(,"rows":[)
      each do |elem|
        elem.id ||= index(elem)
        json << %Q({"id":"#{elem.id}","cell":[)
        couples = elem.attributes.symbolize_keys
        attributes.each do |atr|
          value = get_atr_value(elem, atr, couples)
          value = our_escape_javascript(value) if value and value.is_a? String
          json << %Q("#{value}",)
        end
        json.chop! << "]},"
      end
      json.chop! << "]}"
    else
      json << "}"
    end
  end
  
  def to_jqgrid_json_hash(attributes, current_page, per_page, total)
    json = %Q({"page":"#{current_page}","total":"#{total/per_page.to_i+1}","records":"#{total}")
    if total > 0
      json << %Q(,"rows":[ )
      each do |elem|
        json << %Q({"id":"#{elem[:id]}","cell":[ )
        attributes.each do |atr|
          value = elem[atr]
          value = our_escape_javascript(value) if value and value.is_a? String
          value = value.strftime('%Y-%m-%d') if value and (value.is_a?(Date) or value.is_a?(DateTime))
          json << %Q("#{value}",)
        end
        json.chop! << "]},"
      end
      json.chop! << "]}"
    else
      json << "}"
    end
  end
  
  def to_local_jqgrid_hash(attributes)
    result = "[ "
    each do |elem|
      result << %Q({)
      attributes.each do |atr|
        value = elem[atr]
        value = our_escape_javascript(value) if value and value.is_a? String
        value = value.strftime('%Y-%m-%d') if value and (value.is_a?(Date) or value.is_a?(DateTime))
        result << %Q("#{atr}":"#{value}",)
      end
      result.chop! << "},"
    end
    result.chop! << "]"
  end
  
  private
  
  #roy 
  def our_escape_javascript(javascript)
    if javascript
      javascript = javascript.gsub(/(\\|<\/|\r\n|[\n\r"])/) { JS_ESCAPE_MAP[$1] }
      
    else
      ''
    end
  end
  
  def get_atr_value(elem, atr, couples)
    if atr.to_s.include?('.')
      value = get_nested_atr_value(elem, atr.to_s.split('.').reverse) 
    else
      value = couples[atr]
      value = elem.send(atr.to_sym) if value.blank? && elem.respond_to?(atr) # Required for virtual attributes
    end
    value
  end
  
  def get_nested_atr_value(elem, hierarchy)
    return nil if hierarchy.size == 0
    atr = hierarchy.pop
    raise ArgumentError, "#{atr} doesn't exist on #{elem.inspect}" unless elem.respond_to?(atr)
    nested_elem = elem.send(atr)
    return "" if nested_elem.nil?
    value = get_nested_atr_value(nested_elem, hierarchy)
    value.nil? ? nested_elem : value
  end
end

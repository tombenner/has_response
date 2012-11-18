module HasResponse
  extend ActiveSupport::Concern

  def to_response_with(*attributes)
    raise "Class `#{self.class.name}' does not have a `to_response' method defined" and return nil if !respond_to?(:to_response)
    response = self.to_response
    attributes.each do |attribute|
      if attribute.is_a?(Hash)
        attribute.each do |key, value|
          response[format_response_key(key)] = format_response_value(self.send(key), value)
        end
      elsif attribute.is_a?(Array)
        attribute.each do |key|
          response[format_response_key(key)] = format_response_value(self.send(key))
        end
      elsif attribute.is_a?(Symbol)
        response[format_response_key(attribute)] = format_response_value(self.send(attribute))
      end
    end
    response
  end

  def format_response_key(key)
    key = key.to_s
    key.sub!(/\?$/, '')
    key.to_sym
  end

  def format_response_value(value, with=nil)
    if value.nil?
      nil
    elsif value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(String) || value.is_a?(Symbol) || value.is_a?(Integer)
      value
    elsif value.is_a?(ActiveRecord::Relation) || value.is_a?(Array)
      value.collect do |record|
        with.nil? ? record.to_response : record.to_response_with(with)
      end
    else
      with.nil? ? value.to_response : value.to_response_with(with)
    end
  end
end